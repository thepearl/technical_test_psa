//
//  Extension.Double.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 18/7/2022.
//

import Foundation
extension Double {
    func getFahrenheit() -> Double {
        return ((self - 273.15) * 1.8) + 32
    }
    
    func getCelsius() -> Double {
        return self - 273.15
    }
}
