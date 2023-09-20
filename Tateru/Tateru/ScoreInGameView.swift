//
//  ScoreInGameView.swift
//  Tateru
//
//  Created by Guillaume Saladin on 20/09/2023.
//

import SwiftUI

struct ScoreInGameView: View {
    @StateObject var model: TateruViewModel

    var body: some View {
        VStack {
            Text("Pièces retirées : \(model.score)")
                .font(Font.system(size: 50, weight: .bold))
                .padding()
            Text("Temps écoulés : \(model.time)")
                .font(Font.system(size: 50, weight: .bold))
                .padding()
        }
        .padding()
        .background(Color.clear)
    }
}
