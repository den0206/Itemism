//
//  MessageViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/13.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender : SenderType {
    
    var senderId: String
    var displayName: String

}

class MessageViewController : MessagesViewController {
    
    var chatRoomId : String!
    var membersIds : [String]!
    var membersToPush : [String]!

    //MARK: - property
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessagekit()
        hideCurrentUserAvatar()
    
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
    
}


//MARK: - MessageKit Delegate

extension MessageViewController : MessagesDataSource {
    func currentSender() -> SenderType {
        
        return Sender(senderId: User.currentId(), displayName: User.currentUser()!.name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        let message = Message(text: "Test", sender: Sender(senderId: User.currentId(), displayName: "AAA"), messageId: "111", date: Date())
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        return 5
        
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section % 3 == 0 {
            
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
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
        return 30
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 35
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
    
    func showCamera() {
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
}
