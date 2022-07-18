//
//  Extension.OWResponse.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 18/7/2022.
//

import Foundation
import OpenWeatherAPI

extension OWResponse: Previewable {
    func getFahrenheit(valueInKelvin: Double?) -> Double {
        if let kelvin = valueInKelvin {
            return ((kelvin - 273.15) * 1.8) + 32
        } else {
            return 0
        }
    }
    
    func getCelsius(valueInKelvin: Double?) -> Double {
        if let kelvin = valueInKelvin {
            return kelvin - 273.15
        } else {
            return 0
        }
    }
    
    
    var weatherDescription: String {
        weather?.first?.weatherDescription ?? "no data"
    }
    
    var weatherDegree: Double {
        getCelsius(valueInKelvin: main?.temp).rounded()
        
    }
    
    var feelsLikeDegree: Double {
        getCelsius(valueInKelvin: main?.feelsLike).rounded()
    }
    
    var weatherIconIcon: String {
        weather?.first?.icon ?? ""
    }
    
    var place: String {
        name ?? ""
    }
}
