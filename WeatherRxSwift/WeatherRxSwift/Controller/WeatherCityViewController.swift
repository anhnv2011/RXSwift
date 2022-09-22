//
//  WeatherCityViewController.swift
//  WeatherRxSwift
//
//  Created by MAC on 8/17/22.
//

import UIKit
import RxCocoa
import RxSwift
import CoreLocation
import MapKit

class WeatherCityViewController: UIViewController {
    @IBOutlet private var searchCityName: UITextField!
    @IBOutlet private var cityNameLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!
    
    @IBOutlet weak var containerView: UIStackView!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var mapButton: UIButton!
    
    
//    let bag = DisposeBag()
//    let locationManager = CLLocationManager()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        locationButton.rx.tap.asDriver()
//            .drive(onNext: { _ in
//                self.locationManager.requestWhenInUseAuthorization()
//                self.locationManager.startUpdatingLocation()
//            })
//            .disposed(by: bag)
//
//        locationManager.rx.didUpdateLocation
//            .subscribe(onNext: { location in
//                print(location)
//
//            })
//            .disposed(by: bag)
//
//
//        // MARK: - LOCATION
//        // Step 1 : Current Location
//        let currentLocation = locationManager.rx.didUpdateLocation
//            .map { locations in locations[0] }
//            .filter { location in
//                return location.horizontalAccuracy < kCLLocationAccuracyHundredMeters
//            }
//
//        // Step 2 : Location Input
//        let locationInput = locationButton.rx.tap.asObservable()
//            .do(onNext: {
//                self.locationManager.requestWhenInUseAuthorization()
//                self.locationManager.startUpdatingLocation()
//
//            })
//
//        let locationObs = locationInput
//                    .flatMap { return currentLocation.take(1) }
//
//
//        let locationSearch = locationObs.flatMap { location  in
//                 return WeatherAPI.shared.currentWeather(at: location.coordinate)
//                    .catchAndReturn(.dummy)
//        }
//
//
//        //c1:
//
//        //        let search = searchCityName.rx.text.orEmpty
//        //            .filter({!$0.isEmpty})
//        //            .flatMap{ text in
//        //                return WeatherAPI.shared.currentWeather(city: text).catchAndReturn(Weather.empty)
//        //            }
//        //            .share(replay: 1, scope: .whileConnected)
//        //
//        //        search.map({$0.cityName})
//        //            .bind(to: self.rx.customtitle)
//        //            .disposed(by: bag)
//        //        search.map { $0.cityName }
//        //            .bind(to: cityNameLabel.rx.text)
//        //            .disposed(by: bag)
//        //        search.map { "\($0.temperature) °C" }
//        //            .bind(to: tempLabel.rx.text)
//        //            .disposed(by: bag)
//        //
//        //        search.map { $0.cityName }
//        //            .bind(to: cityNameLabel.rx.text)
//        //            .disposed(by: bag)
//        //
//        //        search.map { "\($0.humidity) %" }
//        //            .bind(to: humidityLabel.rx.text)
//        //            .disposed(by: bag)
//        //
//        //        search.map { $0.icon }
//        //            .bind(to: iconLabel.rx.text)
//        //            .disposed(by: bag)
//
//        //c2:
//
//        let searchInput = searchCityName.rx.controlEvent(.editingDidEndOnExit)
//            .map({self.searchCityName.text ?? ""})
//            .filter { !$0.isEmpty }
//        let textSearch = searchInput.flatMap { text in
//                    return WeatherAPI.shared.currentWeather(city: text)
//                        .catchAndReturn(.dummy)
//                }
////        let search = searchInput
////            .flatMap { text in
////                return WeatherAPI.shared.currentWeather(city: text).catchAndReturn(Weather.empty)
////            }
////            .asDriver(onErrorJustReturn: Weather.empty)
//        let search = Observable
//            .merge(locationSearch, textSearch)
//            .asDriver(onErrorJustReturn: .dummy)
//
//
//        search.map { "\($0.temperature) °C" }
//            .drive(tempLabel.rx.text)
//            .disposed(by: bag)
//
//        search.map { $0.cityName }
//            .drive(cityNameLabel.rx.text)
//            .disposed(by: bag)
//
//        search.map { "\($0.humidity) %" }
//            .drive(humidityLabel.rx.text)
//            .disposed(by: bag)
//
//        search.map { $0.icon }
//            .drive(iconLabel.rx.text)
//            .disposed(by: bag)
//
//        search.map { $0.cityName }
//            .drive(self.rx.customtitle)
//            .disposed(by: bag)
//
//
//        let loading = Observable.merge(
//            searchInput.map{_ in true },
//            search.map({_ in false}).asObservable()
//        )
//        .startWith(true)
//        .asDriver(onErrorJustReturn: true)
//
//        loading
//            .skip(1)
//            .drive(activityIndicator.rx.isAnimating)
//            .disposed(by: bag)
//        loading
//            .drive(containerView.rx.isHidden)
//            .disposed(by: bag)
//
//        loading
//            .drive(tempLabel.rx.isHidden)
//            .disposed(by: bag)
//
//        loading
//            .drive(iconLabel.rx.isHidden)
//            .disposed(by: bag)
//
//        loading
//            .drive(humidityLabel.rx.isHidden)
//            .disposed(by: bag)
//
//        loading
//            .drive(cityNameLabel.rx.isHidden)
//            .disposed(by: bag)
//
//
//
//
//
//    }
//
//}
//
//extension Reactive where Base: WeatherCityViewController {
//    var customtitle: Binder<String>{
//        return Binder(self.base){(vc, value) in
//            vc.title = value
//        }
//    }
//}

