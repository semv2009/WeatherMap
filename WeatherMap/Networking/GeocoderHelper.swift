//
//  GeocoderHelper.swift
//  WeatherMap
//
//  Created by developer on 27.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import MapKit

class GeocoderHelper {
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
