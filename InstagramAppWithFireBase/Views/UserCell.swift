//
//  UserCell.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-15.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell{
    
    // MARK: - Properties
    var viewModel: UserCellViewModel? {
        didSet{
          configure()
        }
    }
//    var user: User? {
//        didSet {
//            configure()
//        }
//    }
//
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .label
        label.text = "venom"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test User"
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    //初期化された時に呼ばれる
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        //大きさ
        profileImageView.setDimensions(height: 48  , width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        //centerY Y軸の位置を　セルの12スペースのところにprofileImageViewを配置
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        //縦の関係
        stack.axis = .vertical
        
        stack.spacing = 4
        //二つが左寄りに
        stack.alignment = .leading
        addSubview(stack)
        //profileImageViewから右に８
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(docer:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(){
        guard let viewModel = viewModel else { return }

        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
    }
}
