//
//  Model.swift
//  rpalkar05
//
//  Created by Rajesh Palkar on 4/21/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Review: NSObject {
    var email: String!
    var review: String!
}


class FavMovie: NSObject{
    var title: String!
    var imageUrl: String!
    var mID: String!
}

class Movie
{
    var title: String?
    var imgUrl: String?
    var id: Int?
    var hasFav: Bool?
    var favButtonColor = "favButtonColor"
    
    
    
    init(id:Int?, title: String?, imgUrl: String?,hasFav: Bool?){
        self.id = id
        self.title = title
        self.imgUrl = imgUrl
        self.hasFav = false
    }
}

class BandCell : UITableViewCell
{
     var movieID: String!
     var link: MovieListViewController?
    var link2: TopRated?
    var link3: MovieListNowPlaying?
    var link4: ForthVC?
    

    
    /*let cellView: UIView = {
     let view = UIView()
     view.backgroundColor = UIColor.white
     //view.setCellShadow()
     return view
     }()*/
    
    let moviePicture: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
      //  iv.translatesAutoresizingMaskIntoConstraints = true
        return iv
    }()
    
    let movieTitle: UILabel = {
        let lbl = UILabel()
       // lbl.translatesAutoresizingMaskIntoConstraints = true
        lbl.adjustsFontSizeToFitWidth = false
        lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        
        return lbl
    }()
    
    let favButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle("Fav", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
      //  button.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
        return button
    }()
    
    let reviewCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0"
        lbl.textColor = UIColor.black
        lbl.adjustsFontSizeToFitWidth = false
        lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        
        return lbl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:  reuseIdentifier)
        favButton.addTarget(self, action: #selector(handleFav), for: .touchUpInside)
        setup()
    }
    
    
    
    func setup()
    {
        
        moviePicture.frame = CGRect(x: 0, y: 10, width: 100, height: 80)
        movieTitle.frame = CGRect(x: 100, y: 25, width:250, height: 50)
        reviewCountLabel.frame =  CGRect(x: 100, y: 70, width:50, height: 20)
        favButton.frame =  CGRect(x: 360, y: 25, width:40, height: 50)
        
        contentView.addSubview(movieTitle)
        contentView.addSubview(moviePicture)
        contentView.addSubview(reviewCountLabel)
        contentView.addSubview(favButton)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleFav()
    {
        print(1234)
        

        link?.getMovieID(cell: self)
        link2?.getMovieID(cell: self)
        link3?.getMovieID(cell: self)
        link4?.getMovieID(cell: self)
    
        
       
    }
    
    
}






