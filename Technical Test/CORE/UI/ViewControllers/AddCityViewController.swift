//
//  AddCityViewController.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 15/7/2022.
//

import UIKit
import CoreLocation
import OpenWeatherAPI

class AddCityViewController: UIViewController {
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    private var locationManager = LocationManager()
    private var foundCondidate: CLLocationCoordinate2D? = nil
    
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
        print(output)
    }
}
//MARK: - IBActions
extension AddCityViewController {
    @IBAction func addCityButtonAction(_ sender: UIButton) {
        OpenWeatherAPI.shared.getWeatherForPlace(params: ["lon":"10.801817114273911", "lat": "35.76654052734375"]) { res in
            print(res)
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
