//
//  MapViewController.swift
//  WeatherMap
//
//  Created by developer on 12.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import EZLoadingActivity

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var descriptionView: DescriptionView!
    
    @IBOutlet weak var mapBottomSpace: NSLayoutConstraint!
    
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    private let hightOfDescriptionView: CGFloat = 70
    
    var annotaton: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionView.delegate = self
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        centerMapOnLocation(initialLocation)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(MapViewController.annotation(_:)))
        map.addGestureRecognizer(tapGR)
    }
    
    func annotation(gesture: UIGestureRecognizer){
        if let annotaton = self.annotaton{
            map.removeAnnotation(annotaton)
        }
        
        let touchPoint = gesture.locationInView(self.map)
        let coordinate: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
        getPlaceName(coordinate)
        
        annotaton = MKPointAnnotation()
        annotaton?.coordinate = coordinate
        
        guard let annotaton = annotaton else { fatalError("Don't create annotation") }
        map.addAnnotation(annotaton)
        print(coordinate)
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func showDescriptionView(city city: String, coordinate: CLLocationCoordinate2D) {
        self.descriptionView.cityLabel.text = city
        let latStr = NSString(format: "%.5f", coordinate.latitude)
        let lonStr = NSString(format: "%.5f", coordinate.longitude)
        self.descriptionView.coordinateLabel.text = "lat = \(latStr)    lon = \(lonStr)"
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseOut, animations: {
            self.mapBottomSpace.constant = self.hightOfDescriptionView
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func hideDescriptionView() {
        UIView.animateWithDuration(0.9, delay: 0.0, options: .CurveEaseOut, animations: {
            self.mapBottomSpace.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    
    func getPlaceName(coordinate: CLLocationCoordinate2D) {
        EZLoadingActivity.show(StatusConstants.Loading.findLocation, disableUI: true)
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: {[unowned self](placemarks, error) -> Void in
            if let _ = error {
                EZLoadingActivity.hideWithText(StatusConstants.Failed.noInternet, success: false, animated: false)
                self.hideDescriptionView()
            } else if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let pm = placemarks[0] as CLPlacemark
                    if let locality = pm.locality {
                        EZLoadingActivity.hide()
                        self.showDescriptionView(city: locality, coordinate: coordinate)
                    }else{
                        EZLoadingActivity.hideWithText(StatusConstants.Failed.cityDontFind, success: false, animated: false)
                        self.hideDescriptionView()
                    }
                }else{
                    EZLoadingActivity.hideWithText(StatusConstants.Failed.cityDontFind, success: false, animated: false)
                    self.hideDescriptionView()
                }
            } else {
                EZLoadingActivity.hideWithText(StatusConstants.Failed.cityDontFind, success: false, animated: false)
                print("Problems with the data received from geocoder.")
                self.hideDescriptionView()
            }
        })
        
    }
}

extension MapViewController: DescriptionButtonDelegate {
    func showWeather(){
        guard let city = descriptionView.cityLabel.text else { fatalError("City did't find") }
        EZLoadingActivity.show(StatusConstants.Loading.load, disableUI: true)
        WebHelper.getWeather(city,
            success: {[unowned self](result) in
                if let result = result {
                    EZLoadingActivity.hide()
                    let weatherVC = WeatherViewController(weather: result)
                    self.showViewController(UINavigationController(rootViewController: weatherVC), sender: self)
                }else{
                    EZLoadingActivity.hideWithText(StatusConstants.Failed.noWeather, success: false, animated: false)
                }
            },
            failed:{(error) in
                EZLoadingActivity.hideWithText(StatusConstants.Failed.noInternet, success: false, animated: false)
                print("Error")
            }
        )

        
    }
}

extension EZLoadingActivity{
    public static func hideWithText(text: String, success: Bool?, animated: Bool){
        if let success = success{
            if success{
                Settings.SuccessText = text
            }else{
                Settings.FailText = text
            }
        }
        hide(success: success, animated: animated)
    }
}