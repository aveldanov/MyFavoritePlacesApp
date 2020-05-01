//
//  MapViewController.swift
//  MyFavoritePlacesApp
//
//  Created by Veldanov, Anton on 4/30/20.
//  Copyright © 2020 Anton Veldanov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
  
  
  
  @IBOutlet weak var mapOutlet: MKMapView!
  
  var manager = CLLocationManager()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // long press gesture recognizer
    
    let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(longpress))
    // 2sec
    uilpgr.minimumPressDuration = 2
    
    mapOutlet.addGestureRecognizer(uilpgr)
    
    
    if activePlace == -1{
      manager.delegate = self
      manager.desiredAccuracy = kCLLocationAccuracyBest
      manager.requestWhenInUseAuthorization()
      manager.startUpdatingLocation()
      
      
    }else{
      // place details to display
      if places.count > activePlace{
        if let name = places[activePlace]["name"]{
          if let lat = places[activePlace]["lat"]{
            if let lon = places[activePlace]["lon"]{
              
              if let latitude = Double(lat){
                if let longitude = Double(lon){
                  let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                  let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                  
                  let region = MKCoordinateRegion(center: coordinate, span: span)
                  
                  mapOutlet.setRegion(region, animated: true)
                  
                  let annotation = MKPointAnnotation()
                  annotation.coordinate = coordinate
                  annotation.title = name
                  mapOutlet.addAnnotation(annotation)
                }
                
                
              }
              
              
            }
          }
        }
        
        
      }
      
    }
  }
  
  
  
}


extension MapViewController{
  
  
  
  @objc func longpress(gestureRecognizer: UIGestureRecognizer){
    if gestureRecognizer.state == UIGestureRecognizer.State.began{
      
      let touchPoint = gestureRecognizer.location(in: self.mapOutlet)
      let newCoordinate = mapOutlet.convert(touchPoint, toCoordinateFrom: mapOutlet)
      
      //       print(newCoordinate)
      // Get location name
      
      let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
      var title = ""
      
      CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
        if error != nil{
          print(error)
        }else{
          if let placemark = placemarks?[0]{
            //Additional street-level information for the placemark.
            //             var subThoroughfare = ""
            //             if placemark.subThoroughfare != nil{
            //               subThoroughfare = placemark.subThoroughfare!
            //               
            //               // append to the address line
            //               title += subThoroughfare + " "
            //             }
            //             
            //             //The street address associated with the placemark.
            //             var thoroughfare = ""
            //             if placemark.thoroughfare != nil{
            //               thoroughfare = placemark.thoroughfare!
            //               title += thoroughfare + "\n"
            //             }
            
            //Additional city-level information for the placemark.
            var subLocality = ""
            if placemark.subLocality != nil{
              subLocality = placemark.subLocality!
              title += subLocality + ", "
            }
            
            
            
            
            //            The state or province associated with the placemark.
            var administrativeArea = ""
            if placemark.administrativeArea != nil{
              administrativeArea = placemark.administrativeArea!
              title += administrativeArea + " - "
              
            }
            
            
            //            The name of the country associated with the placemark.
            var country = ""
            if placemark.country != nil{
              country = placemark.country!
              title += country

            }
            
            print(title)
          }
          
          
        }
        print("Title:",title)
        
        // no address found
        if title == ""{
          print("NOT TITLE FOUND")
          title = "Added \(NSDate())"
          print("Title:",title)
        }
        
        print("SUPERTitle:",title)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = title
        self.mapOutlet.addAnnotation(annotation)
        
        places.append(["name":title, "lat":String(newCoordinate.latitude),"lon":String(newCoordinate.longitude)])
        defaults.set(places, forKey: "places")


        print(places)
        
        
      }
      
      
    }
    
  }
  
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: location, span: span)
    
    mapOutlet.setRegion(region, animated: true)
    
  }
  
  
  
  
}
