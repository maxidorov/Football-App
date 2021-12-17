//
//  PubMapView.swift
//  FootballApp
//
//  Created by Андрей on 17.12.2021.
//

import Foundation
import UIKit
import MapKit

class PubMapView : UIView {
    
    private enum Constants {
        // UI Constants
        static let standardIndent: CGFloat = 20
        
        // Search Constants
        static let searchQuery = "Пабы"
        static let mapAnnotationIdentifier = "pub"
    }

    var pubsAround : [MKMapItem] = []
    private var mapView = MKMapView()
    private var locationManager = CLLocationManager()
    private var searchCompleted: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(mapView)
        
        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("MatchHeaderView init(coder: )")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: frame.width,
                height: frame.height
            )
        )
    }
        
}

extension PubMapView : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
        case .notDetermined:
            debugPrint("NotDetermined")
        case .restricted:
            debugPrint("Restricted")
        case .denied:
            debugPrint("Denied")
        case .authorizedAlways:
            debugPrint("AuthorizedAlways")
        case .authorizedWhenInUse:
            debugPrint("AuthorizedWhenInUse")
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }

    func locationManager(_ manager: CLLocationManager,
                        didUpdateLocations locations: [CLLocation]) {

        print("Location changed \(locations.first!.coordinate)")
        
        guard let location = locations.first else {
            return
        }
        
        mapView.centerToLocation(location)
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
        mapView.showsCompass = false

        
        if(!self.searchCompleted) {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = Constants.searchQuery
            request.region = coordinateRegion
            
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                self.pubsAround = response.mapItems
                debugPrint(self.pubsAround)
                
                for pub in response.mapItems {
                    let pubAnnotation = Pub(
                        title: pub.name,
                        locationName: pub.placemark.title,
                        coordinate: CLLocationCoordinate2D(
                            latitude: pub.placemark.coordinate.latitude,
                            longitude: pub.placemark.coordinate.longitude
                        )
                    )
                    debugPrint(pubAnnotation)
                    self.mapView.addAnnotation(pubAnnotation)
                }
                
                self.searchCompleted = true
            }
        }
        // MARK:- Uncomment two following lines for map not no update while moving
        // locationManager?.stopUpdatingLocation()
        // locationManager = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }
}

extension PubMapView : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Pub else {
            return nil
        }
        
        let identifier = Constants.mapAnnotationIdentifier
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: identifier)
            
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

class Pub : NSObject, MKAnnotation {
  private static let emptySubtitle = ""
    
  let title: String?
  let locationName: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    locationName: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return Pub.emptySubtitle
  }
}
