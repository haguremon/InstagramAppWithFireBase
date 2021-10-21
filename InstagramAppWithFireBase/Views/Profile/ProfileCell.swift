//
//  ProfileCell.swift
//  InstagramClone
//
//  Created by James Tang on 2021-02-13.
//

import UIKit
import SDWebImage

class ProfileCell: UICollectionViewCell{
    
    // MARK: - Properties
    //ProfilVC初期化された時にconfigure()を発動する
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
  
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        
        addSubview(postImageView)
        postImageView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        guard let viewModel = viewModel else { return }

        postImageView.sd_setImage(with: viewModel.imageUrl)
    }
}
