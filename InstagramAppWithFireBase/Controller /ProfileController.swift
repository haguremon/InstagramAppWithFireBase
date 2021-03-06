//
//  ProfileController.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-13.
//

import UIKit

private let cellIdentifer = "ProfileCell"
private let haderIdentifier = "ProfileHeader"


class ProfileController: UICollectionViewController {
//    
//    // MARK: - Properties
////Profileでのユーザーを認識することができる
    private var user: User //{ //userに値が入った時reloadDataするようにする？
//         didSet {
//
//             collectionView.reloadData()
//
//         }
//    }
    //postのカウントと
    private var posts = [Post]()
//    
//    // MARK: - Lifecycle
//    
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init error")
    }
    
//
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsFolloed()
        configureCollectionView()
        fetchUserStats()
        navigationController?.navigationBar.tintColor = .label
        fetchPosts()
    }
//
//    // MARK: - API
//    
    //
    func checkIfUserIsFolloed() {
        UserService.checkIfUserIsFolloed(uid: user.uid) { (isFollowed) in
           //真だったらフォロイングになる
            self.user.isFollwed = isFollowed
            self.collectionView.reloadData()
        }
    }
    //firebaseから取得する

//
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid){ stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        print("user-stats:\(stats) ")
        }
    }
//    
    //Postsに入れる
    func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid) { (posts) in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
//    
//    
//    // MARK: - Helpers
    func configureCollectionView(){
        navigationItem.title = user.username
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifer)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: haderIdentifier)
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
       // cell.backgroundColor = .blue
       // cell.backgroundColor = .systemGroupedBackground
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: haderIdentifier, for: indexPath) as! ProfileHeader
       // header.backgroundColor = .systemGroupedBackground
        header.delegate = self
//        if let user = self.user {
            //ProfileHeaderでのviewModelプロパティが初期化せれた時にuserの情報を持っている関数がdidsetされる全てheader
            header.viewModel = ProfileViewModel(user: user)
        // }
        //header.backgroundColor = .purple
        
        return header
    }
}
//
//// MARK: - UICollectionViewDelegate
//
extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
       // ProfileControllerで選択したのをFeedControllerに一つ移す
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//
extension ProfileController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}
//
//// MARK: - ProfileHeaderDelegate
//
extension ProfileController: ProfileHeaderelegate {
    //editProfileFollowButtonが押された時に発動する
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
//        guard let tab = tabBarController as? MainTabController else { return }
//        guard let currentUser = tab.user else { return }
        if user.isCurrentUser {
            print("DEBUG: Show edit profile here....")
      } else if user.isFollwed {
           //フォロ＝されてる場合フォローを削除する
          UserService.unfollow(uid: user.uid) { (error) in
                self.user.isFollwed = false
                self.collectionView.reloadData()
//                PostService.updateUserFeedAfterFollowing(user: user, didFollow: false)
            }
            
      } else {
           //user.isFollwedがデフォルトのままでフォローされてない場合は押された時にフォローするようにする
            UserService.follow(uid: user.uid) { (error) in
                print("フォローされましたーUI変更")
                
                self.user.isFollwed = true
                self.collectionView.reloadData()

//                NotificationService.uploadNotification(toUid: user.uid, fromUser: currentUser, type: .follow)
//                PostService.updateUserFeedAfterFollowing(user: user, didFollow: true)
            }
        }
    }
}
