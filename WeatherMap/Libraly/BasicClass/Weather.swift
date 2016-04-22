//
//  Weather.swift
//  WeatherMap
//
//  Created by developer on 15.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import ObjectMapper
class Weather: Mappable{
    var city: String?
    var clouds: Int?
    var humidity: Int?
    var pressure: Int?
    var temp: Double?
    var temp_max: Double?
    var temp_min: Double?
    var sunrise: Double?
    var sunset: Double?
    var descriptionWeather: [DescriptionWeather]?
    var windDeg: Int?
    var windSpeed: Int?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        city <- map["name"]
        clouds <- map["clouds.all"]
        humidity <- map["main.humidity"]
        pressure <- map["main.pressure"]
        temp <- map["main.temp"]
        temp_max <- map["main.temp_max"]
        temp_min <- map["main.temp_min"]
        sunrise <- map["sys.sunrise"]
        sunset <- map["sys.sunset"]
        descriptionWeather <- map["weather"]
        windDeg <- map["wind.deg"]
        windSpeed <- map["wind.speed"]
    }
    
    func getDictinaryProperty() -> [Property]{
        var dictinary = [Property]()
        if let clouds = clouds{
            dictinary.append(Property(name: "Cloud", value: "\(clouds)%"))
        }
        if let humidity = humidity{
            dictinary.append(Property(name: "Humidity", value: "\(humidity)%"))
        }
        if let pressure = pressure{
            dictinary.append(Property(name: "Pressure", value: "\(pressure)mm"))
        }
        if let sunrise = sunrise{
            let time = NSDate(timeIntervalSince1970: sunrise)
            dictinary.append(Property(name: "Sunrise", value: time.getTimeForProperty()))
        }
        if let sunset = sunset{
            let time = NSDate(timeIntervalSince1970: sunset)
            dictinary.append(Property(name: "Sunset", value: time.getTimeForProperty()))
        }
        if let windSpeed = windSpeed{
            dictinary.append(Property(name: "Wind", value: "\(windSpeed)m/c"))
        }
        return dictinary
    }
    
}

class DescriptionWeather: Mappable{
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

struct Property{
    var name: String
    var value: String
}