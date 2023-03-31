//
//  CachedImageManager.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/26/23.
//

import Foundation

final class CahcedImageManger: ObservableObject {
    @Published private(set) var currentState: CurrentState?
    
    private let imageRetriver = ImageRetriver()
    
    @MainActor // makes changes on main thread
    func load(_ imageURL: String, cache: ImageCache = .shared) async {
        
        self.currentState = .loading
        
        if let imageData = cache.object(forkey: imageURL as NSString) {
            self.currentState = .success(data: imageData)
            return
        }
        
        do {
            let data = try await imageRetriver.fetch(imageURL)
            self.currentState = .success(data: data)
            cache.set(object: data as NSData, forkey: imageURL as NSString)
            
        } catch {
            self.currentState = .failed(error: error)
        }
    }
}

extension CahcedImageManger {
    enum CurrentState {
        case loading
        case failed(error: Error)
        case success(data: Data)
    }
}
