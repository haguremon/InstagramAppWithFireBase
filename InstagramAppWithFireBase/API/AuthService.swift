//
//  AuthService.swift
//  InstagramClone
//
//  Created by James Tang on 2021-02-10.
//

import UIKit
import Firebase
//Authに送る情報モデルの作成
struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct  AuthService {
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping (Error?) -> Void){
        print("DEBUG: Credentials are \(credentials)")
        
        ImageUploader.uploadImage(image: credentials.profileImage) { (imageUrl) in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("DEBUG: Failed to register user\(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                //fieldに追加するデータ達
                let data: [String: Any] = ["email": credentials.email, "fullname": credentials.fullname, "profileImageUrl": imageUrl, "uid": uid, "username": credentials.username]
               //collection("users"）のパスが被ることがないuidのでキュメントにdataをつける
                Firestore.firestore().collection("users").document(uid).setData(data,  completion:  completion)
            }
        }
    }
    
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?){
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}
