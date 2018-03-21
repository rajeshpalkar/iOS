//
//  DetailedViewController.swift
//  rpalkar03
//
//  Created by Rajesh Palkar on 3/19/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//
import UIKit
import Foundation
import Alamofire
import AlamofireImage
import Cosmos

class DetailedViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var URls = [Collect]()
    var s = [String]()
   
    
     let cellReuseIdentifier = "cell"
    let reuseIdentifier = "scrollCells"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath) as! ImageCollection

    
    let picturesURL = "https://api.themoviedb.org/3/movie/\(self.id!)/images?api_key=bc9bd96f5f55e22b06f52654aaf41712"

    
     Alamofire.request(picturesURL).responseJSON { response in
     
        if let json = response.result.value {

        let t = (json as AnyObject).object(forKey: "backdrops") as AnyObject?
        let MoviesArray : NSArray = t as! NSArray
            
            //    self.URls = []
            
        
        for i in 0..<MoviesArray.count{
            self.URls.append(Collect(imgURL: (MoviesArray[i] as AnyObject).object(forKey: "file_path") as? String))
                }
            
            let col : Collect
            col = self.URls[indexPath.row]
            print(col)
            
            
            Alamofire.request("https://image.tmdb.org/t/p/w500\(col.imgURL!)").responseImage { response in
                if let image = response.result.value {
                    cell.imgScroll.image = image
                }
                
            }
    }
 }

    
    return cell
}

    
    
    var MovieDetail:MovieDetails?
    var id: Int!
    var tt: String!
    var imgURL: String!
    var release: String!
    var genres: [String]!
    var des: String!
   
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
    
     
        
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 50, y: 150, width: 300, height: 200), collectionViewLayout: flowLayout)
        collectionView.register(ImageCollection.self, forCellWithReuseIdentifier: reuseIdentifier)
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 200, height: 200)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.white

        self.view.addSubview(collectionView)

   
        let moviePoster: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        let movieTitle: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.adjustsFontSizeToFitWidth = false
            lbl.frame = view.frame
            lbl.textColor = .orange
            lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
            lbl.font = UIFont.boldSystemFont(ofSize: 18)
            
            return lbl
        }()
        
        let movieGenres: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.adjustsFontSizeToFitWidth = false
            lbl.frame = view.frame
            lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
            lbl.font = UIFont.italicSystemFont(ofSize: 14)
            
            return lbl
        }()
        
        let movieRelease: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.adjustsFontSizeToFitWidth = false
            lbl.frame = view.frame
            lbl.textColor = UIColor.brown
            lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
            lbl.font = UIFont.italicSystemFont(ofSize: 14)
            
            return lbl
        }()
        
        let movieDes: UITextView = {
            let lbl = UITextView()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.frame = view.frame
            lbl.font = UIFont.italicSystemFont(ofSize: 16)
            
            return lbl
        }()
        
        
        
        let movieRating = CosmosView()
        //movieRating.translatesAutoresizingMaskIntoConstraints = false
        movieRating.frame = CGRect(x: 20, y: 700, width: 100, height: 100)
        movieRating.rating = 4
        movieRating.settings.filledColor = UIColor.orange
        movieRating.settings.starSize = 50
        movieRating.settings.fillMode = .precise
        view.addSubview(movieRating)
        
        
        
        
      //  view.addSubview(moviePoster)
        view.addSubview(movieTitle)
        view.addSubview(movieRelease)
        view.addSubview(movieGenres)
        view.addSubview(movieDes)
        
        
        var movieUrl =  "https://api.themoviedb.org/3/movie/\(id!)?api_key=bc9bd96f5f55e22b06f52654aaf41712"
        movieGenres.text = ""
        
        print("ttt: \(movieUrl)")
        Alamofire.request(movieUrl).responseJSON { response in
            
            if let json = response.result.value {
               // self.MovieDetail?.title = (json as AnyObject).object(forKey: "title") as! String
                movieTitle.text = (json as AnyObject).object(forKey: "title") as! String
                self.imgURL = (json as AnyObject).object(forKey: "poster_path") as! String
                movieRelease.text = (json as AnyObject).object(forKey: "release_date") as! String
           //     movieGenres.text = (json as AnyObject).object(forKey: "genres") as! String
                
                let comma = ","
                let t = (json as AnyObject).object(forKey: "genres") as AnyObject?
                print(t)
                let MoviesArray : NSArray = t as! NSArray
                for i in 0..<MoviesArray.count{
                    var temp = (MoviesArray[i] as AnyObject).object(forKey: "name") as? String
                   // movieGenres.text = [movieGenres.text stringByAppendingString:S];
                    if(!(temp?.isEmpty)! && i != MoviesArray.count-1){
                        temp = String(describing: temp!) + comma}
                    movieGenres.text! = movieGenres.text! + String(describing: temp!)
                    print(movieGenres.text!)
                }
                
        
                
                movieDes.text = (json as AnyObject).object(forKey: "overview") as! String
                
                var rating = (json as AnyObject).object(forKey: "vote_average") as! Float
                
                movieRating.rating = Double(rating/2)
           
                Alamofire.request("https://image.tmdb.org/t/p/w500\(self.imgURL!)").responseImage { response in
                    
                    if let data = response.data {
                    moviePoster.image   = UIImage(data: data)
                    }
                }
            }
        }
        
        
        
//                moviePoster.leftAnchor.constraint(equalTo: view.leftAnchor,constant: -40).isActive = true
//                moviePoster.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//                moviePoster.widthAnchor.constraint(equalToConstant: 300).isActive = true
//                moviePoster.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
                movieTitle.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                movieTitle.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
                movieTitle.widthAnchor.constraint(equalToConstant: 500).isActive = true
                movieTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
                movieRelease.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                movieRelease.topAnchor.constraint(equalTo: movieTitle.bottomAnchor).isActive = true
                movieRelease.widthAnchor.constraint(equalToConstant: 100).isActive = true
                movieRelease.heightAnchor.constraint(equalToConstant: 100).isActive = true

                movieGenres.topAnchor.constraint(equalTo: movieTitle.bottomAnchor).isActive = true
                movieGenres.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                movieGenres.widthAnchor.constraint(equalToConstant: 300).isActive = true
                movieGenres.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
                movieDes.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                movieDes.topAnchor.constraint(equalTo: movieRelease.bottomAnchor).isActive = true
                movieDes.widthAnchor.constraint(equalToConstant: 300).isActive = true
                movieDes.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
//        moviePoster.frame = CGRect(x: 50, y: 250, width: 150, height: 150)
//        movieTitle.frame = CGRect(x: 100, y: 550, width:40, height: 50)
        
      
    }
}



class MovieDetails
{
    var id: Int?
    var title: String?
    var imgUrl: String?
    
    init(id: Int?, title: String?){
        self.id = id
        self.title = title
    }
}

class ImageCollection : UICollectionViewCell
{
    var imgScroll = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imgScroll)
        imgScroll.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Collect{
    var imgURL : String?
    
    init(imgURL:String?){
        self.imgURL = imgURL
    }
}


