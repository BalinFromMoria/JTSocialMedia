//
//  FeedVC.swift
//  JTSocialMedia
//
//  Created by Jiří Tomis on 10.08.17.
//  Copyright © 2017 JT. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func SignOutPushed(_ sender: Any) {
        
        let keyResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("DAMN: Log out and ID removed \(keyResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }


}
