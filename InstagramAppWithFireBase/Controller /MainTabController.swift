//
//  MainTabController.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-13.
//

import UIKit
import Firebase


class MainTabController: UITabBarController{
    //
    //    // MARK: - Lifecycle
    //
    //######2 ここに情報が入ったら
        var user: User? {
          didSet{
                guard let user = user else { return }
    //######3 ProfileControllerを初期化
              configureViewControllers(with: user)
        }
        }
    //
    //    //viewDidAppearでやると重たくなるらしい
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //
    //        checkIfUserIsLoggedIn()
    //        //logout()
    //
    //    }
    
    //######## 1 ユーザーの情報をMainTabControllerのプロパティに入れる
        func fetchUserStatsTest(){
            //コールバックを使ってProfileControllerのプロパティに代入する
            UserService.fetchUsertest { user in
                self.user = user
        
            }
    
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
           checkIfUserIsLoggedIn()
        fetchUserStatsTest()
        //        fetchUser()
        // logout()
        
    }
    
    //
    //    // MARK: - API
    
    //ホームでログイン中か判断する
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser == nil {
            //ログイン中じゃない場合はLoginControllerに移動する
            DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
            
            }
            
        }
    }
    //
        func fetchUser(){
            guard let uid = Auth.auth().currentUser?.uid else { return }
            UserService.fetchUser(whithUid: uid){ user in
                //self.user = user
            }
        }
    
    //    // MARK: - Helpers Tabの設定
    func configureViewControllers(with user: User){
        
        self.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_selected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        
        let notification = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        // Set Profile user
        //######3ProfileControllerのデータを更新する
        let profileController = ProfileController(user: user)

        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        viewControllers = [feed, search, imageSelector, notification, profile]
        
        tabBar.tintColor = .secondarySystemBackground
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        //NavigationControllerの設定
        let nav = UINavigationController(rootViewController: rootViewController)
        //tabBarItem.image
        nav.tabBarItem.image = unselectedImage
        //
        //tabBarItemがタッチされた時のイメージ
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    //写真が選択された時の処理
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { (items, _) in
          
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }

                //遷移動作
                let controller = UploadPostController()
                //ここで遷移渡しをしてuserの情報やselectedImageをUploadPostControllerにあげる
                controller.selectedImage = selectedImage
                print("didFinishPickingMedia ここで1")
                //ここですでにcontrollerDidFinishUploadingPost()を保持
                controller.delegate = self
               //投稿してユーザーの情報を　渡す
                controller.currentUser = self.user
                //UploadPostControllerはUINavigationを含むのでrootViewControllerにして入れた
                let nav = UINavigationController(rootViewController: controller)
                
                nav.modalPresentationStyle = .fullScreen
                
                self.present(nav, animated: false, completion: nil)
            }
        }

        
    }
    
    
}

// MARK: - AuthenticationDelegate
//ユーザー情報を更新して移動するメソッド
extension MainTabController: AuthenticationDelegate{
    func authenticationDidComplete(){
        print("ここが呼ばれるはず")
//        fetchUser()
        fetchUserStatsTest()
        self.dismiss(animated: true, completion: nil)

    }
}
//
//
//// MARK: - UITabBarControllerDelegate
extension MainTabController: UITabBarControllerDelegate {

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex( of: viewController)
       
        if index == 2 {
            
            var config = YPImagePickerConfiguration()
            //config.bottomMenuItemSelectedTextColour = .secondaryLabel
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            //config.bottomMenuItemUnSelectedTextColour = .secondaryLabel
            
            config.albumName = "アルバム"
            config.preferredStatusBarStyle = .default
            config.hidesStatusBar = true
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            let picker = YPImagePicker(configuration: config)

            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: false, completion: nil)

            didFinishPickingMedia(picker)
        }
        return true
    }
}
//
//// MARK: - UploadPostControllerDelegate
extension MainTabController: UploadPostControllerDelegate{
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        print("UploadPostControllerDelegate")
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)

//        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
//        guard let feed = feedNav.viewControllers.first as? FeedController else { return }
//        feed.habdleRefresh()
    }

}
//
//
