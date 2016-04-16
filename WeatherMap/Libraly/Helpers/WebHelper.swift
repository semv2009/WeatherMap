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

class WebHelper{
    private static let OpenWeatherMapUrl: String = "http://api.openweathermap.org/data/2.5/weather"
    private static let City = "q"
    private static let AppId = "appid"
    
    static func getWeather(city: String, success: (result: Weather?) -> Void ,failed: (error: NSError?) -> Void){
        Alamofire.request(.GET, OpenWeatherMapUrl, parameters: [City: city, AppId: OpenWeatherMap.ApiKey])
            .responseJSON { response in
                if let error = response.result.error{
                    failed(error: error)
                }else{
                    if let JSON = response.result.value {
                        let mapper = Mapper<Weather>()
                        let w = mapper.map(JSON)
                        print(JSON)
                        success(result: w)
                    }else{
                        success(result: nil)
                    }
                }
        }
    }
}