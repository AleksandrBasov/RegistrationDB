//
//  SignUpViewController.swift
//  Registration
//
//  Created by Александр Басов on 11/9/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    // MARK: - Data
    var ref: DatabaseReference!
    
    // MARK: - UI
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
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
private extension SignUpViewController {
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLBL(withText: "Info is incorrect")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                self?.displayWarningLBL(withText: "Registration was incorrect \(error.localizedDescription)")
                print(error.localizedDescription)
            } else {
                guard let user = user else { return }
                let userRef = self?.ref.child(user.user.uid)
                userRef?.setValue(["email": user.user.email])
            }
            self?.transitionToHome()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Configure
private extension SignUpViewController {
    
    func configure() {
        setUpElements()
        ref = Database.database().reference(withPath: "users")
    }
}

// MARK: - SetUpElements
private extension SignUpViewController {
    func setUpElements() {
        errorLbl.alpha = 0
        Utilities.styleTextField(nameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFieldButton(signUpButton)
    }
}

// MARK: - TransitionToHome
private extension SignUpViewController {
    func transitionToHome(){
       let HomeViewContr = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = HomeViewContr
        view.window?.makeKeyAndVisible()
    }
}

// MARK: - DisplayWarningLBL
private extension SignUpViewController {
    func displayWarningLBL(withText text: String) {
        errorLbl.text = text
        UIView.animate(withDuration: 6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in self?.errorLbl.alpha = 1 } completion: { [weak self] _ in self?.errorLbl.alpha = 0
        }
    }
}

// MARK: - UpdateTextField
private extension SignUpViewController {
    func updateTextField() {
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}

