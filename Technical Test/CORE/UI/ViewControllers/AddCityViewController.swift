//
//  AddCityViewController.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 15/7/2022.
//

import UIKit
import CoreLocation
import OpenWeatherAPI
import MapKit

class AddCityViewController: UIViewController {
    @IBOutlet weak var citiesSearchBar: UISearchBar!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    private var locationManager = LocationManager()
    private var foundCondidate: CLLocationCoordinate2D? = nil
    var delegate: RootViewController? = nil
    
    var searchSource: [String]?
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let sC = MKLocalSearchCompleter()
        sC.delegate = self
        return sC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Methods
extension AddCityViewController {
    func setupData(using placemark: CLPlacemark) {
        foundCondidate = CLLocationCoordinate2D(latitude: -1, longitude: -1)
        var output = "Our location is:"
        if let country = placemark.country {
            output = output + "\n\(country)"
            self.countryLabel.text = "Country: " + country
        }
        if let state = placemark.administrativeArea {
            output = output + "\n\(state)"
            self.stateLabel.text = "State: " + state
        }
        if let town = placemark.locality {
            output = output + "\n\(town)"
            self.townLabel.text = "Town: " + town
        }
        if let long = placemark.location?.coordinate.longitude {
            output = output + "\n\(long)"
            foundCondidate?.longitude = long
            self.longitudeLabel.text = "Longitude: " + long.description
        }
        if let lat = placemark.location?.coordinate.latitude {
            output = output + "\n\(lat)"
            foundCondidate?.latitude = lat
            self.latitudeLabel.text = "Latitude: " + lat.description
        }
    }
    
    func setupData(using response: OWResponse) {
        foundCondidate = CLLocationCoordinate2D(latitude: -1, longitude: -1)
        var output = "Our location is:"
        if let country = response.sys?.country {
            output = output + "\n\(country)"
            self.countryLabel.text = "Country: " + country
        }
        if let state = searchSource?.first {
            output = output + "\n\(state)"
            self.stateLabel.text = "State: " + state
        }
        if let town = response.name {
            output = output + "\n\(town)"
            self.townLabel.text = "Town: " + town
        }
        if let long = response.coordinations?.lon {
            output = output + "\n\(long)"
            foundCondidate?.longitude = long
            self.longitudeLabel.text = "Longitude: " + long.description
        }
        if let lat = response.coordinations?.lat {
            output = output + "\n\(lat)"
            foundCondidate?.latitude = lat
            self.latitudeLabel.text = "Latitude: " + lat.description
        }
        
    }
}
//MARK: - IBActions
extension AddCityViewController {
    @IBAction func addCityButtonAction(_ sender: UIButton) {
        guard let lon = foundCondidate?.longitude.description, let lat = foundCondidate?.latitude.description else { return }
        OpenWeatherAPI.shared.getWeather(
            params: ["lon":lon, "lat": lat]) { res in
                guard let cityResult = res else { return }
                UserDefaultsInteractor.shared.insertCityToCache(cityResult)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, let delegate = self.delegate else { return }
                    delegate.setDelegates()
                    self.dismiss(animated: true)
                }
            }
    }
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        if !locationManager.authorizationStatus.atLeastOnce {
            locationManager = LocationManager()
        } else {
            guard let exposedLocation = self.locationManager.exposedLocation else {
                print("*** Error in \(#function): exposedLocation is nil")
                return
            }
            
            self.locationManager.getPlace(for: exposedLocation) { placemark in
                guard let placemark = placemark else { return }
                self.setupData(using: placemark)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension AddCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        OpenWeatherAPI.shared.getWeather(city: searchSource?.first?.description ?? "") { resp in
            guard let response = resp else { return }
            DispatchQueue.main.async { [weak self] in
                self?.setupData(using: response)
            }
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension AddCityViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        //get result, transform it to our needs and fill our dataSource
        self.searchSource = completer.results.map { $0.title }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
