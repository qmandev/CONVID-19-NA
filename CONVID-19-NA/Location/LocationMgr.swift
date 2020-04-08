//
//  LocationMgr.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 4/7/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//
import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    private let geocoder = CLGeocoder()
    
    @Published var status: CLAuthorizationStatus? {
        willSet { objectWillChange.send()}
    }
    
    @Published var location: CLLocation? {
        willSet { objectWillChange.send()}
    }
    
    @Published var placemark: CLPlacemark? {
        willSet { objectWillChange.send()}
    }
    
    @Published var currentStateCode: String? {
        willSet { objectWillChange.send()}
    }
    
    @Published var currentCounty: String? {
        willSet { objectWillChange.send()}
    }
    
    func geocode() {
        guard let location = self.location else { return }
        
        geocoder.reverseGeocodeLocation(location) { (places, error) in
            if (error == nil) {
                self.placemark = places?[0]
                self.currentStateCode = self.placemark?.administrativeArea ?? "State Not Available"
                self.currentCounty = self.placemark?.subAdministrativeArea ?? "County Not Available"
            } else {
                self.placemark = nil
            }
        }
    }
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.geocode()
    }
    
}

extension CLLocation {

    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}
