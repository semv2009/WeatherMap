//
//  WebHelper.swift
//  WeatherMap
//
//  Created by developer on 16.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import MapKit

class WebHelper {
    private static let OpenWeatherMapUrl: String = "http://api.openweathermap.org/data/2.5/weather"
    private static let City = "q"
    private static let AppId = "appid"
    private static let Units = "units"
    
    static func getWeather(city: String, success: (result: Weather?) -> Void, failed: (error: NSError?) -> Void) {
        Alamofire.request(.GET, OpenWeatherMapUrl, parameters: [City: city, AppId: OpenWeatherMap.ApiKey, Units: "metric"])
            .responseJSON { response in
                if let error = response.result.error {
                    failed(error: error)
                    error.code
                } else {
                    if let JSON = response.result.value {
                        let mapper = Mapper<Weather>()
                        let w = mapper.map(JSON)
                        success(result: w)
                    } else {
                        success(result: nil)
                    }
                }
        }
    }
}
