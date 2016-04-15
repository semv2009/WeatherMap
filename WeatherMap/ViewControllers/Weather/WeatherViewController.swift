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
    var city: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = city
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(WeatherViewController.dismiss))
        
        guard let city = city else { fatalError("City did't find") }
        Alamofire.request(.GET, OpenWeatherMap.URL, parameters: ["q": city,"appid": OpenWeatherMap.API])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let mapper = Mapper<Weather>()
                    let w = mapper.map(JSON)
                    print(w?.windDeg)
                     print(w?.main)
                     print(w?.description)
                     print(w?.temp_max)

                }
        }

    }

    init(city: String) {
        super.init(nibName: nil, bundle: nil)
        self.city = city
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
