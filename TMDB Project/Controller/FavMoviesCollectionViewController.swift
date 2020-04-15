//
//  FavMoviesCollectionViewController.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/9/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class FavMoviesCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    let favMovieMgr = TMDBFavMoviesManager.sharedInstance()
    var favMoviesArr = [TMDBMovie]()
    var collectionViewFlowLayout:UICollectionViewFlowLayout!

    override func viewDidLoad() {
        favMoviesArr = favMovieMgr.getSavedMovies()
        updateFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favMoviesArr = favMovieMgr.getFavMovies()
        self.collectionView.reloadData()
        print(favMoviesArr.count)
    }
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favMoviesArr.count > 0 ? favMoviesArr.count : 1;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavMovieImageCollectionViewCell
        if (favMoviesArr.count > 0)
        {
            let movie = favMoviesArr[indexPath.item]
            //let movieImageURL = URL(string: TMDBConfig.imageBaseURL +  movie.imageStr)
            cell.favMovieImage.image = movie.image
           
        }
        else
        {
            cell.favMovieImage.image = UIImage(named: "Placeholder")
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsViewController
        let movie = favMoviesArr[indexPath.item]
        movieDetailsVC.movieID = movie.id
        movieDetailsVC.mTitle = movie.title
        movieDetailsVC.srcVC = "favoriteVC"
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
      }
    
    func updateFlowLayout()
    {
        if collectionViewFlowLayout == nil
        {
            let numberOfItemPerRow :CGFloat = 2
            let minimunLineSpacing :CGFloat = 0
            let minimunInteritemSpacing :CGFloat = 0
            
            let width = (self.collectionView.frame.width / numberOfItemPerRow)
            let height = width * 1.72

            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.minimumLineSpacing = minimunLineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = minimunInteritemSpacing
            self.collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    

}
