//
//  MovieDetailController.swift
//  rpalkar05
//
//  Created by Rajesh Palkar on 4/21/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage
import Cosmos
import Firebase

class DetailedViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate
{
    var URls = [Collect]()
    var s = [String]()
    let bandCellReviewId = "cell"
    var likeCount: Int!
    var dislikeCount: Int!
    var movieID: String!
    var reviews = [Review]()
    
    
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
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle("Like", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        // button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        
        return button
    }()
    
    
    let reviewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle("Review", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        // button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(handleReview), for: .touchUpInside)
        
        
        return button
    }()
    
    
    @objc func handleReview(){
        let detailedController = WriteReviewController()
        detailedController.mID = movieID
        navigationController?.pushViewController(detailedController, animated: true)
    }
    
    let likeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0"
        lbl.textColor = UIColor.black
        lbl.adjustsFontSizeToFitWidth = false
        lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        
        return lbl
    }()
    
    
    let dislikeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle("Dislike", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        
        return button
    }()
    
    let dislikeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0"
        lbl.textColor = UIColor.black
        lbl.adjustsFontSizeToFitWidth = false
        lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        
        return lbl
    }()
    
    
    var MovieDetail:MovieDetails?
    var id: Int!
    var tt: String!
    var imgURL: String!
    var release: String!
    var genres: [String]!
    var des: String!
    
    
    let tableViewReview: UITableView = {
        let tv = UITableView()
        // tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(reviews.count)
        
        return reviews.count
        
        //return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //   let cell = BandCellReview(style: .subtitle, reuseIdentifier: bandCellReviewId)
        //   let cell = UITableViewCell(style: .subtitle ,reuseIdentifier: bandCellReviewId)
        
        let cell = tableViewReview.dequeueReusableCell(withIdentifier: bandCellReviewId, for: indexPath)
        
        let comment = reviews[indexPath.row]
        
        cell.textLabel?.text = comment.email
        cell.detailTextLabel?.text = comment.review
        
        
        return cell
    }
    
    func checkForReviews(){
        let uid = Auth.auth().currentUser?.uid
        movieID = String(id!)
        print(movieID)
        Database.database().reference().child("comments").child(movieID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                print(snapshot)
                
                if(dictionary["noOfLikes"] as? String == nil){
                    self.likeLabel.text = "0" }else{
                    self.likeLabel.text = dictionary["noOfLikes"] as? String
                }
                
                if(dictionary["noOfDislikes"] as? String == nil){
                    self.dislikeLabel.text  = "0" }
                else{
                    self.dislikeLabel.text = dictionary["noOfDislikes"] as? String
                }
                
                print( self.likeLabel.text)
                print( self.likeLabel.text)
                
                
                
            }
        }, withCancel: nil)
    }
    
    @objc func handleLike(){
        
        print(345)
        
        self.likeCount = Int(likeLabel.text!)! + 1
        print(dislikeLabel.text)
        self.dislikeCount = Int(dislikeLabel.text!)! + 0
        print(self.likeCount)
        
        
        let values = ["noOfLikes": String(self.likeCount),"noOfDislikes": String(self.dislikeCount)]
        
        //                    if(self.emailID == nil){
        //                        self.emailID = Auth.auth().currentUser?.email
        //                    }
        //
        //                    guard let uid =   Auth.auth().currentUser?.uid
        //                        else{
        //                            return
        //                    }
        
        let ref = Database.database().reference(fromURL: "https://assignment04-ecf8c.firebaseio.com/")
        print(ref)
        print(id!)
        movieID = String(id)
        print(movieID)
        let userReference = ref.child("comments").child(movieID)
        print(userReference)
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            self.checkForReviews()
            // self.dismiss(animated: true, completion: nil)
        })
        
        
    }
    
    @objc func handleDislike()
    {
        print(888)
        
        self.likeCount = Int(likeLabel.text!)! + 0
        self.dislikeCount = Int(dislikeLabel.text!)! + 1
        print(self.dislikeCount)
        
        
        let values = ["noOfLikes": String(self.likeCount),"noOfDislikes": String(self.dislikeCount)]
        
        //                    if(self.emailID == nil){
        //                        self.emailID = Auth.auth().currentUser?.email
        //                    }
        //
        //                    guard let uid =   Auth.auth().currentUser?.uid
        //                        else{
        //                            return
        //                    }
        
        let ref = Database.database().reference(fromURL: "https://assignment04-ecf8c.firebaseio.com/")
        print(ref)
        print(id!)
        movieID = String(id)
        print(movieID)
        let userReference = ref.child("comments").child(movieID)
        print(userReference)
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            self.checkForReviews()
            // self.dismiss(animated: true, completion: nil)
        })
    }
    
    func fetchComments(){
        
        print(movieID)
        reviews.removeAll()
        Database.database().reference().child("comments").child(movieID).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let comment = Review()
                
                comment.email = dictionary["Email"] as! String
                comment.review = dictionary["Review"] as! String
                
                self.reviews.append(comment)
                print(comment.email)
                print(comment.review)
                
                
                DispatchQueue.main.async {
                    self.tableViewReview.reloadData()
                }
            }
            
            print(snapshot)
        }, withCancel: nil)
    }
    
    func fetchComments2(){
        
        print(movieID)
        self.tableViewReview.reloadData()
        
        let ref =  Database.database().reference().child("comments")
        print(ref)
        let userRef = ref.child(movieID)
        print(userRef)
        
        
        Database.database().reference().child("comments").child(movieID).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print(snapshot)
                let comment = Review()
                
                comment.email = dictionary["Email"] as! String
                comment.review = dictionary["Review"] as! String
                
                self.reviews.append(comment)
                print(comment.email)
                print(comment.review)
                
                
                DispatchQueue.main.async {
                    self.tableViewReview.reloadData()
                }
            }
            
            print(snapshot)
        }, withCancel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchComments()
        tableViewReview.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForReviews()
        //fetchComments()
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(tableViewReview)
        tableViewReview.dataSource = self
        tableViewReview.delegate = self
        tableViewReview.backgroundColor = UIColor.orange
        
        tableViewReview.register(BandCellReview.self, forCellReuseIdentifier: bandCellReviewId)
        
        
        self.tableViewReview.allowsMultipleSelectionDuringEditing = false
        
        
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 50, y: 50, width: 250, height: 250), collectionViewLayout: flowLayout)
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
        
        
        
        
        
        
        view.addSubview(movieTitle)
        view.addSubview(movieRelease)
        view.addSubview(movieGenres)
        view.addSubview(likeButton)
        view.addSubview(dislikeButton)
        view.addSubview(likeLabel)
        view.addSubview(dislikeLabel)
        view.addSubview(reviewButton)
        
        
        
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
                
            }
        }
        
        
        
        
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
        
        //        tableViewReview.topAnchor.constraint(equalTo: movieRelease.bottomAnchor, constant: 4)
        //        tableViewReview.leftAnchor.constraint(equalTo: view.leftAnchor)
        //        tableViewReview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        tableViewReview.frame = CGRect(x: 0, y: 480, width: 400, height: 200)
        
        likeButton.frame = CGRect(x: 0, y: 400, width: 80, height: 50)
        dislikeButton.frame = CGRect(x: 250, y: 400, width: 80, height: 50)
        likeLabel.frame = CGRect(x: 92, y: 400, width: 20, height: 50)
        dislikeLabel.frame = CGRect(x: 342, y: 400, width: 20, height: 50)
        reviewButton.frame =  CGRect(x: 250, y: 300, width: 80, height: 50)
        
        //        likeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        //        likeButton.leftAnchor.constraint(equalTo: view.leftAnchor)
        //
        //        dislikeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        //        dislikeButton.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        
        
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

class BandCellReview : UITableViewCell
{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier:  reuseIdentifier)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






