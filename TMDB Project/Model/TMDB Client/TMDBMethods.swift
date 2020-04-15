//
//  TMDBMethods.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/3/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import Foundation

extension TMDBClient
{
    func getPopularMovies(completionHandlerForGetPopularMovies : @escaping(_ movie : [TMDBMovie]? ,_ error : NSError?) -> Void)
    {
        let parameters = [TMDBClient.ParameterKeys.APIKey : TMDBClient.ParameterValues.APIKey,
                          TMDBClient.ParameterKeys.language : TMDBClient.ParameterValues.english]
        let _ = taskForGETMethod(method: TMDBClient.Methods.popular, parameters: parameters as [String : AnyObject]) { (movies, error) in
            
            if let error = error
            {
                completionHandlerForGetPopularMovies(nil,error)
            }
            else
            {
                let movieDic = movies as! [String : AnyObject]
                let movies = self.config.createMovieArr(movieDic: movieDic)
                completionHandlerForGetPopularMovies(movies,nil)
            }
        }
    }
    
    func getUpComingMovies(completionHandlerForGetUpComingMovies : @escaping(_ movie : [TMDBMovie]?,_ error : NSError?) -> Void)
    {
        let parameters = [TMDBClient.ParameterKeys.APIKey : TMDBClient.ParameterValues.APIKey,
                          TMDBClient.ParameterKeys.language : TMDBClient.ParameterValues.english,
                          TMDBClient.ParameterKeys.region : TMDBClient.ParameterValues.US]
        
        let _ = taskForGETMethod(method: TMDBClient.Methods.upComing, parameters: parameters as [String : AnyObject]) { (movies, error) in
            
            if let error = error
            {
                completionHandlerForGetUpComingMovies(nil,error)
            }
            else
            {
                let movieDic = movies as! [String : AnyObject]
                let movies = self.config.createMovieArr(movieDic: movieDic)
                completionHandlerForGetUpComingMovies(movies,nil)
            }
        }
    }
    
    func getTopRatedMovies(completionHandlerForGetTopRatedMovies : @escaping(_ movie : [TMDBMovie]? ,_ error : NSError?) -> Void)
    {
        let parameters = [TMDBClient.ParameterKeys.APIKey : TMDBClient.ParameterValues.APIKey,
                          TMDBClient.ParameterKeys.language : TMDBClient.ParameterValues.english]
        let _ = taskForGETMethod(method: TMDBClient.Methods.topRated, parameters: parameters as [String : AnyObject]) { (movies, error) in
            
            if let error = error
            {
                completionHandlerForGetTopRatedMovies(nil,error)
            }
            else
            {
                let movieDic = movies as! [String : AnyObject]
                let movies = self.config.createMovieArr(movieDic: movieDic)
                completionHandlerForGetTopRatedMovies(movies,nil)
                
            }
        }
    }
    
    func getMovieDetails(movidID : String, completionHandlerForGetMovieDetails : @escaping (_ movie : TMDBMovie?, _ error : NSError?) -> Void)
    {
        let paramaters = [TMDBClient.ParameterKeys.APIKey : TMDBClient.ParameterValues.APIKey]
        let _ = taskForGETMethod(method: "/\(movidID)", parameters: paramaters as [String : AnyObject]) { (movie, error) in
            if let error = error
            {
                completionHandlerForGetMovieDetails(nil ,error)
            }
            else
            {
                let movieDic = movie as! [String : AnyObject]
                let movie = self.config.createMovie(movieDic: movieDic)
                completionHandlerForGetMovieDetails(movie,nil)
            }
        }
    }
    
    func getVideos(movieID : String , completionHandlerForGetVideos : @escaping (_ video : [URL]?,_ error:NSError?)->Void)
    {
        let parameters = [TMDBClient.ParameterKeys.APIKey : TMDBClient.ParameterValues.APIKey]
        let _ = taskForGETMethod(method: "/\(movieID)"+TMDBClient.Methods.video, parameters: parameters as [String : AnyObject]) { (videos, error) in
            if let error = error
            {
                completionHandlerForGetVideos(nil,error)
            }
            else
            {
                let videoDic = videos as! [String : AnyObject]
                let videosURL = self.config.createVideoURLArr(videoDic: videoDic)
                completionHandlerForGetVideos(videosURL,nil)
            }
        }
        
    }
    
    func getReviews(movieID : String , completionHandlerForGetReviews : @escaping (_
        author : [String]?,_ content : [String]? ,_ error:NSError?)->Void)
    {
        let parameters = [TMDBClient.ParameterKeys.APIKey : TMDBClient.ParameterValues.APIKey]
        let _ = taskForGETMethod(method: "/\(movieID)"+TMDBClient.Methods.review, parameters: parameters as [String : AnyObject]) { (reviews, error) in
            if let error = error
            {
                completionHandlerForGetReviews(nil,nil,error)
            }
            else
            {
                let reviewDic = reviews as! [String : AnyObject]
                let (authorArr,contentArr) = self.config.createReviewArrs(reviewDic: reviewDic)
                completionHandlerForGetReviews(authorArr,contentArr,nil)
            }
        }
        
    }
    
    
    
}





