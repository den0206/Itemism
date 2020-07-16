//
//  MessageViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/13.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView

struct Sender : SenderType {
    
    var senderId: String
    var displayName: String

}

class MessageViewController : MessagesViewController {
    
    var chatRoomId : String!
    var membersIds : [String]!
    var membersToPush : [String]!
    var profileImage : UIImage?
    
    var messageLists = [Message]() {
        didSet {
            messagesCollectionView.reloadData()
        }
    }
    var objectMessages = [NSDictionary]()
    
    var newChatListner : ListenerRegistration?
    
    var lastDocument : DocumentSnapshot? {
        didSet {
            configureRefresh()
        }
    }
    
    let refreshController = UIRefreshControl()

    //MARK: - property
    
    deinit {
        newChatListner?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessagekit()
        hideCurrentUserAvatar()
        
        loadFirstMessage()
    
    }
    
    //MARK: - UI
    
    private func configureMessagekit() {
        
        configureInputView()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
        
        maintainPositionOnKeyboardFrameChanged = true
        
        
    }
    
    private func configureInputView() {
           messageInputBar.sendButton.tintColor = .darkGray
           messageInputBar.backgroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
           messageInputBar.inputTextView.backgroundColor = .white
       }
    
    private func configureRefresh() {
        
        if messageLists.count > 11 {
            messagesCollectionView.refreshControl = refreshController
            refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        }
        
    }
    
    //MARK: - Actions
    @objc func handleRefresh() {
        
        fetchMoreMessage()
        
        refreshController.endRefreshing()
    }

    
}


//MARK: - MessageKit Delegate

extension MessageViewController : MessagesDataSource {
    func currentSender() -> SenderType {
        
        guard let currentUser = User.currentUser() else {
            return Sender(senderId: "", displayName: "")
            
        }
        
        return Sender(senderId: User.currentId(), displayName: currentUser.name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messageLists[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        return messageLists.count
        
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section % 3 == 0 {
            
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    // TODO: - Add Read Status
      
      func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
          
          let messageDictionary = objectMessages[indexPath.section]
          let status : NSAttributedString
          
          if isFromCurrentSender(message: message) {
              switch messageDictionary[kSTATUS] as! String{
              case kDELIVERED:
                  status = NSAttributedString(string: kDELIVERED, attributes:  [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2), NSAttributedString.Key.foregroundColor : UIColor.lightGray] )
              case kREAD :
                  status = NSAttributedString(string: kREAD, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
              default:
                  status = NSAttributedString(string: "✔︎", attributes:  [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
              }
              
              return status
          }
          
          return nil
      }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let message = messageLists[indexPath.section]
        
        if !isFromCurrentSender(message: message) {
            
            if profileImage != nil {
                
                let avater = Avatar(image: profileImage!)
                avatarView.set(avatar: avater)
            } else {
                let avater = Avatar(initials: "?")
                avatarView.set(avatar: avater)
            }
            
            
        }
    }

    
    
    func hideCurrentUserAvatar() {
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
           layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
           layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
       }
    
    
}

extension MessageViewController : MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 30
    }
}


extension MessageViewController : MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        isFromCurrentSender(message: message) ?
            UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) :
            UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(corner, .curved)
    }
    
    
}

extension MessageViewController : MessageCellDelegate {
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        return
    }
    
}

extension MessageViewController : InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        checkInternetConnection()
        
        
        if Reachabilty.HasConnection() {
            
            for component in inputBar.inputTextView.components {
                if let text = component as? String {
                    self.send_message(text: text, picture: nil)
                }
            }
            
            finishSendMessage()
        }
        
    }
    
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if text == "" {
            showCamera()
        } else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: true)
        }
    }
    
    // finish Sending
    func finishSendMessage() {
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
        
    }
    
}

//MARK: - Accesary View

extension MessageViewController {
    
   func configureAccesary() {
        
        let bubbleSwitch = UISwitch()
        messageInputBar.addSubview(bubbleSwitch)
    bubbleSwitch.addTarget(self, action: #selector(handleSwitch(_ :)), for: .valueChanged)
        
        
        
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: true)
    bubbleSwitch.anchor(top : messageInputBar.leftStackView.topAnchor,left: messageInputBar.leftAnchor, bottom: messageInputBar.leftStackView.bottomAnchor,right: messageInputBar.inputTextView.leftAnchor,paddingTop: 4,paddingLeft: 4,paddingBottom: 4,paddingRight: 4)
        
        showCamera()

    }
    
    private func showCamera() {
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .darkGray
        cameraItem.image = UIImage(systemName: "camera")
        
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: true)
        cameraItem.addTarget(self, action: #selector(handleCamera), for: .touchUpInside)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setRightStackViewWidthConstant(to: 50, animated: true)
        messageInputBar.setStackViewItems([cameraItem], forStack: .right, animated: true)
    }
    
    @objc func handleCamera() {
        
        // TODO: - image picker

    }
    
    @objc func handleSwitch(_ sender : UISwitch) {
        
        if sender.isOn {
            print("On")
        }
    }
}
