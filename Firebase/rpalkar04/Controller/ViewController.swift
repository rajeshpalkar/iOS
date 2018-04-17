//
//  ViewController.swift
//  rpalkar04
//
//  Created by Rajesh Palkar on 4/12/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    

    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 80, green: 101, blue: 161, alpha: 1)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        
        return button
    }()
    
    @objc func handleLoginRegister()
    {
        if loginSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegisterEvent()
        }
    }
    
    func handleLogin()
    {
        guard let email = emailText.text, let password = passText.text else{
            print("Not valid entries!")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if(error != nil){
                print("Login Failed!")
                print(error)
                return
            }
            
            print("Sucessfully LoggedIn!")
           //let detailedController = HomeController()
            let detailedController = MovieListViewController()
            let navController = UINavigationController(rootViewController: detailedController)
            self.present(navController, animated: true, completion: nil)
            
        }
    }
    
    @objc func handleRegisterEvent(){
        print(123)
        
        guard let email = emailText.text, let password = passText.text else{
            print("Not valid entries!")
            return
        }
   
        Auth.auth().createUser(withEmail: email, password: password){ (user, error) in
            if(error != nil){
                print(error)
                return
            }
             
            
        }
        
        
        let detailedController = ProfileController()
        detailedController.emailID = emailText.text
        navigationController?.pushViewController(detailedController, animated: true)
            //successfully authenticated
    
    }
    
    
    
    let emailText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items:["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex  = 0
        sc.addTarget(self, action: #selector(handleToggleChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleToggleChange(){
        let title = loginSegmentedControl.titleForSegment(at: loginSegmentedControl.selectedSegmentIndex)
        signUpButton.setTitle(title, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = UIColor.orange
        
        view.addSubview(inputContainerView)
        view.addSubview(signUpButton)
        view.addSubview(loginSegmentedControl)
        
        setUIViewCons()
        setsignUpButtonCons()
        setSegmentedControl()

        if(Auth.auth().currentUser?.uid == nil){
            handleLogout()
        }
        
        
        
    }
    
    func setUIViewCons()
    {
        //need x, y, h, w
         inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
         inputContainerView.widthAnchor.constraint(equalToConstant: 375).isActive = true
         inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputContainerView.addSubview(emailText)
         //need x, y, h, w
        emailText.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailText.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        emailText.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputContainerView.addSubview(seperator)
        //need x, y, h, w
        seperator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: emailText.bottomAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(passText)
        //need x, y, h, w
        passText.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passText.topAnchor.constraint(equalTo: seperator.bottomAnchor).isActive = true
        passText.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        
    }
    
    
    func setsignUpButtonCons()
    {
        //need x, y, h, w
        signUpButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 20).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: inputContainerView .leftAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor,multiplier: 1).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

    

    func setSegmentedControl()
    {
         //need x, y, h, w
        loginSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func handleLogout(){
        
        do{
            print("user loggedOut")
            try Auth.auth().signOut()
        }
        catch let logoutError{
            print(logoutError)
        }
    }

}

