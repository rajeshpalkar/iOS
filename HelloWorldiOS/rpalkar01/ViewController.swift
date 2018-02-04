//
//  ViewController.swift
//  rpalkar01
//
//  Created by Rajesh Palkar on 2/1/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red:0.3,
                                            green:0.5,
                                            blue:0.6,
                                            alpha:1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert(){
        let alert = UIAlertController(title: "This is Optimus Prime!",
                                      message: "My first iOS App",
                                      preferredStyle:.alert)
        let action = UIAlertAction(title: "Great!",
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }

}

