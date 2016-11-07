//
//  ViewController.swift
//  FirebaseSocialLogin
//
//  Created by Stanley Pan on 25/10/2016.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    lazy var facebookLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.delegate = self
        button.readPermissions = ["email", "public_profile"]
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var customFacebookLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("Custom FB Login here", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(facebookLoginButton)
        view.addSubview(customFacebookLoginButton)
       
        setupFacebookLoginButton()
        setupCustomFacebookLoginButton()
    }
    
    // iOS constraints x, y, width, height
    func setupFacebookLoginButton() {
        facebookLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        facebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookLoginButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupCustomFacebookLoginButton() {
        customFacebookLoginButton.topAnchor.constraint(equalTo: facebookLoginButton.bottomAnchor, constant: 16).isActive = true
        customFacebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customFacebookLoginButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        customFacebookLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            
            if error != nil {
                print("Custom FB Login failed: \(error)")
                return
            }
            
            self.showEmailAddress()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        showEmailAddress()
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong.")
                return
            }
            
            print("Successfully logged in with our user: \(user)")
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            
            if error != nil {
                print("Failed to start graph request: \(error)")
                return
            }
            
            print(result!)
        }
    }
}





