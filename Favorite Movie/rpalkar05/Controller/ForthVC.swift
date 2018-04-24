//
//  ForthVC.swift
//  rpalkar05
//
//  Created by Rajesh Palkar on 4/21/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import Firebase

class ForthVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let URL =  "https://api.themoviedb.org/3/movie/popular?api_key=bc9bd96f5f55e22b06f52654aaf41712"
    
    
    var movies = [Movie]()
    let bandCellId = "cell"
    var imgURL: String!
    var FMovies = [FavMovie]()

    
    let tableView: UITableView = {
        let tv = UITableView()
        // tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


       // let cell = tableView.dequeueReusableCell(withIdentifier: bandCellReviewId, for: indexPath)
 let cell = BandCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell\(indexPath.row)")
        cell.link4 = self
        
        
        
        print(indexPath.row)
        let fm = FMovies[indexPath.row]
        
         print(fm.title)
        cell.movieTitle.text = fm.title
        
        cell.favButton.backgroundColor = .red
        print(fm.mID!)
        
        let ref = Database.database().reference().child("comments").child(String(describing: fm.mID!))
        print(ref)

        ref.observe(.value, with: { (snapshot) in

            if(Int(snapshot.childrenCount)-2 < 0){
                cell.reviewCountLabel.text = "0"
            }else{
                cell.reviewCountLabel.text = String(Int(snapshot.childrenCount)-2)
            }
        }, withCancel: nil)
        
        print(cell.reviewCountLabel.text)
        
        Alamofire.request(fm.imageUrl!).responseImage { response in
            if let image = response.result.value {
                cell.moviePicture.image =  image
               
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //   let indexPath = tableView.indexPathForSelectedRow
        //getting the current cell from the index path
        //  let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        let fmovie = FMovies[(tableView.indexPathForSelectedRow?.row)!]
        
        self.showDetailedMovie(fmovie:fmovie)
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            movies.remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
    
    func getMovieID(cell: UITableViewCell)
    {
        let mv: FavMovie
        
        let indexTapped = tableView.indexPath(for: cell)
        print(indexTapped?.row)
        mv = FMovies[(indexTapped?.row)!]
        
//        let hasFavorated = FMovies[(indexTapped?.row)!].hasFav
//
//
//
//        movies[(indexTapped?.row)!].hasFav = !hasFavorated!
//        let def = UserDefaults.standard
//        def.setValue(movies[(indexTapped?.row)!].hasFav, forKey: movies[(indexTapped?.row)!].favButtonColor)
//        print(movies[(indexTapped?.row)!].hasFav)
        
        
        
        guard let uid =   Auth.auth().currentUser?.uid
            else{
                return
        }
        
     
            
            let ref = Database.database().reference(fromURL: "https://assignment04-ecf8c.firebaseio.com/")
            print(ref)
            print(uid)
            print(mv.mID!)
            let userReference = ref.child("Favorites").child(uid).child(String(mv.mID!))
            print(userReference)
            
            userReference.removeValue { (error, _) in
                print(error)
                
                // self.dismiss(animated: true, completion: nil)
                _ = self.tabBarController?.selectedIndex = 1
                
            }
            tableView.reloadRows(at: [indexTapped!], with: .fade)
        }
    
    
    func showDetailedMovie(fmovie: FavMovie)
    {
        let detailedController = DetailedViewController()
        detailedController.id = Int(fmovie.mID)
        navigationController?.pushViewController(detailedController, animated: true)
    }
    func setupNavigationBar()
    {
        
        navigationItem.title = "Popular Movies"
        navigationController?.navigationBar.barTintColor = UIColor.cyan
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.darkGray,
                                                                   NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20)]
    }
    
    @objc func goToProfileScreen()
    {
        let detailedController = ProfileController()
        let navController = UINavigationController(rootViewController: detailedController)
        self.present(navController, animated: true, completion: nil)
    }
    
    
    func checkIfUserLoggedIn()
    {
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.navigationItem.rightBarButtonItem?.title = dictionary["name"] as? String
                self.imgURL = dictionary["ProfileImageUrl"] as? String
                print(self.imgURL!)
                if let profileImageURL = self.imgURL
                {
                    print(profileImageURL)
                    // let url = URL(string: profileImageURL)
                    let url = Foundation.URL(string:profileImageURL)
                    print(url)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil{
                            //print(error)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.navigationItem.leftBarButtonItem?.image = UIImage(data: data!)
                        }
                        
                    }).resume()
                    
                }
                
            }
        }, withCancel: nil)
        
    }
    
    func getFavMovies()
    {
        let uid = Auth.auth().currentUser?.uid
        FMovies.removeAll()
        Database.database().reference().child("Favorites").child(uid!).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print(snapshot)
                let comment = Review()
                let fMovie = FavMovie()
                  fMovie.title  = dictionary["MovieName"] as! String
                  fMovie.imageUrl = dictionary["PosterIcon"] as! String
                  fMovie.mID = dictionary["MovieID"] as! String
                
                self.FMovies.append(fMovie)
               // self.reviews.append(comment)
                
                print(fMovie.title)
                print(fMovie.imageUrl)
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }

            
        }, withCancel: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavMovies()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupNavigationBar()
        checkIfUserLoggedIn()
        
        navigationItem.title = "Popular Movies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(goToProfileScreen))
    
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(BandCell.self, forCellReuseIdentifier: bandCellId)
        
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        //  self.tableView.allowsMultipleSelectionDuringEditing = false
        
       
    
      //   getFavMovies()
        
       
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
   
    
    
    
}
