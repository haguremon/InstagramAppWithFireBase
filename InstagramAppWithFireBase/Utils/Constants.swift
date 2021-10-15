//
//  Constants.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-15.
//

import Firebase

//それぞれのcollectionの設定
let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLETION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLETION_FOLLOWING = Firestore.firestore().collection("following")
let COLLETION_POSTS = Firestore.firestore().collection("posts")
let COLLETION_NOTIFICATION = Firestore.firestore().collection("notifications")



