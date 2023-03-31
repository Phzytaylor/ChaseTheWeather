//
//  SearchHandler.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/23/23.
//

import Foundation

class SearchHandler: ObservableObject {
    private var currentWorkItem: DispatchWorkItem?
    
    func debounceSearch(delay: TimeInterval, query: String, performSearchAction: @escaping (String) -> Void) {
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem { performSearchAction(query) }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}
