//
//  TateruApp.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 08/08/2023.
//

import SwiftUI

@main
struct TateruApp: App {
    @StateObject var model = TateruViewModel()
    var body: some Scene {
        WindowGroup(id: "MainMenu") {
            MainMenuView()
        }.windowStyle(.volumetric)

        WindowGroup(id: "Scoreboard") {
            ScoreboardView(model: model)
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "Tateru") {
            TateruView(model: model)
        }

        WindowGroup(id: "EndMenu") {
            EndMenuView(model: model)
        }.windowStyle(.volumetric)
        
        WindowGroup(id: "ScoreInGame") {
            ScoreInGameView(model: model)
        }.windowStyle(.volumetric)
    }
}
