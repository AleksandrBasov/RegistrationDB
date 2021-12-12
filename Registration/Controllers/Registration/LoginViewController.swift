//
//  LoginViewController.swift
//  Registration
//
//  Created by Александр Басов on 11/9/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    // MARK: - Data
    var ref: DatabaseReference!
    
    // MARK: - UI
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        updateTextField()
    }
}


// MARK: - Action
private extension LoginViewController {
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLBL(withText: "Info is incorrect")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let _ = error {
                self?.displayWarningLBL(withText: "Error ocured")
            } else if let _ = user {
                self?.transitionToHome()
                return
            } else {
                self?.displayWarningLBL(withText: "No such user")
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Configure
private extension LoginViewController {
    func configure() {
        setUpElements()
        ref = Database.database().reference(withPath: "users")
    }
}

// MARK: - SetUpElements
private extension LoginViewController {
    func setUpElements() {
        errorLbl.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFieldButton(loginButton)
    }
}

// MARK: - DisplayWarningLBL
private extension LoginViewController {
    func displayWarningLBL(withText text: String) {
        errorLbl.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in self?.errorLbl.alpha = 1 } completion: { [weak self] _ in self?.errorLbl.alpha = 0
        }

    }
}

// MARK: - TransitionToHome
private extension LoginViewController {
    func transitionToHome(){
       let HomeViewContr = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = HomeViewContr
        view.window?.makeKeyAndVisible()
    }
}
// MARK: - UpdateTextField
private extension LoginViewController {
    func updateTextField() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}

