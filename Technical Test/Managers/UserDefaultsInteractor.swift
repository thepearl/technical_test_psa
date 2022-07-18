//
//  UserDefaults.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 17/7/2022.
//

import Foundation
public func getVideosFromCache() -> [String: Video] {
    guard let data = userDefaults.data(forKey: "cachedVideos") else {
        return [:]
    }
    
    guard let value = try? JSONDecoder().decode([String: Video].self, from: data) else {
        print("Cannot decode any cached video")
        return [:]
    }
    
    return value
}

public func setVideosToCache(_ key: String, value: Video) {
    var alreadyCachedVideos = getVideosFromCache()
    alreadyCachedVideos[key] = value
    
    guard let data = try? JSONEncoder().encode(alreadyCachedVideos) else {
        print("Cannot encode data")
        return
    }
    
    userDefaults.set(data, forKey: "cachedVideos")
}

public func deleteObjectFromCache(_ key: String) {
    var alreadyCachedVideos = getVideosFromCache()
    alreadyCachedVideos.removeValue(forKey: key)
    
    guard let data = try? JSONEncoder().encode(alreadyCachedVideos) else {
        print("Cannot encode data")
        return
    }

    userDefaults.set(data, forKey: "cachedVideos")
}
