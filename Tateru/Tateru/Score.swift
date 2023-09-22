//
//  Score.swift
//  Tateru
//
//  Created by Guillaume Saladin on 21/09/2023.
//

import Foundation

struct Score: Codable, Identifiable {
    var id = UUID()
    let score: Int
    let time: UInt16
    let date: Date
}
