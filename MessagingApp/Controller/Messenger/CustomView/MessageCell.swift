//
//  messageCell.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/20/21.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewWidth: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var textViewTrailing: NSLayoutConstraint?
    @IBOutlet weak var textViewLeading: NSLayoutConstraint?
    
    var messageInfo: Message? {
        didSet {
            messageTextView.text = messageInfo?.message
            
            if let message = messageInfo {
                setupView(sender: message)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = .flexibleHeight
        
        background.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        background.layer.sublayers?.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.background.addPointer(direction: self.messageInfo?.type == .own ? .right : .left)
        }
    }
    
    func setupView(sender: Message) {
        let sizeInMaxWidth = CGSize(width: .max, height: 37)
        let estimatedWSize = messageTextView.sizeThatFits(sizeInMaxWidth)
        let width = estimatedWSize.width
        let maxWidth = UIScreen.main.bounds.width * 0.8
        
        textViewWidth.constant = width > maxWidth ? maxWidth : width
        
        let sizeInMaxHeight = CGSize(width: textViewWidth.constant, height: .infinity)
        let estimatedHSize = messageTextView.sizeThatFits(sizeInMaxHeight)
        let height = estimatedHSize.height
        
        textViewHeight.constant = height < 37 ? 37 : height
        
        if sender.type == .own {
            if textViewTrailing != nil {
                textViewTrailing?.priority = .defaultHigh
            }
            
            if textViewLeading != nil {
                textViewLeading?.priority = .defaultLow
            }
            
            userName.isHidden = false
            senderName.isHidden = true
            userName.text = sender.name
        } else {
            if textViewTrailing != nil {
                textViewTrailing?.priority = .defaultLow
            }
            
            if textViewLeading != nil {
                textViewLeading?.priority = .defaultHigh
            }
            
            userName.isHidden = true
            senderName.isHidden = false
            senderName.text = sender.name
        }
    }
}
