//
//  ProfileController.swift
//  rpalkar04
//
//  Created by Rajesh Palkar on 4/13/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileController : UIViewController {
    
    var emailID : String!
    var name: String!
    var city: String!
    var age: String!
    var imgURL: String!
    
    lazy var profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "test")
       // iv.translatesAutoresizingMaskIntoConstraints = false
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageView)))
        iv.isUserInteractionEnabled = true
  
        return iv
    }()
    

   
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    
    let nameText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let seperatorName: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ageText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Age"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let seperatorAge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cityText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "City"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let updateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 80, green: 101, blue: 161, alpha: 1)
        button.setTitle("Update", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(handleUpdateProfile), for: .touchUpInside)
        
        
        return button
    }()
    
    @objc func handleUpdateProfile(){
        print(345)
        name = self.nameText.text
        age = self.ageText.text
        city = self.cityText.text
        
        print(name)
        print(age)
        print(city)
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("Profile_Images").child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(self.profileImage.image!){
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error)
                    return
                }
                
                if let profileImageURL = metadata?.downloadURL()?.absoluteString{
                    let values = ["name": self.name, "age": self.age, "city": self.city, "ProfileImageUrl": profileImageURL]
     
                    if(self.emailID == nil){
                        self.emailID = Auth.auth().currentUser?.email
                    }
                    
                    guard let uid =   Auth.auth().currentUser?.uid
                        else{
                            return
                    }
                    self.updateIntoDatabaseWithEmailID(uid: uid, values:  values as [String : AnyObject])
            }
                
                

            })
        }
    }
    
    func updateIntoDatabaseWithEmailID(uid: String, values:[String: AnyObject]){
        
        
        let ref = Database.database().reference(fromURL: "https://assignment04-ecf8c.firebaseio.com/")
        print(ref)
        print(uid)
        let userReference = ref.child("users").child(uid)
        print(userReference)
      
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error)
                return
            }
           // self.dismiss(animated: true, completion: nil)
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        self.view.backgroundColor = UIColor.blue
        
        setUpNavigationBar()
        
        view.addSubview(profileImage)
        view.addSubview(inputContainerView)
        view.addSubview(updateButton)
        
        setImageCons()
        setUIViewCons()
        setUpdateButtonCons()
       
        let uid = Auth.auth().currentUser?.uid
        if(uid != nil){
            checkIfUserLoggedIn()}
      
    }
    
    func checkIfUserLoggedIn()
    {
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.navigationItem.title = dictionary["name"] as? String
                self.nameText.text = dictionary["name"] as? String
                self.ageText.text = dictionary["age"] as? String
                self.cityText.text = dictionary["city"] as? String
                self.imgURL = dictionary["ProfileImageUrl"] as? String
                print(self.imgURL!)
                if let profileImageURL = self.imgURL
                {
                    print(profileImageURL)
                    let url = URL(string : profileImageURL)
                    print(url!)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil{
                            //print(error)
                            return
                        }

                        DispatchQueue.main.async {
                              self.profileImage.image = UIImage(data: data!)
                        }
                      
                    }).resume()
                 
                }
            }
        }, withCancel: nil)
    
    }
    
    func setImageCons()
    {
//        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)
//        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        profileImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        profileImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
              profileImage.frame = CGRect(x: 120, y: 80, width: 150, height: 150)
    }
    
    func setUIViewCons()
    {
        //need x, y, h, w
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalToConstant: 375).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        inputContainerView.addSubview(nameText)
        //need x, y, h, w
        nameText.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameText.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameText.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        inputContainerView.addSubview(seperatorName)
        //need x, y, h, w
        seperatorName.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        seperatorName.topAnchor.constraint(equalTo: nameText.bottomAnchor).isActive = true
        seperatorName.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        seperatorName.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(ageText)
        //need x, y, h, w
        ageText.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        ageText.topAnchor.constraint(equalTo: nameText.bottomAnchor).isActive = true
        ageText.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        ageText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        inputContainerView.addSubview(seperatorAge)
        //need x, y, h, w
        seperatorAge.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        seperatorAge.topAnchor.constraint(equalTo: ageText.bottomAnchor).isActive = true
        seperatorAge.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        seperatorAge.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(cityText)
        //need x, y, h, w
        cityText.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        cityText.topAnchor.constraint(equalTo: seperatorAge.bottomAnchor).isActive = true
        cityText.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        cityText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setUpdateButtonCons()
    {
        updateButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 4).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 50)
        updateButton.widthAnchor.constraint(equalToConstant: 100)
    }

    func setUpNavigationBar()
    {
        let user = Auth.auth().currentUser
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(goToHomeScreen))
//        if(user?.email != nil){
//            navigationItem.title = user?.email}
//        else{
//            navigationItem.title = emailID
//        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }

@objc func goToHomeScreen()
{
    let detailedController = MovieListViewController()
    let navController = UINavigationController(rootViewController: detailedController)
    self.present(navController, animated: true, completion: nil)
}
    
@objc func handleLogout()
{
    
    do{
        try Auth.auth().signOut()
    }
    catch let logoutError{
        print(logoutError)
    }
    
        let detailedController = ViewController()
        let navController = UINavigationController(rootViewController: detailedController)
        self.present(navController, animated: true, completion: nil)
}

}
