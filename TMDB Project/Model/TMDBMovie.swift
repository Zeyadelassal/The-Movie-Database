//
//  TMDBMovie.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/3/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import UIKit

class TMDBMovie: NSObject
{
    let id : String
    let title : String
    let desc : String
    let rating : String
    var starRating : Double = 0.0
    let duration : String
    let releaseYear : String
    var imageStr : String
    var image = UIImage(named:"Placeholder")
    var isFavorite : Bool = false
    
    init(id : String ,title : String ,desc : String ,rating : String ,duration : String ,releaseYear : String, imageStr : String)
    {
        self.id = id
        self.title = title
        self.desc = desc
        self.rating = rating
        self.duration = duration
        self.releaseYear = releaseYear
        self.imageStr = imageStr
    }
}
