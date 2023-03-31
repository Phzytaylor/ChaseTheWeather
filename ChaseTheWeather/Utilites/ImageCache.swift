//
//  ImageCache.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/26/23.
//

import Foundation

class ImageCache {
    typealias CacheType = NSCache<NSString, NSData>
    
    // want this to be a singleton because we only ever want one instance.
    static let shared = ImageCache()
    
    private init () {}
    
    private lazy var cahce: CacheType = {
       let cache = CacheType()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
        
        return cache
    }()
    
    func object(forkey key: NSString) -> Data? {
        cahce.object(forKey: key) as? Data
    }
    
    func set(object: NSData, forkey key: NSString) {
        cahce.setObject(object, forKey: key)
    }
}
