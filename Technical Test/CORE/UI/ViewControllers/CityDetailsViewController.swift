//
//  CityDetailsViewController.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 18/7/2022.
//

import UIKit

class CityDetailsViewController: UIViewController {
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var details: PreviewDetails? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetails()
    }
    
    func setupDetails() {
        guard let details = details else {
            return
        }

        windSpeedLabel.text = "Wind Speed:\t\(details.windSpeed)"
        tempLabel.text = "Temperature degree:\t\(details.temp)°"
        minTempLabel.text = "Min Temperature degree:\t\(details.minTemp)°"
        maxTempLabel.text = "Max Temperature degree:\t\(details.maxTemp)°"
        pressureLabel.text = "Pressure:\t\(details.pressureDegree)"
        humidityLabel.text = "Humidity degree:\t\(details.humidityDegree)"
    }
}
