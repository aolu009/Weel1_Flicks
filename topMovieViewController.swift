//
//  ViewController.swift
//  Weel1_Flicks
//
//  Created by Lu Ao on 10/15/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//
// Need to find a apikey
import UIKit
import AFNetworking
import MBProgressHUD

class topMoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var networkError: UIView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var movieTable: UITableView!
    
    var movieArray : Array? = [NSDictionary]()
    var movieTitle : String?
    var releaseDate : String?
    var rating : String?
    
    //var outOfTen : String? = "/10"
    override func viewDidLoad() {
        super.viewDidLoad()
        networkError.isHidden = true
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        movieTable.rowHeight = 150
        movieTable.insertSubview(refreshControl, at: 1)
        
        //Fire initial Request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        _ = URL(string:"https://api.themoviedb.org/3/movie/top_rated?language=en-US&api_key=\(apiKey)")
        let url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?language=en-US&api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //NSLog("response: \(responseDictionary)")
                    self.networkError.isHidden = true
                    //Retrive master dictionary array
                    self.movieArray = responseDictionary["results"] as? [NSDictionary]
                    //print("self.movieArray:", self.movieArray) //Tesing point see if internet connection is correct
                    // Hide HUD once the network request comes back (must be done on main UI thread)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.movieTable.reloadData()
                }
            }
            else{
                MBProgressHUD.hide(for: self.view, animated: true)
                self.networkError.frame.size.height = 0
                self.networkErrorLabel.frame.size.height = 0
                UIView.animate(withDuration: 0.2, delay: 0, animations: {
                    self.networkError.frame.size.height = 30
                    self.networkErrorLabel.frame.size.height = 20
                })
                self.networkError.isHidden = false
                print("Network unavailable")
            }
        })
        task.resume()
    }
    
    
    // Setup table view detail via protocal
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movie = self.movieArray{
            return movie.count
        }
        else {
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Declare vars for extracting data
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! movieTableCell
        let posterUrl : String! = "https://image.tmdb.org/t/p/original"
        var posterImageComplete : String?
        cell.accessoryType = UITableViewCellAccessoryType(rawValue: 0)!
        
        //Extracting data layer by layer
        let movie = self.movieArray?[indexPath.row]
        cell.titleText.text = movie?["title"] as? String
        cell.descriptionText.text = movie?["overview"] as? String
        
        //cell.descriptionText.sizeToFit() //Still not fitting the space
        if let imageIdUrl = movie?["poster_path"] as? String{
            posterImageComplete = posterUrl + imageIdUrl
            print("imageUrl:",posterImageComplete)
            cell.moviePost.setImageWith(URL(string:posterImageComplete!)!)
        }
        /*
         else{
         //Testing code
         }
         */
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        _ = URL(string:"https://api.themoviedb.org/3/movie/top_rated?language=en-US&api_key=\(apiKey)")
        let url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?language=en-US&api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //NSLog("response: \(responseDictionary)")
                    self.networkError.isHidden = true
                    self.movieArray = responseDictionary["results"] as? [NSDictionary]
                    //print("Testing:", self.sourceDictionary)
                    // Reload the tableView now that there is new data
                    self.movieTable.reloadData()
                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
                }
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.networkError.frame.size.height = 0
                    self.networkErrorLabel.frame.size.height = 0
                    UIView.animate(withDuration: 0.2, delay: 0, animations: {
                        self.networkError.frame.size.height = 30
                        self.networkErrorLabel.frame.size.height = 20
                    })
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.networkError.isHidden = false
                    print("Network unavailable")
                }
            }
        })
        task.resume()
    }
    
    //Passing Data to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Get the suitable backgroung Image
        let destinationVC = segue.destination as! movieDetailViewController
        let indexPath = movieTable.indexPath(for: sender as! movieTableCell)
        let movie = self.movieArray?[(indexPath?.row)!]
        let posterUrl : String! = "https://image.tmdb.org/t/p/original"
        if let imageIdUrl = movie?["poster_path"] as? String{
            destinationVC.backgroundImageUrl = posterUrl + imageIdUrl
            print("imageUrl:",destinationVC.backgroundImageUrl)
            
        }
        if let movieTitle = movie?["title"] as? String{
            destinationVC.movieTitle = movieTitle
            
        }
        if let rating = movie?["vote_average"] as? Double{
            destinationVC.rating = rating
            
        }
        if let releaseDate = movie?["release_date"] as? String{
            destinationVC.releaseDate = releaseDate
            
        }
        if let movieOverview = movie?["overview"] as? String{
            destinationVC.movieOverview = movieOverview
            
        }
    }
}

