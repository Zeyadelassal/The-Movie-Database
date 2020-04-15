//
//  TMDBFavMoviesManager.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/8/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import UIKit
import CoreData

class TMDBFavMoviesManager: NSObject {
    
    var favMovies = [TMDBMovie]()
    var fetchedMovieArr = [NSManagedObject]()
    let dataController = DataController.sharedInstance()
    
    func addMovie(movie : TMDBMovie)
    {
        movie.isFavorite = true
        favMovies.append(movie)
        dataController.saveData(savedMovie: movie)
        dataController.saveContext()
    }
    
    func deleteMovie(index : Int)
    {
        favMovies.remove(at: index)
        fetchedMovieArr = dataController.fetchData()
        dataController.deleteData(movie: fetchedMovieArr[index])
    }
    
    func getFavMovies() -> [TMDBMovie]
    {
        return favMovies
    }
    
    func getSavedMovies() -> [TMDBMovie]
    {
        fetchedMovieArr = dataController.fetchData()
        favMovies = createMovieArr()
        return favMovies
    }
    
    func createMovieArr() -> [TMDBMovie]
    {
        var retMovies = [TMDBMovie]()
        for fetchedMovie in fetchedMovieArr
        {
            let id = fetchedMovie.value(forKey: "id") as! String
            let title = fetchedMovie.value(forKey: "title") as! String
            let releaseYear = fetchedMovie.value(forKey: "releaseYear") as! String
            let rating = fetchedMovie.value(forKey: "rating") as! String
            let duration = fetchedMovie.value(forKey: "duration") as! String
            let desc = fetchedMovie.value(forKey: "desc") as! String
            let image = fetchedMovie.value(forKey: "image") as! Data
            let imageStr = fetchedMovie.value(forKey: "imageStr") as! String
            let starRating = fetchedMovie.value(forKey: "starRating") as! Double

            let movie = TMDBMovie(id: id, title: title, desc: desc, rating: rating, duration: duration, releaseYear: releaseYear, imageStr: imageStr)
            movie.isFavorite = true
            movie.starRating = starRating
            movie.image = UIImage(data: image)
            retMovies.append(movie)
        }
        return retMovies
    }
    
    class func sharedInstance() -> TMDBFavMoviesManager
    {
        struct Singleton
        {
            static var sharedInstance = TMDBFavMoviesManager()
        }
        return Singleton.sharedInstance
    }

}
