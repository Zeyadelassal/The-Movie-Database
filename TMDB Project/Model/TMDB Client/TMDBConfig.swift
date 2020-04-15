//
//  TMDBConfig.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/7/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import UIKit

class TMDBConfig: NSObject {
    
   static let imageBaseURL = "https://image.tmdb.org/t/p/w185"
    
    
     func  createMovieArr(movieDic : [String : AnyObject]) -> [TMDBMovie]
    {
        var movieArr = [[String : AnyObject]]()
        movieArr = movieDic[TMDBClient.JSONResponseKeys.results] as! [[String : AnyObject]]
        var moviesArr = [TMDBMovie]()
        for movie in movieArr
        {
        let id = String(describing: movie[TMDBClient.JSONResponseKeys.id]!)
        let title = movie[TMDBClient.JSONResponseKeys.title] as! String
        let desc = movie[TMDBClient.JSONResponseKeys.overView] as! String
        let rating = String(describing:movie[TMDBClient.JSONResponseKeys.rating]! as! Double)
        let duration = movie[TMDBClient.JSONResponseKeys.duration] as? String ?? ""
        let imageStr = movie[TMDBClient.JSONResponseKeys.posterPath] as? String ?? ""
        let releaseDate = movie[TMDBClient.JSONResponseKeys.releaseDate] as! String
        let releaseYear = releaseDate.prefix(4)
            moviesArr.append(TMDBMovie(id: id, title: title, desc: desc, rating: rating, duration: duration, releaseYear: String(releaseYear), imageStr: imageStr))
        }
    return moviesArr
    }
    
     func createMovie(movieDic : [String : AnyObject]) -> TMDBMovie
    {
        
        let id = String(describing: movieDic[TMDBClient.JSONResponseKeys.id]!)
        let title = movieDic[TMDBClient.JSONResponseKeys.title] as! String
        let desc = movieDic[TMDBClient.JSONResponseKeys.overView] as! String
        let rating = String(describing:movieDic[TMDBClient.JSONResponseKeys.rating]! as! Double)
        let duration = String(describing: movieDic[TMDBClient.JSONResponseKeys.duration]!)
        let imageStr = movieDic[TMDBClient.JSONResponseKeys.posterPath] as? String ?? ""
        let releaseDate = movieDic[TMDBClient.JSONResponseKeys.releaseDate] as! String
        let releaseYear = releaseDate.prefix(4)
        return TMDBMovie(id: id, title: title, desc: desc, rating: rating, duration: duration, releaseYear: String(releaseYear), imageStr: imageStr)
    }
    
     func createVideoURLArr(videoDic : [String : AnyObject]) -> [URL]
    {
        var videoArr = [[String : AnyObject]]()
        videoArr = videoDic[TMDBClient.JSONResponseKeys.results] as! [[String : AnyObject]]
        var videosKeyArr = [String]()
        for video in videoArr
        {
            if ((video[TMDBClient.JSONResponseKeys.videoType] as! String) == TMDBClient.JSONResponseValues.trailer)
            {
                videosKeyArr.append(video[TMDBClient.JSONResponseKeys.videoKey] as! String)
            }
        }
        return createVideoURL(videosKeyArr: videosKeyArr)
    }

    
    private func createVideoURL(videosKeyArr : [String]) -> [URL]
    {
        let youtubeBaseURL = "https://www.youtube.com/watch?v="
        var videosURL = [URL]()
        for key in videosKeyArr
        {
            let videoURL = URL(string: youtubeBaseURL + key)
            videosURL.append(videoURL!)
        }
        return videosURL
    }
    
     func createReviewArrs(reviewDic : [String : AnyObject]) -> ([String],[String])
    {
        var reviewArr = [[String : AnyObject]]()
        reviewArr = reviewDic[TMDBClient.JSONResponseKeys.results] as! [[String : AnyObject]]
        var authorArr = [String]()
        var contentArr = [String]()
        for review in reviewArr
        {
            let author = review[TMDBClient.JSONResponseKeys.author] as! String
            let content = review[TMDBClient.JSONResponseKeys.content] as! String
            authorArr.append(author)
            contentArr.append(content)
        }
        return(authorArr,contentArr)
    }
}
