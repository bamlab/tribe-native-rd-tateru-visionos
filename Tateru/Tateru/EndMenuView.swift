//
//  EndMenuView.swift
//  Tateru
//
//  Created by Guillaume Saladin on 18/09/2023.
//

import SwiftUI

struct EndMenuView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    @StateObject var model: TateruViewModel

    var body: some View {
        let isGameOver = model.score != 1
        let text = isGameOver ? "GAME OVER" : "JOB DONE"
        let color = isGameOver ? Color(red: 253 / 255, green: 101 / 255, blue: 101 / 255) : Color(red: 101 / 255, green: 253 / 255, blue: 101 / 255)
        VStack {
            Text(text)
                .font(Font.system(size: 100, weight: .bold))
                .foregroundColor(color)
            HStack {
                Button {
                    model.score = 0
                    Task {
                        await openImmersiveSpace(id: "Tateru")
                    }
                } label: {
                    Text("Nouvelle partie")
                        .font(.system(size: 50))
                        .bold()
                        .padding()
                }.padding()
                Button {
                    print("Meilleur scores")
                } label: {
                    Text("Meilleur scores")
                        .font(.system(size: 50))
                        .bold()
                        .padding()
                }.padding()
            }.padding()
        }
        .padding()
        .background(Color.clear)
        .onAppear {
            Task {
                await dismissImmersiveSpace()
            }
        }
    }
}
