//
//  FeedController.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-13.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
class FeedController: UICollectionViewController {
//
//    // MARK: - Lifecycle
    private var posts = [Post]() {
        didSet{ collectionView.reloadData() }
    }
//プロフィールviewで選択されたものが渡る
    var post: Post?{
        didSet {
            collectionView.reloadData()
        }
    }
  
    override func viewDidLoad() {
       super.viewDidLoad()
        configureUI()
        fetchPosts()
        view.backgroundColor = .systemGroupedBackground
//        fetchPosts()
//
//        if post != nil {
//            checkIfUserLikedPosts()
//        }
//
   }
//
//    // MARK: - Action
    @objc func habdleRefresh(){
        //ここで下に引っ張った時の処理
        //posts.removeAll()をすべて消して
        posts.removeAll()
        //ここでもう一回postsに入れる
        fetchPosts()

    }

    @objc func habdleLogout(){
        do{
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }catch{
            print("DEBUG: Failed to sign out")
        }
    }
//    // MARK: - API
    //一度削除してからもう一度ポストを行う
    func fetchPosts(){
        
        guard post == nil else { return }
        //postがnilの時fetchPostsをする
        PostService.fetchPosts { (posts) in
            self.posts = posts
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            // self.checkIfUserLikedPosts()
        }
    }
//        PostService.fetchFeedPosts{ posts in
//            self.posts = posts
//            self.collectionView.refreshControl?.endRefreshing()
//            self.checkIfUserLikedPosts()
//        }
//    }
//
//    func checkIfUserLikedPosts(){
//        if let post = post {
//            PostService.checkIfUserLikedPost(post: post) { didLike in
//                self.post?.didLike = didLike
//            }
//        }else {
//            posts.forEach{ post in
//                PostService.checkIfUserLikedPost(post: post) { (didLike) in
//                    if let index = self.posts.firstIndex(where: {$0.postId == post.postId}){
//                        self.posts[index].didLike = didLike
//                    }
//                }
//            }
//        }
//
//    }
//
//    // MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .systemGroupedBackground

        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//
        if post == nil {

        //post == nilだった場合は
        //leftBarにログアウトボタンを作成
        navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(habdleLogout))
        }
        navigationItem.leftBarButtonItem?.tintColor = .secondaryLabel
        navigationItem.titleView?.tintColor = .secondarySystemBackground
        
        navigationItem.title = "Feed"
///collectionを下に引っ張る時にくるくるした時の処理をする
        let refresher = UIRefreshControl()
         refresher.addTarget(self, action: #selector(habdleRefresh), for: .valueChanged)
         refresher.tintColor = .secondaryLabel
         collectionView.refreshControl = refresher
    }

}
    


// MARK: - UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
       // cell.backgroundColor = .purple
        print("cellで設定\(cell.delegate)")
        //cell.delegateをFeedControllerに任せる
        cell.delegate = self
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        }else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        cell.backgroundColor = .systemGroupedBackground
        
        return cell
    }
}
//
// MARKL - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        return CGSize(width: width, height: height)
    }
}
//
//// MARK: - FeedCellDelegat //FeedControllerに処理を任せる
extension FeedController: FeedCellDelegat {
//    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
//        UserService.fetchUser(whithUid: uid) { (user) in
//            let controller = ProfileController(user: user)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
       // let controller = CommentController(post: post)
        print("遷移の処理は任せて\(post.caption)")
        let controller = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
}
}
//    
//    func cell(_ cell: FeedCell, didLike post: Post) {
//       
//        guard let tab = tabBarController as? MainTabController else { return }
//        guard let user = tab.user else { return }
//        
//        cell.viewModel?.post.didLike.toggle()
//        if post.didLike{
//            PostService.unlikePost(post: post) { error in
//                if let error = error {
//                    print("DEBUG: Failed to like post with \(error)")
//                }
//                
//                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
//                cell.likeButton.tintColor = .black
//                cell.viewModel?.post.likes = post.likes - 1
//            }
//        }else {
//            PostService.likePost(post: post){ error in
//                if let error = error {
//                    print("DEBUG: Failed to like post with \(error)")
//                }
//                
//                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
//                cell.likeButton.tintColor = .red
//                cell.viewModel?.post.likes = post.likes + 1
//                
////                NotificationService.uploadNotification(toUid: post.ownerUid, profileImageUrl: post.ownerImageUrl, username: post.ownerUsername, type: .like, post: post)
//                
//                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
//            }
//        }
//    }
//    
//}
