//
//  Extension.OWResponse.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 18/7/2022.
//

import Foundation
import OpenWeatherAPI

extension OWResponse: Identifiable { }

extension OWResponse: Previewable {
    var weatherDescription: String {
        weather?.first?.weatherDescription ?? "no data"
    }
    
    var weatherDegree: Double {
        main?.temp?.getCelsius().rounded() ?? 0

    }
    
    var feelsLikeDegree: Double {
        main?.feelsLike?.getCelsius().rounded() ?? 0
    }
    
    var weatherIconIcon: String {
        weather?.first?.icon ?? ""
    }
    
    var place: String {
        name ?? ""
    }
}

extension OWResponse: PreviewDetails {
    var windSpeed: Double {
        wind?.speed?.getCelsius().rounded() ?? 0
    }
    
    var temp: Double {
        main?.temp?.getCelsius().rounded() ?? 0
    }
    
    var minTemp: Double {
        main?.tempMin?.getCelsius().rounded() ?? 0
    }
    
    var maxTemp: Double {
        main?.tempMax?.getCelsius().rounded() ?? 0
    }
    
    var pressureDegree: Double {
        Double(main?.pressure ?? 0).rounded()
    }
    
    var humidityDegree: Double {
        Double(main?.humidity ?? 0).rounded()
    }
}
