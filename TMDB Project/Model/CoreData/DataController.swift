//
//  DataController.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/9/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController
{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedObjectContext : NSManagedObjectContext
    let entity : NSEntityDescription
    var movies = [NSManagedObject]()
    
    init() {
        managedObjectContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "TMDBMovieEnt", in: managedObjectContext)!
    }
    
    func saveData(savedMovie : TMDBMovie)
    {
        let movie = NSManagedObject.init(entity: entity, insertInto: managedObjectContext)
        let id = savedMovie.id
        let title = savedMovie.title
        let rating = savedMovie.rating
        let releaseYear = savedMovie.releaseYear
        let duration = savedMovie.duration
        let desc = savedMovie.desc
        let imageStr = TMDBConfig.imageBaseURL + savedMovie.imageStr
        print(imageStr)
        let imageURL = URL(string:imageStr)
        print(TMDBConfig.imageBaseURL + imageStr)
        let imageData = try? Data(contentsOf: imageURL!)
        let starRating = savedMovie.starRating
        
        movie.setValue(id, forKey :"id")
        movie.setValue(title, forKey: "title")
        movie.setValue(rating, forKey: "rating")
        movie.setValue(releaseYear, forKey: "releaseYear")
        movie.setValue(duration, forKey: "duration")
        movie.setValue(desc, forKey:"desc")
        movie.setValue(imageStr, forKey: "imageStr")
        movie.setValue(imageData, forKey: "image")
        movie.setValue(starRating, forKey:"starRating")
        
        
    }
    
    func saveContext()
    {
        do
        {
            try managedObjectContext.save()
        }catch let error as NSError{
            print(error)
        }
    }
    
    func fetchData() -> [NSManagedObject]
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TMDBMovieEnt")
        do{
            movies = try managedObjectContext.fetch(fetchRequest)
        }catch let error as NSError{
            print(error)
        }
        return movies
    }
    
    func deleteData(movie : NSManagedObject)
    {
        managedObjectContext.delete(movie)
        do{
            try managedObjectContext.save()
        }catch{
            print("Data Can't be deleted")
        }
    }
    
    
    class func sharedInstance() -> DataController
    {
        struct Singleton
        {
            static var sharedInstance = DataController()
        }
        return Singleton.sharedInstance
    }
}
