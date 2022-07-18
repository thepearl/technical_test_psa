//
//  UserDefaults.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 17/7/2022.
//

import Foundation
import OpenWeatherAPI

public class UserDefaultsInteractor {
    private init() { }
    public static let shared = UserDefaultsInteractor()
    private var userDefaults = UserDefaults.standard
    public func getCitiesFromCache() -> [OWResponse] {
        guard let data = userDefaults.data(forKey: "cachedCities") else {
            return []
        }
        
        guard let value = try? JSONDecoder().decode([OWResponse].self, from: data) else {
            print("Cannot decode any cached video")
            return []
        }
        
        return value
    }
    
    public func insertCityToCache(_ city: OWResponse) {
        var alreadyCachedCities = getCitiesFromCache()
        alreadyCachedCities.append(city)
        
        guard let data = try? JSONEncoder().encode(alreadyCachedCities) else {
            print("Cannot encode data")
            return
        }
        
        userDefaults.set(data, forKey: "cachedCities")
    }
}
