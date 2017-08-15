//
//  SignInVC.swift
//  JTSocialMedia
//
//  Created by Jiří Tomis on 08.08.17.
//  Copyright © 2017 JT. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("DAMN: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    @IBAction func facebookBtnPushed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("DAMN: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("DAMN: User cancelled Facebook authentication")
            } else {
                print("DAMN: Sucesfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if error != nil {
                print("DAMN: Unable to authenticate with Firebase - \(error)")
            } else {
                print("DAMN: Successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: pwd) { (user, error) in
                if error == nil {
                    print("DAMN: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd) { (user, error) in
                        if error != nil {
                            print("DAMN: Unable to authenticate with Firebase using email - \(error)")
                        } else {
                            print("DAMN: Sucessfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keyResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("DAMN: Data saved to keychain \(keyResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}





















