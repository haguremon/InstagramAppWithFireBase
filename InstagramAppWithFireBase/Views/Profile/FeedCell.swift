//
//  FeedCell.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-13.
//

import UIKit


protocol FeedCellDelegat: AnyObject {
    //コメントviewに行くにはFeedControllerのFeedCellのcommentButtonを押さないといけない
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post)
    func cell(_ cell: FeedCell, didLike post: Post)
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String)
}

class  FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
        //PostViewModelが使われた時に
        var viewModel: PostViewModel?{
            didSet{ configure() }
        }
    //delegateを使って処理を委任する
    weak var delegate: FeedCellDelegat?
    //プロフィール写真のイメージ
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "venom-7")
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    // lazy load so the action will work until the init is done so don't need to put addTarget into init
    //lazyはインスタス化されても呼ばれないaddTargetされた時に呼ばれる
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("venom", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        button.tintColor = .label
        return button
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "venom-7")
        return iv
    }()
    
     lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
       
      button.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)

            button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
//
       // button.backgroundColor = .systemGroupedBackground
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTabLike), for: .touchUpInside)
        return button
    }()
  
    //
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTabComments), for: .touchUpInside)
        return button
    }()
    //
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .label
        return button
    }()
    //
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    //
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    //
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .label
        return label
    }()
    //
    //
    // MARK: - Lifecycle
    //制約などの設定とレイアウト
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionButtons()
        
        addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor, left:  leftAnchor, paddingTop: -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func showUserProfile(){
        print("did tap username")
                guard let viewModel = viewModel else { return }
                delegate?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUid)
    }
    //
    @objc func didTabLike(){
       
        print("did tap like")
                guard let viewModel = viewModel else { return }
                delegate?.cell(self, didLike: viewModel.post)
    }
    //
    @objc func didTabComments() {
        print("did tap comments")
        
                guard let viewModel = viewModel else { return }
        //delegateの処理をFeedControllerに任せる--cellでは遷移できない
        //PostViewModelのpostの情報がみたいので引数に渡してる
                delegate?.cell(self, wantsToShowCommentsFor: viewModel.post)
    }
    
    // MARK: - Helpers
        func configure(){
            guard let viewModel = viewModel else { return }
            captionLabel.text = viewModel.caption
            postImageView.sd_setImage(with: viewModel.imageUrl)
            profileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
            usernameButton.setTitle(viewModel.username, for: .normal)
            likesLabel.text = viewModel.likesLabelText
            //likeButton.tintColor = viewModel.likeButtonTintColor
            likeButton.setImage(viewModel.likeButtonImage, for: .normal)
            postTimeLabel.text = viewModel.timestampString
        }
    //
    
    func configureActionButtons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
    }
}
