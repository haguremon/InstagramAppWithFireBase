//
//  CommentInputAccesoryView.swift
//  InstagramClone
//
//  Created by James Tang on 2021-02-20.
//

import UIKit

protocol CommentInputAccesoryViewDelegate: AnyObject {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String)
}

class CommentInputAccesoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CommentInputAccesoryViewDelegate?
    
    private let commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter comment..."
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.backgroundColor = .systemBackground
       
        tv.textColor = .label
        tv.placeholderShouldCenter = true
        return tv
    }()
 //postボタンが押された時にコレクッションのpostsのPostした人の(uid)ドキュメントにサブコレクションのCommentに値を入れる
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        //サブビューのサイズを自動的に変更することができる
        autoresizingMask = .flexibleHeight
        backgroundColor = .systemBackground
        addSubview(postButton)
        postButton.anchor(top:topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor,bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.borderColor = UIColor.systemGray.cgColor
        commentTextView.layer.cornerRadius = 10
    
    }
   //カスタムビューは、そのコンテンツに基づいて、どのようなサイズにしたいかをレイアウトシステムに伝えることができる
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    // MARK: - Actions
    @objc func handlePostTapped(){
        //委任した所に処理を任せる
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
    
    // MARK: - Helpers
    func clearCommentTextView(){
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
}
