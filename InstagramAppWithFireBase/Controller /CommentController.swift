//
//  CommentController.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-13.
//

import UIKit

private let reuseIdentifer = "CommentCell"

class CommentController: UICollectionViewController {
//
//    // MARK: - Properties
    private var comments = [Comment]()
//
    private let post: Post
//
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView(frame: frame)
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        return cv
    }()
//
//    // MARKL - Lifecycle
//
 //Postの情報を持ってる時に初期化して作成する
    init(post: Post) {
        self.post = post
        let layout = UICollectionViewFlowLayout()
               //
        layout.minimumLineSpacing = 0.5
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = .systemBackground
        configureCollectionView()
        fetchComments()
   
   }
//
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
//
    override var canBecomeFirstResponder: Bool{
        return true
    }
//viewDidLoad()が呼ばれる前にtabBarを隠す
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //collectionView.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isHidden = true
    }
//CommentControllerから離れるときにtabBarを表示する　そうしないと消えたままになる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
//
//    // MARK: - API
//コメントを取得
    func fetchComments(){
        CommentServerice.fetchComments(forPost: post.postId) { (comment) in
            self.comments = comment
            self.collectionView.reloadData()
        }
    }
//
//    // MARK: - Helpers
    func configureCollectionView(){
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        //この２つでキーボード下にした時に閉じる
       
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
    }
}




// MARK: - UICollectionViewDataSource
//
extension CommentController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! CommentCell
        cell.backgroundColor = .systemBackground
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
}
//
//// MARK: - UICollectionViewDelegateFlowLayout
extension CommentController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        return CGSize(width: view.frame.width, height: height)
    }
}
//
//// MARK: - UIColletionViewDelegate
//
extension CommentController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = comments[indexPath.row].uid
        UserService.fetchUser(whithUid: uid) { (user) in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
//
//// MARK: - CommentInputAccesoryViewDelegate
//ここでコメントをアップロードする処理
extension CommentController : CommentInputAccesoryViewDelegate{
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
print("\(comment)")
        inputView.clearCommentTextView()
//
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
//
       showLoader(true)
//
        print("\(post.postId)")
       CommentServerice.uploadComment(comment: comment, postID: post.postId, user: currentUser) { (error) in
           self.showLoader(false)
//            inputView.clearCommentTextView()
//
//            NotificationService.uploadNotification(toUid: self.post.ownerUid, fromUser: currentUser, type: .comment, post: self.post)
       }
    }
}
