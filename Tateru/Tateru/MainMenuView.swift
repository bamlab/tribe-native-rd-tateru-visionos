//
//  MainMenuView.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 08/08/2023.
//

import SwiftUI

struct MainMenuView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.openWindow) var openWindow
    var body: some View {
        VStack {
            Text("TA")
                .font(Font.system(size: 100, weight: .bold))
                .foregroundColor(Color(red: 253 / 255, green: 101 / 255, blue: 101 / 255))
                + Text("TE")
                .font(Font.system(size: 100, weight: .bold))
                .foregroundColor(Color(red: 83 / 255, green: 155 / 255, blue: 255 / 255))
                + Text("RU")
                .font(Font.system(size: 100, weight: .bold))
                .foregroundColor(Color(red: 254 / 255, green: 228 / 255, blue: 117 / 255))
            HStack {
                Button {
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
                    openWindow(id: "Scoreboard")
                } label: {
                    Text("Meilleur scores")
                        .font(.system(size: 50))
                        .bold()
                        .padding()
                }
                .padding()
                .disabled(UserDefaults.standard.scores.isEmpty)
            }.padding()
        }
        .padding()
        .background(Color.clear)
    }
}
