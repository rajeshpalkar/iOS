//
//  MyTabBarControllerViewController.swift
//  rpalkar05
//
//  Created by Rajesh Palkar on 4/21/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import UIKit

class MyTabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let firstViewController = MovieListViewController()
        
     //   firstViewController.tabBarItem = UITabBarItem(title: "Top Rated", image: UIImage(named: "test"), tag: 0)
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        firstViewController.title = "Popular Movies"
        
        let secondViewController = TopRated()
        
        
      //  firstViewController.tabBarItem = UITabBarItem(title: "Favorite", image: <#T##UIImage?#>, tag: 1)
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        secondViewController.title = "Top Rated"
        
        let thirdViewController = MovieListNowPlaying()
        
     //   firstViewController.tabBarItem = UITabBarItem(title: "Most Recent", image: <#T##UIImage?#>, tag: 2)
        thirdViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 2)
        thirdViewController.title = "Now Playing"
        
        let forthViewController = ForthVC()
        
     //   firstViewController.tabBarItem = UITabBarItem(title: "Top Rated", image: <#T##UIImage?#>, tag: 3)
        forthViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 3)
        
        let tabBarList = [firstViewController, secondViewController, thirdViewController, forthViewController]
        
        viewControllers = tabBarList
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
