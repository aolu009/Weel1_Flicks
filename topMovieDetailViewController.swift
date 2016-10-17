//
//  movieDetailViewController.swift
//  Weel1_Flicks
//
//  Created by Lu Ao on 10/15/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import MBProgressHUD

class topMovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieDetail: UIView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    @IBOutlet var backgroundImage: UIImageView!
    
    
    var backgroundImageUrl : String?
    var movieTitle : String?
    var rating : Double?
    var releaseDate : String?
    var movieOverview : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
        self.movieTitleLabel.text = movieTitle
        self.ratingLabel.text = String(describing: rating!) + "/10"
        self.releaseDateLabel.text = releaseDate
        self.movieOverviewLabel.text = movieOverview
        
        self.movieDetail.frame.size.height = 0
        self.movieDetail.frame.size.width = 0
        self.movieTitleLabel.frame.size.height = 0
        self.movieTitleLabel.frame.size.width = 0
        self.ratingLabel.frame.size.height = 0
        self.ratingLabel.frame.size.width = 0
        self.releaseDateLabel.frame.size.height = 0
        self.releaseDateLabel.frame.size.width = 0
        self.movieOverviewLabel.frame.size.height = 0
        self.movieOverviewLabel.frame.size.width = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.movieDetail.frame.size.height = 323
            self.movieDetail.frame.size.width = 375
            self.movieTitleLabel.frame.size.height = 21
            self.movieTitleLabel.frame.size.width = 223
            self.ratingLabel.frame.size.height = 21
            self.ratingLabel.frame.size.width = 69
            self.releaseDateLabel.frame.size.height = 21
            self.releaseDateLabel.frame.size.width = 116
            self.movieOverviewLabel.frame.size.height = 223
            self.movieOverviewLabel.frame.size.width = 332
        })
        MBProgressHUD.showAdded(to: self.view, animated: true)
        backgroundImage.setImageWith(URL(string:backgroundImageUrl!)!)
        
        // Hide HUD once the network request comes back (must be done on main UI thread)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
}
