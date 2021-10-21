//
//  CommentViewModel.swift
//  InstagramClone
//
//  Created by James Tang on 2021-02-21.
//

import UIKit

struct CommentViewModel {
    
    private let comment: Comment
    
    var profileImageUrl: URL? {
        return URL(string: comment.profileImageUrl)
    }
    
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func commentLabelText() -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: "\(comment.username) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "\(comment.commentText)", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        return attributedString
    }
   //ここでlabelの大きさを測る
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        //attributedText プロパティの文字列全体に改行モードが適用したで
        label.lineBreakMode = .byWordWrapping //単語が一行に収まらない場合を除き、単語の境界で折り返しが行われること
        label.setWidth(width)
        //ビューの最適なサイズを返す
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
