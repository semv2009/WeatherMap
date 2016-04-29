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
    
    @IBOutlet weak var topWeatherView: WeatherTempView!
    @IBOutlet weak var weatherDetailsCollectionView: UICollectionView!
    var weatherProperties = [WeatherProperty]()
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWeatherDetailsCollectionView()
        configureNavigationBar()
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
    
    func configureWeatherDetailsCollectionView() {
        weatherDetailsCollectionView.delegate = self
        weatherProperties = weather.getProperties()
        weatherDetailsCollectionView.registerNib(UINib(nibName: "WeatherDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeatherDetailsCell")

    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(WeatherViewController.dismiss))
    }
    
    func calculateCellWidth() {
        if let layout = weatherDetailsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = weatherDetailsCollectionView.bounds.width / 4.0
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
            self.title = self.title! + "(\(time.getDayFormat()))"
        }
        
        topWeatherView.updateUI(weather)
    }
}

//MARK: CollectionView Delegate

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calculateCellWidth()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherProperties.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = weatherDetailsCollectionView.dequeueReusableCellWithReuseIdentifier("WeatherDetailsCell", forIndexPath: indexPath) as? WeatherDetailsCollectionViewCell else { fatalError("Can't find cell") }
        let property = weatherProperties[indexPath.row]
        cell.updateUI(property)
        return cell
        
    }
}
