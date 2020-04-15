//
//  MoviesCollectionViewController.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/8/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import UIKit
import RevealingSplashView
import BTNavigationDropdownMenu

private let reuseIdentifier = "cell"

class MoviesCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    let client = TMDBClient()
    var moviesArray = [TMDBMovie]()
    let items = ["Most Popular", "Upcoming", "Top Rated"]
    var collectionViewFlowLayout:UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "splashicon")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red: 105, green: 105, blue: 105, alpha: 1.0))
        
        revealingSplashView.animationType = SplashAnimationType.swingAndZoomOut

        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)

        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }

        loadSortingMenu()
        
        if(Reachability.isConnectedToNetwork())
        {
            getPopularMovies()
            updateFlowLayout()
        }
        else
        {
            alert(message: "Please Check your internet connection")
        }
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.collectionView.frame.size)
        print(self.collectionView.bounds.size)
        print(UIScreen.main.bounds)
    }
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count > 0 ? moviesArray.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieImageCollectionViewCell
        if (moviesArray.count > 0)
        {
            let movie = moviesArray[indexPath.item]
            let movieImageURL = URL(string: TMDBConfig.imageBaseURL + movie.imageStr)
            if let  movieImageData = try? Data(contentsOf: movieImageURL!)
            {
                cell.movieImage.image = UIImage(data: movieImageData)
            }
        }
        else
        {
            cell.movieImage.image = UIImage(named: "Placeholder")
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(moviesArray.count > 0)
        {
            let movieDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsViewController
            let movie = moviesArray[indexPath.item]
            movieDetailsVC.movieID = movie.id
            movieDetailsVC.mTitle = movie.title
            movieDetailsVC.srcVC = "collectionVC"
            self.navigationController?.pushViewController(movieDetailsVC, animated: true)
        }
        else
        {
            alert(message: "No movies please check your internet connection")
        }
    }
    
    func getPopularMovies()
    {
        client.getPopularMovies {(movies,error) in
            if let error = error
            {
                self.alert(message:"There is error : \(error)")
            }
            else
            {
                self.moviesArray = movies!
                DispatchQueue.main.async
                    {
                        self.collectionView.reloadData()
                }
            }
        }
    }
    
    func getUpComingMovies()
       {
           client.getUpComingMovies {(movies,error) in
               if let error = error
               {
                   self.alert(message:"There is error : \(error)")
               }
               else
               {
                   self.moviesArray = movies!
                   DispatchQueue.main.async
                       {
                           self.collectionView.reloadData()
                   }
               }
           }
       }
    
    func getTopRatedMovies()
          {
              client.getTopRatedMovies {(movies,error) in
                  if let error = error
                  {
                      self.alert(message:"There is error : \(error)")
                  }
                  else
                  {
                      self.moviesArray = movies!
                      DispatchQueue.main.async
                          {
                              self.collectionView.reloadData()
                      }
                  }
              }
          }
    
    func updateFlowLayout()
    {
        if collectionViewFlowLayout == nil
        {
            let numberOfItemPerRow :CGFloat = 2
            let minimunLineSpacing :CGFloat = 0
            let minimunInteritemSpacing :CGFloat = 0
            
            let width = (self.collectionView.frame.width / numberOfItemPerRow)
            let height = ((self.collectionView.bounds.height - 44-49) / numberOfItemPerRow)
                //width * 1.72
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.minimumLineSpacing = minimunLineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = minimunInteritemSpacing
            self.collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    func loadSortingMenu()
    {
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("Sort by"), items: items)
        
        self.navigationItem.titleView = menuView
              
        menuView.didSelectItemAtIndexHandler = { [weak self] (indexPath: Int) -> () in
                switch indexPath
                {
                    case 1:
                        self?.getUpComingMovies()
                    case 2:
                        self?.getTopRatedMovies()
                    default:
                        self?.getPopularMovies()
                }
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
    
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
////            let h  = UIScreen.main.bounds.size.height / 2
////            let w = UIScreen.main.bounds.size.width / 2
//            return CGSize(width: collectionView.frame.width/2 , height: collectionView.frame.height/2);
//        }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        return CGSize(width: CGFloat((collectionView.frame.size.width / 2) - 10 ), height: (collectionView.frame.size.height / 2 ) - 50)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
//    {
//        return UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
//    }
    
}
