//
//  CommentServerice.swift
//  InstagramClone
//
//  Created by James Tang on 2021-02-20.
//

import Firebase

struct CommentServerice {
    
    static func uploadComment(comment: String,
                              postID: String,
                              user: User, completion: @escaping (FirestoreCompletion)) {
        //コメントをするユーザーの情報もuploadする
        let data : [String: Any] = ["uid": user.uid,
                                    "comment": comment,
                                    "timestamp": Timestamp(date: Date()),
                                    "username": user.username,
                                    "profileImageUrl": user.profileImageUrl]
        //ドキュメントID = Document.id
        //uploadデータを Posts(コレクション)した(PostsのドキュメントID)のサブコレクッションとして’comments’を作成してドキュメントid( QueryDocumentSnapshot.Document.id)のフィールドに(dataを入れる)//addDocumentを作成するときにDocument.idも作成されると思う
      ////uploadデータを Posts(コレクション)した(PostsのドキュメントID)のサブコレクッションとして’comments’を作成
        COLLETION_POSTS.document(postID).collection("comments").addDocument(data: data,
                                                                            completion: completion)
    }
    
    static func fetchComments(forPost postID: String, completion: @escaping([Comment]) -> Void){
        var comments = [Comment]()
       // postID = DocumentReference.documentID //UUIDみたいなのが格納されてる
        let query = COLLETION_POSTS.document(postID).collection("comments").order(by: "timestamp", descending: true)
       //addSnapshotListenerを使用することで、指定したコレクションの自動検知を行ってくれる処理
       //https://note.com/s_kadota/n/n3f1f3e61e672
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                //documentChangesがある時
                if change.type == .added {
                    //addedされるときに
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            
            completion(comments)
        }
    }
}
