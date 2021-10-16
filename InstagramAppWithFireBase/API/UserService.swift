//
//  UserService.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-14.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void

// MARK: - getDocuments User ユーザーの情報を取得する
struct UserService {
    static func fetchUser(whithUid uid: String ,completion: @escaping (User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument{snapshot, error in
            guard let dictonary = snapshot?.data() else { return }
            
            let user = User(dictonary: dictonary)
            completion(user)
        }
    }
    static func fetchUsertest(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // DocumentSnapshotで単体のDocumentを取得
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let dictonary = snapshot?.data() else { return }
            let user = User(dictonary: dictonary)
            completion(user)
        }

    }
//COLLECTION_USERSの情報を全て取ってくる　コールバックで[User]を返す
    static func fetchUsers(completion: @escaping ([User]) -> Void) {
      // QuerySnapshotで配列の型を取得
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            let users = snapshot.documents.map({User(dictonary: $0.data())})
            completion(users)
        }
    }
    static func follow(uid: String, completion: @escaping (FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        //自分自身のフォロワーなのでcurrentUidが必要
        //collection("following")のdocument(自分自身のuidドキュメントで).collection("user-following")にフォローしたユーザーのuidをセットする
        COLLETION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { (error) in
            //上が終わったらcollection("followers")のdocument(フォローしたuidドキュメントに).collection("user-followers").上と逆のことをしてる
            COLLETION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid: String, completion: @escaping (FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        //collection("following")のdocument(自分自身のuidドキュメントで.collection("user-following")にフォローしたユーザーのuidを削除する
        COLLETION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { (error) in
            //相手のフォロワーからも自分のuidを削除する
            COLLETION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    //ユーザーをフォローしてる判断する処理
    static func checkIfUserIsFolloed(uid: String, completion: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLETION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { (snapshot, error) in
            //exists関数でsnapshotがあるか判断することができる
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
        
    static func fetchUserStats(uid: String, completion: @escaping (UserStats) -> Void) {
        COLLETION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, _) in
            //let snapshot: QuerySnapshot? <- 配列
            //followersのDocumentが何個あるか判断する
            let followers = snapshot?.documents.count ?? 0
            //フォローしてるDocument（ユーザーの数を判断する
            COLLETION_FOLLOWING.document(uid).collection("user-following").getDocuments { (snapshot, _) in
                let following = snapshot?.documents.count ?? 0
                completion(UserStats(followers: followers, following: following))
                
//                COLLETION_POSTS.whereField("ownerUid", isEqualTo:  uid).getDocuments { (snapshot, _) in
//                    let posts = snapshot?.documents.count ?? 0
//                    completion(UserStats(followers: followers, following: following, posts: posts))

                }
            }
        }
    }
    

