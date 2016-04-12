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
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var annotaton: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        centerMapOnLocation(initialLocation)
        let longPressGR = UITapGestureRecognizer(target: self, action: #selector(MapViewController.annotation(_:)))
        map.addGestureRecognizer(longPressGR)
    }
    
    func annotation(gesture: UIGestureRecognizer){
        print("Hello map")
        if let annotaton = self.annotaton{
            map.removeAnnotation(annotaton)
        }
        let touchPoint = gesture.locationInView(self.map)
        let coordinate:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        self.annotaton = MKPointAnnotation()
        annotaton?.coordinate = coordinate
        map.addAnnotation(annotaton!)
        print(coordinate)
    }
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate{

    // 1
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
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
        return nil
    }
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