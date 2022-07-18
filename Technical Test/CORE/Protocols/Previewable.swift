//
//  Previewable.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 18/7/2022.
//

import Foundation


protocol Previewable {
    var weatherDescription: String { get }
    var weatherDegree: Double { get }
    var feelsLikeDegree: Double { get }
    var weatherIconIcon: String { get }
    var place: String { get }
}
