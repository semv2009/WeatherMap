//
//  MapViewController.swift
//  WeatherMap
//
//  Created by developer on 12.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import MapKit



class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var descriptionView: DescriptionView!
    
    @IBOutlet weak var mapViewButtomToVIew: NSLayoutConstraint!
    
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    private let hightOfDescriptionView: CGFloat = 70
    
    var annotaton: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        mapViewButtomToVIew.constant = 0
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
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func showDescriptionView() {
        print("Transform")
        
        UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
            self.mapViewButtomToVIew.constant = self.hightOfDescriptionView
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    func hideDescriptionView() {
        UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
            self.mapViewButtomToVIew.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    
    func getPlaceName(coordinate: CLLocationCoordinate2D) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: {[unowned self](placemarks, error) -> Void in
            if let error = error {
                print("Reverse geocoder failed with an error" + error.localizedDescription)
            } else if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let pm = placemarks[0] as CLPlacemark
                    if let locality = pm.locality {
                        
                        self.descriptionView.cityLabel.text = locality
                        let latStr = NSString(format: "%.5f", coordinate.latitude)
                        let lonStr = NSString(format: "%.5f", coordinate.longitude)
                        self.descriptionView.coordinateLabel.text = "lat = \(latStr)    lon = \(lonStr)"
                        self.showDescriptionView()
                        
//                        print("City = \(locality)")
//                        self.descriptionView.hidden = false
//                        self.citylabel.text = locality
                    }else{
                        self.hideDescriptionView()
                    }
                }
            } else {
                print("Problems with the data received from geocoder.")
            }
        })
        
    }
}

extension MapViewController: MKMapViewDelegate{

//    // 1
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        if let annotation = annotation as? Artwork {
//            let identifier = "pin"
//            var view: MKPinAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
//                as? MKPinAnnotationView { // 2
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            } else {
//                // 3
//                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton(type: .ContactAdd) as UIView
//            }
//            return view
//        }
//        return nil
//    }
////
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        
//        let annotationTap = UITapGestureRecognizer(target: self, action: Selector("tapRecognized"))
//        annotationTap.numberOfTapsRequired = 1
//        view.addGestureRecognizer(annotationTap)
//        
//        let selectedAnnotations = mapView.selectedAnnotations
//        
//        for annotationView in selectedAnnotations{
//            mapView.deselectAnnotation(annotationView, animated: true)
//        }
//    }
//    
//    func tapRecognized(gesture:UITapGestureRecognizer){
//        
//        let selectedAnnotations = map.selectedAnnotations
//        
//        for annotationView in selectedAnnotations{
//            map.deselectAnnotation(annotationView, animated: true)
//        }
//    }
//    
//    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
//        
//        view.hidden = true
//    }
    
    
}