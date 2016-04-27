//
//  CLLocationCoordinate2D+StringRepresentation.swift
//  WeatherMap
//
//  Created by developer on 27.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func toString() -> String {
        let latStr = NSString(format: "%.5f", latitude)
        let lonStr = NSString(format: "%.5f", longitude)
        return "lat = \(latStr)    lon = \(lonStr)"
    }
}
