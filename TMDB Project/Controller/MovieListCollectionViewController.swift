//
//  MovieListCollectionViewController.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/3/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import UIKit

class MovieListCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    var  client = TMDBClient.sharedInstance()
    var moviesArr = [TMDBMovie]()
    
    @IBOutlet weak var collectionViewFlowOut: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.reloadData()
        updateCellSize()
        client.getPopularMovies { (movies, error) in
                
            if let error = error
            {
                self.alert(message:"There is error : \(error)")
            }
            else
            {
                self.moviesArr = movies!
                print(self.moviesArr.count)
                DispatchQueue.main.async {
                    
                    self.collectionView.reloadData()
                 //   self.updateCellSize()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArr.count>0 ? moviesArr.count : 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieImageCollectionViewCell
        if moviesArr.count > 0
        {
            let movie = moviesArr[indexPath.item]
            let movieImageURL = URL(string: movie.image)
            if let  movieImageData = try? Data(contentsOf: movieImageURL!)
            {
                print("DONE")
                cell.movieImage.image = UIImage(data: movieImageData)
            }
        }
        else
        {
            print("empty")
            cell.movieImage.image = UIImage(named: "Placeholder")
        }
        return cell
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.collectionView.frame.height / 6 * 5, height: self.collectionView.frame.height / 6 * 5)
//    }

    
    private func updateCellSize()
    {
       
        let space: CGFloat = 3
        let items: CGFloat = 3
        
        let dimension = (view.frame.size.width - ((items + 1) * space)) / items
        
         collectionViewFlowOut.minimumInteritemSpacing = space
         collectionViewFlowOut.minimumLineSpacing = space
         collectionViewFlowOut.itemSize = CGSize(width: dimension, height: dimension)
         collectionViewFlowOut.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        collectionView.collectionViewLayout = collectionViewFlowOut

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
