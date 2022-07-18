//
//  PreviewDetails .swift
//  Technical Test
//
//  Created by Ghazi Tozri on 18/7/2022.
//

import Foundation

protocol PreviewDetails {
    var windSpeed: Double { get }
    var temp: Double { get }
    var minTemp: Double { get }
    var maxTemp: Double { get }
    var pressureDegree: Double { get }
    var humidityDegree: Double { get }
}
