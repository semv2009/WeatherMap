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

class WeatherViewController: UIViewController {
    var weather: Weather!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = city
        print(weather.clouds)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(WeatherViewController.dismiss))
        
        
//        WebHelper.getWeather(city) ,
//            succsess:{ (result) in
//                print("Clouds = \(result?.clouds)")
//            },
//        failed:{
//            
//        }
        
    }

    init(weather: Weather) {
        super.init(nibName: nil, bundle: nil)
        self.weather = weather
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
