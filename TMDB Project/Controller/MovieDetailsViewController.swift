//
//  MovieDetailsViewController.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/3/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import UIKit
import CoreData
import Cosmos

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieReleaseYear: UILabel!
    @IBOutlet weak var movieDuartion: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    
    @IBOutlet weak var trailersTableView: UITableView!
    @IBOutlet weak var movieDesc: UITextView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var reviewsCollectionView: UICollectionView!

    var collectionViewFlowLayout:UICollectionViewFlowLayout!
    var movieID : String?
    var mTitle : String?
    var srcVC : String?
    var movie : TMDBMovie? = nil
    let client = TMDBClient.sharedInstance()
    let favMovieMgr = TMDBFavMoviesManager.sharedInstance()
    var trailersURL = [URL]()
    var trailersArray = [String]()
    var favMovies = [TMDBMovie]()
    var reviewsArray = [String]()
    var starRating : Double = 0.0
    var image = UIImage(named: "Placeholder ")
    
    override func viewDidLoad() {
        favMovies = favMovieMgr.getSavedMovies()
        ratingView.didTouchCosmos = {rating in
            self.starRating = rating
            if(self.movie!.isFavorite)
            {
                self.movie?.starRating = rating
                self.favMovieMgr.deleteMovie(index:self.getMovieIndex())
                self.favMovieMgr.addMovie(movie: self.movie!)
                self.favMovies = self.favMovieMgr.getFavMovies()
            }
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem(title: "Movie's Details",style: UIBarButtonItem.Style.bordered,target: nil,action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton;
        if(srcVC == "collectionVC")
        {
            getMovieDetails()
            getTrailers()
            getReviews()
            updateFlowLayout()
        }
        else if (srcVC == "favoriteVC")
        {
            favMovies = favMovieMgr.getFavMovies()
            getMovieFromFavArray()
            setUI()
            ratingView.rating = movie!.starRating
        }
    }
    
    @IBAction func favoriteMovie(_ sender: Any)
    {
        if(checkMovie())
        {
            movie?.isFavorite = false
            movie?.starRating = 0.0
            favMovieMgr.deleteMovie(index:self.getMovieIndex())
            favMovies = favMovieMgr.getFavMovies()
            print("FavMovies: \(favMovies.count)")
        }
        else
        {
            movie?.isFavorite = true
            movie?.starRating = starRating
            movie?.image = image
            favMovieMgr.addMovie(movie: movie!)
            favMovies = favMovieMgr.getFavMovies()
            print("FavMovies: \(favMovies.count)")
        }
        configFavoriteButton()
    }
    
    func getMovieFromFavArray()
    {
        for favMovie in favMovies
        {
            print(favMovie.starRating)
            if(movieID == favMovie.id)
            {
                movie = favMovie
                break
            }
        }
    }
    
    func configFavoriteButton()
    {
        self.favButton.imageView!.tintColor = (checkMovie()) ? .red : .black
    }
    
    func checkMovie() -> Bool
    {
        var existFlag = false
        for favMovie in favMovies
        {
            if (movie!.id == favMovie.id)
            {
                existFlag = true
                starRating = favMovie.starRating
                break
            }
        }
        return existFlag
    }
    
    func getMovieIndex() -> Int
    {
        var index = 0
        var movieIndex = 0
        for favMovie in favMovies
        {
            if(movie!.id == favMovie.id)
            {
                movieIndex = index
                break
            }
            index += 1
        }
        return movieIndex
    }
    
    func getMovieDetails()
    {
        client.getMovieDetails(movidID: movieID!) { (retMovie, error) in
            if let error = error
            {
                self.alert(message:"There is error : \(error)")
            }
            else
            {
                self.movie = retMovie
                DispatchQueue.main.async
                {
                    self.setUI()
                }
            }
        }
    }
    
    func getTrailers()
    {
        client.getVideos(movieID: movieID!) { (trailers, error) in
            if let error = error
            {
                self.alert(message:"There is error : \(error)")
            }
            else
            {
                self.createTrailerSArray(trailers: trailers!)
                
                DispatchQueue.main.async
                {
                    self.trailersTableView.reloadData()
                }
            }
        }
    }
    
    func getReviews()
    {
        client.getReviews(movieID: movieID!) { (authors, contents, error) in
            if let error = error
            {
                self.alert(message: "There is error : \(error)")
            }
            else
            {
                self.createReviewsArray(authors: authors!,contents: contents!)
                DispatchQueue.main.async {
                    self.reviewsCollectionView.reloadData()
                }
            }
        }
    }
    
    func createTrailerSArray(trailers : [URL])
    {
        var i = 1
        while (i <= trailers.count) {
            let trailer = "Trailer#\(i)"
            self.trailersArray.append(trailer)
            i += 1
        }
        trailersURL = trailers
        print(trailersURL)
    }
    
    func createReviewsArray(authors : [String],contents : [String])
    {
        var i = 0
        for _ in contents
        {
            let review = "\(authors[i])\n\(contents[i])"
            reviewsArray.append(review)
            print(reviewsArray)
            i+=1
        }
    }
    
    func setUI()
    {
        movieReleaseYear.text = movie?.releaseYear
        movieDuartion.text = movie!.duration + "mins"
        movieRating.text = movie!.rating + "/10"
        movieDesc.text = movie!.desc
        movieTitle.text = mTitle
        let movieImageURL = URL(string: TMDBConfig.imageBaseURL + movie!.imageStr)
        if let movieImageData = try? Data(contentsOf: movieImageURL!)
        {
            image = UIImage(data: movieImageData)
            movieImage.image = image
            
        }
        else
        {
            movieImage.image = movie?.image
        }
        configFavoriteButton()
        ratingView.rating = starRating
    }
    
    func updateFlowLayout()
      {
          if collectionViewFlowLayout == nil
          {
            let numberOfItemPerRow :CGFloat = 1
            let minimunLineSpacing :CGFloat = 0
            let minimunInteritemSpacing :CGFloat = 0
              
            let width = (self.reviewsCollectionView.frame.width / numberOfItemPerRow)
            let height = (self.reviewsCollectionView.frame.height / numberOfItemPerRow)
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.scrollDirection = .horizontal
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.minimumLineSpacing = minimunLineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = minimunInteritemSpacing
            self.reviewsCollectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
                    }
      }
    
    func alert (message : String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (okAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}


extension MovieDetailsViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trailersArray.count > 0 ? trailersArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table")
        let cell = self.trailersTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = trailersArray[indexPath.row]
        cell.imageView!.image = UIImage(named: "youtube")
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Trailers"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = trailersURL[indexPath.row]
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension MovieDetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource
{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewsArray.count > 0 ? reviewsArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReviewCollectionViewCell
        cell.reviewTextView.text = reviewsArray[indexPath.item]
        return cell
    }
    
    
}

