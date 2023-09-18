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
    var body: some View {
        VStack {
            Text("GAME OVER")
                .font(Font.system(size: 100, weight: .bold))
                .foregroundColor(Color(red: 253 / 255, green: 101 / 255, blue: 101 / 255))
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
