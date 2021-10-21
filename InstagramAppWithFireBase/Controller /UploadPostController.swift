//
//  UploadPostController.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-13.
//

import UIKit

//ここで委任する
protocol UploadPostControllerDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}
//画面を選択したらここに移動して　メモ等をfirebaseに保存する
class UploadPostController: UIViewController {
//
//    // MARK: - Properties
    weak var delegate: UploadPostControllerDelegate?
    var currentUser: User?
//
//
    var selectedImage: UIImage? {
        didSet{ photoImageView.image = selectedImage }
    }
//
//
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter caption...."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .label
        tv.delegate = self
        tv.placeholderShouldCenter = false
        return tv
    }()

    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()

//    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       // view.backgroundColor = .orange
    }
//
//    // MARK: - Actions
    @objc func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
//
    @objc func didTapDone() {
   
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        //ここでインジケーターが発動する
        showLoader(true)
//
        PostService.uploadPost(caption: caption, image: image, user: user) { (error) in
            //uploadできたらインジケーターが終わる
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to upload post \(error.localizedDescription)")
                return
            }
            //ポストが成功した時の処理 tabバーもホームに移動したいのでプロトコルを使って委任する
//            self.dismiss(animated: true, completion: nil)
//            self.tabBarController?.selectedIndex = 0
            print("didTapDone()")//delegateに値が入ってるのでcontrollerDidFinishUploadingPost()を使うことができる
            //rightBarButtonItemが押された時にcontrollerDidFinishUploadingPostが発動する
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
//
//    // MARK: - Helpers
    func checkMaxLength(_ textView: UITextView){
       //のカウントを超える場合は
        if (textView.text.count) > 100 {
            //UITextViewに入力できないくなる
            textView.deleteBackward()
        }
    }
//
    func configureUI(){
       
        view.backgroundColor = .systemGroupedBackground
        captionTextView.layer.borderWidth = 1
        captionTextView.layer.borderColor = UIColor.secondaryLabel.cgColor
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))

        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10

        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 3, paddingLeft: 12, paddingRight: 12, height: 64)

        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor,paddingBottom: 0, paddingRight: 14)


    }
}


// MARK: - UITextFieldDelegate
//textViewの文字のカウントを認知することができる
extension UploadPostController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
