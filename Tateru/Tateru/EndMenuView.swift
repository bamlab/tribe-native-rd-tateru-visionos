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
            Text("Vous avez retiré \(model.score) pièces en \(prettyPrintTime(model.time))")
                .font(Font.system(size: 50, weight: .bold))
                .padding()
            HStack {
                Button {
                    model.score = 0
                    model.time = 0
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
            Task {
                await dismissImmersiveSpace()
            }
            UserDefaults.standard.scores.append(Score(score: model.score, time: model.time, date: Date.now))
        }
    }
}

func prettyPrintTime(_ time: UInt16) -> String {
    if (time == 0) {
        return "0 seconde"
    }
    let hours = time / 10000;
    let minutes = (time % 10000) / 100;
    let seconds = time % 100;
    var str = ""
    if (hours != 0) {
        str += "\(hours) heure"
        str += hours > 1 ? "s " : " "
    }
    if (minutes != 0) {
        str += "\(minutes) minute"
        str += minutes > 1 ? "s " : " "
    }
    if (seconds != 0) {
        str += "\(seconds) seconde"
        str += seconds > 1 ? "s " : " "
    }
    return str
}
