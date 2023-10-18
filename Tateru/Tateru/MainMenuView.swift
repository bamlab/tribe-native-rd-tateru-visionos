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
    @Environment(\.dismissWindow) var dismissWindow

    var body: some View {
        VStack {
            Text("TA")
                .font(Font.system(size: 100, weight: .bold))
                .foregroundColor(.redBAM)
                + Text("TE")
                .font(Font.system(size: 100, weight: .bold))
                .foregroundColor(.blueBAM)
                + Text("RU")
                .font(Font.system(size: 100, weight: .bold))
                .foregroundColor(.yellowBAM)
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
        .onAppear {
            dismissWindow(id: "Scoreboard")
        }
    }
}
