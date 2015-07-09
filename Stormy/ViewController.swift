//
//  ViewController.swift
//  Stormy
//
//  Created by Jeffrey Leonard on 11/24/14.
//  Copyright (c) 2014 Jeffrey Leonard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    
    private let apiKey = ""// your key goes here

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshActivityIndicator.hidden = true
        getCurrentWeatherData()
      
        }
    
   
    
    func getCurrentWeatherData() -> Void {
    
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "32.693,-117.183624", relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
        if (error == nil){
            let dataObject = NSData(contentsOfURL: location)
            let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as! NSDictionary
            let currentWeather = Current(weatherDictionary: weatherDictionary)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.temperatureLabel.text = "\(currentWeather.temperature)"
                self.iconView.image = currentWeather.icon!
                self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                self.humidityLabel.text = "\(currentWeather.humidity)"
                self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                self.summaryLabel.text = "\(currentWeather.summary)"
                self.refreshActivityIndicator.stopAnimating()
                self.refreshActivityIndicator.hidden = true
                self.refreshButton.hidden = false
            })
    
    
        }
    })
    downloadTask.resume()
    
    
    }
    
    @IBAction func refresh() {
        getCurrentWeatherData()
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

