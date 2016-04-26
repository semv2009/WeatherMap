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
    
    static func getWeather(city: String, success: (result: Weather?) -> Void, failed: (error: NSError?) -> Void) {
        Alamofire.request(.GET, OpenWeatherMapUrl, parameters: [City: city, AppId: OpenWeatherMap.ApiKey])
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
    
    static func getPlaceName(coordinate: CLLocationCoordinate2D, success: (result: String) -> Void, failed: (error: NSError?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: {(placemarks, error) -> Void in
            if let error = error {
                failed(error: error)
            } else if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let pm = placemarks[0] as CLPlacemark
                    if let locality = pm.locality {
                        success(result: locality)
                        return
                    }
                }
                failed(error: nil)
            }
        })
    }
}