    private let locationManager = CLLocationManager()


    // MARK: - Properties
    let bag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
        // MARK: - LOCATION
        // Step 1 : Current Location
        let currentLocation = locationManager.rx.didUpdateLocation
            .map { locations in locations[0] }
            .filter { location in
                return location.horizontalAccuracy < kCLLocationAccuracyHundredMeters
            }
        
        // Step 2 : Location Input
        let locationInput = locationButton.rx.tap.asObservable()
            .do(onNext: {
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
                
            })
        
        let locationObs = locationInput
                    .flatMap { return currentLocation.take(1) }
        
        // MARK: - TEXTFIELD
        let searchInput = searchCityName.rx.controlEvent(.editingDidEndOnExit)
            .map { self.searchCityName.text ?? "" }
            .filter { !$0.isEmpty }
        
        // MARK: - MAPVIEW
        let mapInput = mapView.rx.regionDidChangeAnimated
            .map { [unowned self] _ in self.mapView.centerCoordinate }

        
        // MARK: - SEARCH
        // search with TextField
        let textSearch = searchInput.flatMap { text in
             return WeatherAPI.shared.currentWeather(city: text)
                .catchAndReturn(.dummy)
         }
        
        // search with Location
        let locationSearch = locationObs.flatMap { location  in
            return WeatherAPI.shared.currentWeather(at: location.coordinate)
                .catchAndReturn(.dummy)
        }
        
        // search with MapView
        let mapSearch = mapInput.flatMap { coordinate in
            return WeatherAPI.shared.currentWeather(at: coordinate)
                .catchAndReturn(.dummy)
        }

        
        // merge inputs search
        let search = Observable
                    .merge(locationSearch, textSearch, mapSearch)
                    .asDriver(onErrorJustReturn: .dummy)
        
        // MARK: - DRIVE
        search.map { "\($0.temperature) °C" }
            .drive(tempLabel.rx.text)
            .disposed(by: bag)
        
        search.map { $0.cityName }
            .drive(cityNameLabel.rx.text)
            .disposed(by: bag)
        
        search.map { "\($0.humidity) %" }
            .drive(humidityLabel.rx.text)
            .disposed(by: bag)
        
        search.map { $0.icon }
            .drive(iconLabel.rx.text)
            .disposed(by: bag)
        
        search.map { $0.cityName }
            .drive(self.rx.title)
            .disposed(by: bag)
        
        search.map { $0.cityName }
            .drive(self.rx.title)
            .disposed(by: bag)
        
        // MARK: LOADING
        let loading = Observable.merge(
                searchInput.map { _ in true },
                locationInput.map { _ in true }, // update with search at Location
                mapInput.map { _ in true }, // update with search at MapView
                search.map { _ in false }.asObservable()
            )
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
        
        loading
            .skip(1)
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)

        loading
            .drive(containerView.rx.isHidden)
            .disposed(by: bag)
        
        loading
            .drive(tempLabel.rx.isHidden)
            .disposed(by: bag)
        
        loading
            .drive(iconLabel.rx.isHidden)
            .disposed(by: bag)
        
        loading
            .drive(humidityLabel.rx.isHidden)
            .disposed(by: bag)
        
        loading
            .drive(cityNameLabel.rx.isHidden)
            .disposed(by: bag)
        
        
        // MARK: Add PIN to MapView
        mapView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        // show/hide mapview
        mapButton.rx.tap
            .subscribe(onNext: {
                self.mapView.isHidden.toggle()
            })
            .disposed(by: bag)
        
        // Add Pin
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 16.07284665186346, longitude: 108.22301730328086)
        pin.title = "Pin nè"
        
        mapView.addAnnotation(pin)
        
        // listener CLLocationManager
        locationManager.rx.didUpdateLocation
            .subscribe(onNext: { locations in
                for location in locations {
                    let pin = MKPointAnnotation()
                    pin.coordinate = location.coordinate
                    pin.title = "Pin nè"
                    
                    self.mapView.addAnnotation(pin)
                }
            })
            .disposed(by: bag)
        
        // add PIN with API data
        search.map { weather -> MKPointAnnotation in
            let pin = MKPointAnnotation()
            pin.title = weather.cityName
            pin.subtitle = "\(weather.temperature) °C - \(weather.humidity) % - \(weather.icon)"
            pin.coordinate = weather.coordinate
            
            return pin
        }
        .drive(mapView.rx.pin)
        .disposed(by: bag)
        
    }
    
    // MARK: - private methods
    private func configUI() {
        title = "Weather City"
    }

}


// MARK: - Custom Binder
extension Reactive where Base: WeatherCityViewController {
    var title: Binder<String> {
        return Binder(self.base) { (vc, value) in
            vc.title = value
        }
    }
}

// MARK: - MapView Delegate
extension WeatherCityViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.animatesDrop = true
        pin.pinTintColor = .red
        pin.canShowCallout = true
        return pin
    }
}
