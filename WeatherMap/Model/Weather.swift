//
//  Weather.swift
//  WeatherMap
//
//  Created by developer on 15.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import ObjectMapper

class Weather: Mappable {
    var city: String?
    var clouds: Int?
    var humidity: Int?
    var pressure: Int?
    var temp: Double?
    var temMax: Double?
    var tempMin: Double?
    var sunrise: Double?
    var sunset: Double?
    var weatherDescription: [WeatherDescription]?
    var windDeg: Int?
    var windSpeed: Int?
    var iconUrl: NSURL? {
        if let descriptions = weatherDescription, icon = descriptions[0].icon {
            return NSURL(string: "http://openweathermap.org/img/w/\(icon).png")
        }
        return nil
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        city <- map["name"]
        clouds <- map["clouds.all"]
        humidity <- map["main.humidity"]
        pressure <- map["main.pressure"]
        temp <- map["main.temp"]
        temMax <- map["main.temp_max"]
        tempMin <- map["main.temp_min"]
        sunrise <- map["sys.sunrise"]
        sunset <- map["sys.sunset"]
        weatherDescription <- map["weather"]
        windDeg <- map["wind.deg"]
        windSpeed <- map["wind.speed"]
    }
    
    func getProperties() -> [WeatherProperty] {
        var properties = [WeatherProperty]()
        if let clouds = clouds {
            properties.append(WeatherProperty(name: "Cloud", value: "\(clouds)%"))
        }
        if let humidity = humidity {
            properties.append(WeatherProperty(name: "Humidity", value: "\(humidity)%"))
        }
        if let pressure = pressure {
            properties.append(WeatherProperty(name: "Pressure", value: "\(pressure)mm"))
        }
        if let sunrise = sunrise {
            let time = NSDate(timeIntervalSince1970: sunrise)
            properties.append(WeatherProperty(name: "Sunrise", value: time.getTimeForProperty()))
        }
        if let sunset = sunset {
            let time = NSDate(timeIntervalSince1970: sunset)
            properties.append(WeatherProperty(name: "Sunset", value: time.getTimeForProperty()))
        }
        if let windSpeed = windSpeed {
            properties.append(WeatherProperty(name: "Wind", value: "\(windSpeed)m/c"))
        }
        return properties
    }
    
}

class WeatherDescription: Mappable {
    var full: String?
    var short: String?
    var icon: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        full <- map["description"]
        short <- map["main"]
        icon <- map["icon"]
    }
}

struct WeatherProperty {
    var name: String
    var value: String
}
