//
//  LoginController.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-13.
//

import UIKit

protocol  AuthenticationDelegate: AnyObject {
    func authenticationDidComplete()
}

class LoginController: UIViewController{
    
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.textContentType = .oneTimeCode
        //tf.textContentType = .newPassword
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
        button.addTarget(self, action: #selector(handleShowResetPassword), for: .touchUpInside)
        return button
    }()
        
        
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textContentType = .newPassword
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    @objc func handleShowResetPassword(){
        print("Show Reset Password")
//        let controller = RessetPasswordController()
//        controller.delegate = self
//        controller.email = emailTextField.text
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleLogin(){
        print("LOG IN")
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text else { return }
        print("\(email)\n\(password)")
        AuthService.logUserIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                print("DEBUG: Failed to login user\(error.localizedDescription)")
                return
            }
            self?.dismiss(animated: true)

//            self.delegate?.authenticationDidComplete()
        }
    }
    
    @objc func handleShowSignUp() {
        print("Show Sign Up")
       let controller = RegisterationController()
//        controller.delegate = delegate
       // present(controller, animated: true, completion: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        //LOG IN VC　の値をviewModelのプロパティに伝える
    
        if sender == emailTextField {
            viewModel.email = sender.text
        
        } else {
            //emailTextField以外のUITextFieldなので  passwordTextField
            viewModel.password = sender.text
        }
     

//            loginButton.backgroundColor = viewModel.buttonBackgroundColor
//            loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
//        loginButton.isEnabled = viewModel.formIsValid
//        print(viewModel.formIsValid)
    //二つの値がLoginViewModelに伝わった後にボタンを押すことができる*1
      updateForm()
    }
    
    
    // MARK: - Helpers
    func configureUI(){
        configureGradientLayer()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left:  view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    //値の変更認知する
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

    }
}

// MARK: - FormViewModel
extension LoginController: FormViewModel{
    //*1
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }

}
//
//
//// MARK: - ResetPasswordControllerDelegate
//extension LoginController: ResetPasswordControllerDelegate{
//    func controllerDidSendResetPasswordLink(_ controller: RessetPasswordController) {
//        navigationController?.popViewController(animated: true)
//        showMessage(withTitle: "Success", message: "We sent a link to your email to reset your password")
//    }
//}


