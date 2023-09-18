//
//  TateruApp.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 08/08/2023.
//

import SwiftUI

@main
struct TateruApp: App {
    var body: some Scene {
        WindowGroup(id: "MainMenu") {
            MainMenuView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "Tateru") {
            TateruView()
        }

        WindowGroup(id: "EndMenu") {
            EndMenuView()
        }.windowStyle(.volumetric)
    }
}
