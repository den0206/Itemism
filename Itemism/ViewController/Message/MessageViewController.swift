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
import FirebaseStorage
import InputBarAccessoryView
import SDWebImage
import SKPhotoBrowser

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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visbleRect = CGRect()
        visbleRect.origin = self.messagesCollectionView.contentOffset
        visbleRect.size = self.messagesCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visbleRect.midX, y: visbleRect.midY)
        
        guard let indexPath = self.messagesCollectionView.indexPathForItem(at: visiblePoint) else {return}
        
        if indexPath.section == 3 {
            print("More")
        }
        
    }
    
    //MARK: - Actions
    @objc func handleRefresh() {
        
        fetchMoreMessage()
        
        refreshController.endRefreshing()
    }
    
    //MARK: - long Tap
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        let message = messageLists[indexPath.section]
        
        switch action {
        case NSSelectorFromString("delete:"):
            
            if message.sender.senderId == User.currentId() {
                return true
            } else {
                return super.collectionView(collectionView, canPerformAction: action, forItemAt: indexPath, withSender: sender)
            }
         default:
            return super.collectionView(collectionView, canPerformAction: action, forItemAt: indexPath, withSender: sender)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        let storage = Storage.storage()
        
        let message = messageLists[indexPath.section]
        let messageId = message.messageId
        
        // delete message
        
        if action == NSSelectorFromString("delete:") {
            
            guard Reachabilty.HasConnection() else {
                self.showAlert(title: "Error", message: "No Internet Connetction")
                return
                
            }
            
            switch message.kind {
            case .text:
                print("Delete TExt")
            case.photo(let photItem) :
                guard let imageUrl = photItem.url else {return}
                storage.reference(forURL: imageUrl.absoluteString).delete { (error) in
                    
                    if error != nil {
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                        return
                    }
                    SDImageCache.shared.removeImage(forKey: imageUrl.absoluteString, withCompletion: nil)
                }
                
            default:
                return
            }
            
            
            /// reload via didSet
            objectMessages.remove(at: indexPath.section)
            messageLists.remove(at: indexPath.section)
            
            
            /// delete from fireStore
            
            self.deleteMessageFromFirestore(withIds: membersIds, messageId: messageId)
            
            // get LastMessage
            
            firebaseReference(.Message).document(User.currentId()).collection(chatRoomId).order(by: kDATE, descending: true).limit(to: 1).getDocuments { (snapshot, error) in
                
                guard let snapshot = snapshot else {return}
                
                if !snapshot.isEmpty {
                    let lastMessage = snapshot.documents[0][kMESSAGE] as! String
                    Recent.updateRecent(chatRoomId: self.chatRoomId, lastMessage: lastMessage)
                    
                } else {
                    Recent.updateRecent(chatRoomId: self.chatRoomId, lastMessage: "削除されました。")
                }
            }
            
        } else {
            /// another action
            
            super.collectionView(collectionView, performAction: action, forItemAt: indexPath, withSender: sender)
        }
    }
    
    func deleteMessageFromFirestore(withIds : [String], messageId : String) {
        
        withIds.forEach { (userId) in
            firebaseReference(.Message).document(userId).collection(chatRoomId).document(messageId).delete(completion: nil)
        }
    }
 
}

extension MessageCollectionViewCell {

    override open func delete(_ sender: Any?) {
        
        // Get the collectionView
        if let collectionView = self.superview as? UICollectionView {
            // Get indexPath
            if let indexPath = collectionView.indexPath(for: self) {
                // Trigger action
                collectionView.delegate?.collectionView?(collectionView, performAction: NSSelectorFromString("delete:"), forItemAt: indexPath, withSender: sender)
            }
        }
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
    
    /// user SDWEB image
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
           case .photo:
               guard case .photo(let mediaItem) = message.kind else { fatalError() }
               if let url = mediaItem.url {
                imageView.sd_setImage(with: url)
               }
           default:
               break
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
        
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {return}
        guard let messageDatasource = messagesCollectionView.messagesDataSource else {return}
        
        let message = messageDatasource.messageForItem(at: indexPath, in: messagesCollectionView)
        
       print(message)
    }
    func didTapImage(in cell: MessageCollectionViewCell) {
         guard let indexPath = messagesCollectionView.indexPath(for: cell) else {return}
        guard let messageDatasource = messagesCollectionView.messagesDataSource else {return}
        
        let message = messageDatasource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        switch message.kind {
        case .photo(let photItem):
            
            guard let imageUrl = photItem.url?.absoluteString else {return}
            var images = [SKPhoto]()
            let photo = SKPhoto.photoWithImageURL(imageUrl)
            images.append(photo)
            
            let browser = SKPhotoBrowser(photos: images)
            browser.initPageIndex = 0
            present(browser, animated: true, completion: nil)
            
            
        default:
            return
        }
        
        
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
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)

    }
    
    @objc func handleSwitch(_ sender : UISwitch) {
        
        if sender.isOn {
            print("On")
        }
    }
}

extension MessageViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if Reachabilty.HasConnection() {
            
            self.navigationController?.showPresentLoadindView(true, message: "Updating")
            
            picker.dismiss(animated: true, completion: {
                
                sleep(2)
                
                let pic = info[.editedImage] as? UIImage
                self.send_message(text: nil, picture: pic)
                
            })
            
        } else {
            
            picker.dismiss(animated: true) {
                self.navigationController?.showPresentLoadindView(false)
                self.showAlert(title: "Error", message: "No Internet Connection")
            }
            
        }
        
        
        
    }
}
