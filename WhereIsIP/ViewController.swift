//
//  ViewController.swift
//  WhereIsIP
//
//  Created by Tongchai Tonsau on 4/27/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Google


class ViewController: UIViewController,FBSDKLoginButtonDelegate,GIDSignInUIDelegate,GIDSignInDelegate{

  
    var login : String!
    var logout = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupGoogleButton()
        SetupFacebookButton()
       
    
        // Do any additional setup after loading the view, typically from a nib.
        
        

        
        }
    
//        @IBAction func SendIP(_ sender: Any) {
//        
//        
//    }
    
    //facebook login
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Did log out of facebook")
        }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
    
        print("login with facebook complete")
        showEmailAddress()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Map") as? MapsViewController
        vc?.login_with = "facebook"
        self.present(vc!, animated: true, completion: nil)


    }

    func showEmailAddress() {
               FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
        }
    }
    
    func SetupFacebookButton(){
        let loginButton = FBSDKLoginButton()
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        if(logout == "facebook")
        {
          fbLoginManager.logOut()
          print("facebook logout")
        }
        
    }
    
    //google login
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error
        {
            print("error log in into google ",err)
            return
        }
        print("sucessfully login with google ",user)
        
        print(user.profile.email)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Map") as? MapsViewController
        vc?.login_with = "google"
        self.present(vc!, animated: true, completion: nil)

        
    }
    

    func SetupGoogleButton(){
        
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        var error : NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if error != nil{
            print(error ?? "")
            return
        }
        
        
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        if logout == "google"
        {
            GIDSignIn.sharedInstance().signOut()
            print("google logout")
        }

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

