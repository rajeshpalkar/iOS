//
//  AboutViewController.swift
//  rpalkar02
//
//  Created by Rajesh Palkar on 2/19/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    /*self.view.backgroundColor = UIColor(red:0.3,
                                            green:0.5,
                                            blue:0.6,
                                            alpha:1.0)*/
       //  self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAboutWindow(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
