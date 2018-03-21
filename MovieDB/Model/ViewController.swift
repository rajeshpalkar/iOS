//
//  ViewController.swift
//  rpalkar03
//
//  Created by Rajesh Palkar on 3/18/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let URL =  "https://api.themoviedb.org/3/movie/popular?api_key=bc9bd96f5f55e22b06f52654aaf41712"
  
    var movies = [Movie]()
    let bandCellId = "cell"
   
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
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = UITableViewCell(style: .default, reuseIdentifier: "cell" )
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!  BandCell
       
        let cell = BandCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell\(indexPath.row)")
        let movie: Movie
        print(indexPath.row)
        movie = movies[indexPath.row]
        
        cell.movieTitle.text = movie.title
        
        

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(BandCell.self, forCellReuseIdentifier: bandCellId)
        
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
       
      
        
        
       Alamofire.request(URL).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)") // response serialization result
            
            if let json = response.result.value {
             //   print(json)
                let t = (json as AnyObject).object(forKey: "results") as AnyObject?
                print(t)
                let MoviesArray : NSArray = t as! NSArray
                for i in 0..<MoviesArray.count{
                    
                    self.movies.append(Movie(
                        id:  (MoviesArray[i] as AnyObject).value(forKey: "id") as? Int,
                        title: (MoviesArray[i] as AnyObject).value(forKey: "title") as? String,
                        imgUrl: (MoviesArray[i] as AnyObject).value(forKey: "poster_path") as? String
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




class Movie
{
    var title: String?
    var imgUrl: String?
    var id: Int?
    
    init(id:Int?, title: String?, imgUrl: String?){
        self.id = id
        self.title = title
        self.imgUrl = imgUrl
    }
}

class BandCell : UITableViewCell
{
    /*let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        //view.setCellShadow()
        return view
    }()*/
    
    let moviePicture: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = true
        return iv
    }()
    
    let movieTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = true
        lbl.adjustsFontSizeToFitWidth = false
        lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
       
        return lbl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:  reuseIdentifier)
        setup()
    }
    
    
    
    func setup()
    {
       
        //self.addSubview(cellView)
        

//        self.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        self.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        self.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        self.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//
//        moviePoster.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        moviePoster.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        moviePoster.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        moviePoster.centerXAnchor.constraint(equalTo: moviePoster.centerXAnchor).isActive = true
//
//        movieTitle.leftAnchor.constraint(equalTo: moviePoster.rightAnchor).isActive = true
//        movieTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        movieTitle.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
         moviePicture.frame = CGRect(x: 0, y: 10, width: 100, height: 80)
         movieTitle.frame = CGRect(x: 100, y: 25, width:250, height: 50)
        
        contentView.addSubview(movieTitle)
        contentView.addSubview(moviePicture)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}

}

