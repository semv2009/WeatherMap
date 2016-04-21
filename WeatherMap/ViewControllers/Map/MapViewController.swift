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
        centerMapOnLocation(initialLocation)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(MapViewController.annotation(_:)))
        map.addGestureRecognizer(tapGR)
    }
    
    //MARK: MapView
    
    func annotation(gesture: UIGestureRecognizer){
        let coordinate = getCoordinate(gesture)
        makeAnnotation(coordinate)
        
        EZLoadingActivity.show(StatusConstants.Loading.findLocation, disableUI: true)
        WebHelper.getPlaceName(coordinate,
            success: {[unowned self](result) in
                EZLoadingActivity.hide()
                self.showDescriptionView(city: result, coordinate: coordinate)
            },
            failed:{[unowned self] (error) in
                if let _ = error{
                    EZLoadingActivity.hideWithText(StatusConstants.Failed.noInternet, success: false, animated: false)
                }else{
                    EZLoadingActivity.hideWithText(StatusConstants.Failed.cityDontFind, success: false, animated: false)
                }
                self.hideDescriptionView()
            }
        )
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func getCoordinate(gesture: UIGestureRecognizer) -> CLLocationCoordinate2D{
        let touchPoint = gesture.locationInView(self.map)
        return  map.convertPoint(touchPoint, toCoordinateFromView: self.map)
    }
    
    func makeAnnotation(coordinate: CLLocationCoordinate2D){
        if let annotaton = self.annotaton{
            map.removeAnnotation(annotaton)
        }
        
        annotaton = MKPointAnnotation()
        annotaton?.coordinate = coordinate
        
        guard let annotaton = annotaton else { fatalError("Don't create annotation") }
        map.addAnnotation(annotaton)
    }
    
    //MARK: DescriptionView
    
    func showDescriptionView(city city: String, coordinate: CLLocationCoordinate2D) {
        self.descriptionView.cityLabel.text = city
        self.descriptionView.coordinateLabel.text = coordinate.toString()
        
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
}

//MARK: Description Button Delegate

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

//MARK: Extension EZLoadingActivity

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

//MARK: Extension CLLocationCoordinate2D

extension CLLocationCoordinate2D{
    func toString() -> String{
        let latStr = NSString(format: "%.5f", latitude)
        let lonStr = NSString(format: "%.5f", longitude)
        return "lat = \(latStr)    lon = \(lonStr)"
    }
}