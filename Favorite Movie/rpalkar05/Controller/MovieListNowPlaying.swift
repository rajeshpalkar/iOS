//
//  MovieListNowPlaying.swift
//  rpalkar05
//
//  Created by Rajesh Palkar on 4/22/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

//
//  TopRated.swift
//  rpalkar05
//
//  Created by Rajesh Palkar on 4/23/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import AlamofireImage
import Firebase

class MovieListNowPlaying: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let URL =  "https://api.themoviedb.org/3/movie/now_playing?api_key=bc9bd96f5f55e22b06f52654aaf41712"
    
    
    var movies = [Movie]()
    let bandCellId = "cell"
    var imgURL: String!
    var numReviews: String?
    var yesFav: Bool?
    
    let tableView: UITableView = {
        let tv = UITableView()
        // tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func getMovieID(cell: UITableViewCell)
    {
        let mv: Movie
        
        let indexTapped = tableView.indexPath(for: cell)
        mv = movies[(indexTapped?.row)!]
        
        let hasFavorated = movies[(indexTapped?.row)!].hasFav
        
        
        
        movies[(indexTapped?.row)!].hasFav = !hasFavorated!
        let def = UserDefaults.standard
        def.setValue(movies[(indexTapped?.row)!].hasFav, forKey: movies[(indexTapped?.row)!].favButtonColor)
        print(movies[(indexTapped?.row)!].hasFav)
        
        
        
        guard let uid =   Auth.auth().currentUser?.uid
            else{
                return
        }
        
        if(movies[(indexTapped?.row)!].hasFav)! {
            
            var mUrl = "https://image.tmdb.org/t/p/w500"+mv.imgUrl!
            
            
            let values = ["MovieName": mv.title!, "PosterIcon": mUrl,"MovieID": String(describing: mv.id!)] as [String : Any]
            
            let ref = Database.database().reference(fromURL: "https://assignment04-ecf8c.firebaseio.com/")
            print(ref)
            print(uid)
            
            let userReference = ref.child("Favorites").child(uid).child(String(mv.id!))
            print(userReference)
            
            
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error)
                    return
                }
                print(values)
                
            })
            
            tableView.reloadRows(at: [indexTapped!], with: .fade)
        }else{
            
            let ref = Database.database().reference(fromURL: "https://assignment04-ecf8c.firebaseio.com/")
            print(ref)
            print(uid)
            print(mv.id!)
            let userReference = ref.child("Favorites").child(uid).child(String(mv.id!))
            print(userReference)
            
            userReference.removeValue { (error, _) in
                print(error)
                
                // self.dismiss(animated: true, completion: nil)
                
            }
            tableView.reloadRows(at: [indexTapped!], with: .fade)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = UITableViewCell(style: .default, reuseIdentifier: "cell" )
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!  BandCell
        
        let cell = BandCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell\(indexPath.row)") as BandCell
        cell.link3 =  self
        
        let movie: Movie
        
        movie = movies[indexPath.row]
        
        
        let defaults = UserDefaults.standard
        
        
        
        //defaults.setValue(movies[indexPath.row].hasFav, forKey: movies[indexPath.row].favButtonColor)
        //   movies[indexPath.row].hasFav =  defaults.object(forKey: movies[indexPath.row].favButtonColor) as! Bool
        
        
        //
        //        if (defaults.bool(forKey: movies[indexPath.row].favButtonColor)) {
        //            movies[indexPath.row].hasFav = true
        //        } else {
        //            movies[indexPath.row].hasFav = false
        //        }
        
        print(movies[indexPath.row].hasFav)
        
        
        
        
        
        
        
        
        cell.favButton.backgroundColor = movies[indexPath.row].hasFav! ? UIColor.red : .lightGray
        //cell.favButton.backgroundColor = movie.hasFav! ? UIColor.red : .lightGray
        
        cell.movieTitle.text = movie.title
        
        
        let ref = Database.database().reference().child("comments").child(String(describing: movie.id!))
        
        ref.observe(.value, with: { (snapshot) in
            
            if(Int(snapshot.childrenCount)-2 < 0){
                cell.reviewCountLabel.text = "0"
            }else{
                cell.reviewCountLabel.text = String(Int(snapshot.childrenCount)-2)
            }
        }, withCancel: nil)
        
        
        
        Alamofire.request("https://image.tmdb.org/t/p/w500\(movie.imgUrl!)").responseImage { response in
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
        
        let movie = movies[(tableView.indexPathForSelectedRow?.row)!]
        
        self.showDetailedMovie(movie:movie)
        
        
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
    
    func showDetailedMovie(movie: Movie)
    {
        let detailedController = DetailedViewController()
        detailedController.id = movie.id
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
        
        
        
        
        
        Alamofire.request(URL).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)") // response serialization result
            
            if let json = response.result.value {
                //   print(json)
                let t = (json as AnyObject).object(forKey: "results") as AnyObject?
                // print(t)
                let MoviesArray : NSArray = t as! NSArray
                for i in 0..<MoviesArray.count{
                    
                    self.movies.append(Movie(
                        id:  (MoviesArray[i] as AnyObject).value(forKey: "id") as? Int,
                        title: (MoviesArray[i] as AnyObject).value(forKey: "title") as? String,
                        imgUrl: (MoviesArray[i] as AnyObject).value(forKey: "poster_path") as? String,
                        hasFav: (MoviesArray[i] as AnyObject).value(forKey: "hasfav") as? Bool
                    ))
                }
                
                self.tableView.reloadData()
                
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

