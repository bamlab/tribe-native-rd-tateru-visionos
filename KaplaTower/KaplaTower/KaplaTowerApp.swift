//
//  KaplaTowerApp.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 08/08/2023.
//

import SwiftUI

@main
struct KaplaTowerApp: App {
    var body: some Scene {
        WindowGroup(id: "Content") {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
