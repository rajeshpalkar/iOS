//
//  WriteReviewController.swift
//  rpalkar05
//
//  Created by Rajesh Palkar on 4/21/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class WriteReviewController : UIViewController {
    var email: String!
    var mID: String!
    var name: String!
    
    
    let reviewText: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = UIColor.darkGray
        tf.font = UIFont(name: "Times New Roman", size: 20)
        // tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let postReviewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 80, green: 101, blue: 161, alpha: 1)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(handleReviewUpdate), for: .touchUpInside)
        
        
        return button
    }()
    
    let deleteReviewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 80, green: 101, blue: 161, alpha: 1)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(handleDeleteReview), for: .touchUpInside)
        
        
        return button
    }()
    
    @objc func handleDeleteReview()
    {
        guard let uid =   Auth.auth().currentUser?.uid
            else{
                return
        }
        
        let ref = Database.database().reference(fromURL: "https://assignment04-ecf8c.firebaseio.com/")
        print(ref)
        print(uid)
        print(mID)
        let userReference = ref.child("comments").child(mID).child(uid)
        print(userReference)
        
        userReference.removeValue { (error, _) in
            print(error)
            
            // self.dismiss(animated: true, completion: nil)
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @objc func handleReviewUpdate()
    {
        print(555)
        
        guard let uid =   Auth.auth().currentUser?.uid
            else{
                return
        }
        
        
        email = Auth.auth().currentUser?.email
        print(email)
        
        print(name)
        print(reviewText)
        let values = ["Email":self.email , "Review": self.reviewText.text] as [String : Any]
        
        
        let ref = Database.database().reference(fromURL: "https://assignment04-ecf8c.firebaseio.com/")
        print(ref)
        print(uid)
        print(mID)
        let userReference = ref.child("comments").child(mID).child(uid)
        print(userReference)
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            print(values)
            
        })
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        navigationItem.title = Auth.auth().currentUser?.email
        self.view.addSubview(reviewText)
        self.view.addSubview(postReviewButton)
        self.view.addSubview(deleteReviewButton)
        setupReviewTextCons()
    

        
    }
    
    func setupReviewTextCons()
    {
        reviewText.frame = CGRect(x: 10, y: 100, width: 400, height: 250)
        postReviewButton.frame = CGRect(x: 50, y: 400, width: 50, height: 50)
        deleteReviewButton.frame =  CGRect(x: 150, y: 400, width: 50, height: 50)
    }
}


