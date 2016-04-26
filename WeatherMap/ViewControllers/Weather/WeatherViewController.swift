//
//  WeatherViewController.swift
//  WeatherMap
//
//  Created by developer on 15.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Kingfisher
class WeatherViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var extentionCollectionView: UICollectionView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var arrayProperty = [Property]()
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WeatherViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        extentionCollectionView.delegate = self
        arrayProperty = weather.getArrayProperty()
        extentionCollectionView.registerNib(UINib(nibName: "ExtentionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        self.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(WeatherViewController.dismiss))
        updateUI()
    }
    
    //MARK: Init
    
    init(weather: Weather) {
        super.init(nibName: nil, bundle: nil)
        self.weather = weather
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Helper UI
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rotated() {
        calculateWidthCell()
    }
    
    func calculateWidthCell() {
        if let layout = extentionCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = extentionCollectionView.bounds.width / 4.0
            let itemHeight = layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }
    
    func updateUI() {
        if let city = weather.city {
            self.title = city
        }
        if let sunrise = weather.sunrise {
            let time = NSDate(timeIntervalSince1970: sunrise)
            self.title = self.title! + "(\(time.getDay()))"
        }
        if let temp = weather.temp {
            tempLabel.text = "\(NSString(format: "%.1f", kelvinToCelsius(temp)))°C"
        }
        if let minTemp = weather.tempMin {
            minTempLabel.text = "Min = \(NSString(format: "%.1f", kelvinToCelsius(minTemp)))°C"
        }
        if let maxTemp = weather.temMax {
            maxTempLabel.text = "Max = \(NSString(format: "%.1f", kelvinToCelsius(maxTemp)))°C"
        }
        if let descriptions = weather.descriptionWeather, description = descriptions[0].full {
            descriptionLabel.text = description
        }
        if let iconUrl = weather.iconUrl {
            weatherImage.kf_setImageWithURL(iconUrl)
        }
    }

    
}

func kelvinToCelsius(temp: Double) -> Double {
    return temp - 273.15
}
//MARK: CollectionView Delegate

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewWillLayoutSubviews() {
        calculateWidthCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayProperty.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = extentionCollectionView.dequeueReusableCellWithReuseIdentifier("myCell", forIndexPath: indexPath) as? ExtentionCollectionViewCell else { fatalError("Can't find cell") }
        let property = arrayProperty[indexPath.row]
        cell.updateUI(property)
        return cell
        
    }
}

// MARK: - NSDate Extension

extension NSDate {
    func getTimeForProperty() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate))
    }
    
    func getDay() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate))
    }
}
