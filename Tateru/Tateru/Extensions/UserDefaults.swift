//
//  UserDefaults.swift
//  Tateru
//
//  Created by Guillaume Saladin on 21/09/2023.
//

import Foundation

extension UserDefaults {
    var scores: [Score] {
        get {
            if let scores = value(forKey: "Scores") as? Data {
                let decoder = JSONDecoder()
                if let scoresDecoded = try? decoder.decode(Array.self, from: scores) as [Score] {
                    return scoresDecoded
                }
            }
            return []
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                set(encoded, forKey: "Scores")
            }
        }
    }
}
