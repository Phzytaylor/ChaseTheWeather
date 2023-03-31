//
//  SendableUserDefaults.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/30/23.
//

import Foundation
/// This was created because you cannot dirrectly change userDefaults so I made a wrapper. This allows me to test my viewModel
@MainActor
class SendableUserDefaults: Sendable {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    static func createAsync(userDefaults: UserDefaults = .standard) async -> SendableUserDefaults {
        return await SendableUserDefaults(userDefaults: userDefaults)
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
    }
    
    func string(forKey defaultName: String) -> String? {
        return userDefaults.string(forKey: defaultName)
    }
    
    func stringArray(forKey defaultName: String) -> [String]? {
        return userDefaults.stringArray(forKey: defaultName)
    }
}
