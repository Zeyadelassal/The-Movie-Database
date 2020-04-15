//
//  TMDBConstants.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/2/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import Foundation
extension TMDBClient
{
    struct Constants
    {
        static let APIScheme = "https"
        static let APIHost = "api.themoviedb.org"
        static let APIPath = "/3/movie"
    }
    
    struct Methods
    {
        static let video = "/videos"
        static let review = "/reviews"
        static let popular = "/popular"
        static let topRated = "/top_rated"
        static let upComing = "/upcoming"
    }
    
    struct ParameterKeys
    {
        static let APIKey = "api_key"
        static let language = "language"
        static let page = "page"
        static let region = "region"
    }
    
    struct ParameterValues
    {
        static let APIKey = "8d86b45832de2379ea7b235717f8213a"
        static let english = "en-US"
        static let US = "US"
    }
    
    struct JSONResponseKeys {
        static let results = "results"
        
        //MARK : Movie
        static let id = "id"
        static let title = "title"
        static let rating = "vote_average"
        static let posterPath = "poster_path"
        static let overView = "overview"
        static let releaseDate = "release_date"
        static let duration = "runtime"
        
        //MARK : Video
        static let videoType = "type"
        static let videoKey = "key"
        
        //MARK : Review
        static let author = "author"
        static let content = "content"
    }
    
    struct JSONResponseValues {
        static let trailer = "Trailer"
    }
}
