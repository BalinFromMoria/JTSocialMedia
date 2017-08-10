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

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: pwd) { (user, error) in
                if error == nil {
                    print("DAMN: Email user authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd) { (user, error) in
                        if error != nil {
                            print("DAMN: Unable to authenticate with Firebase using email - \(error)")
                        } else {
                            print("DAMN: Sucessfully authenticated with Firebase")
                        }
                    }
                }
            }
        }
    }
}





















