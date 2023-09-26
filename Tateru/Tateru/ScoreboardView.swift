//
//  ScoreboardView.swift
//  Tateru
//
//  Created by Guillaume Saladin on 22/09/2023.
//

import SwiftUI

struct ScoreboardView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    @StateObject var model: TateruViewModel

    var body: some View {
        VStack {
        Text("SC")
            .font(Font.system(size: 100, weight: .bold))
            .foregroundColor(.redBAM)
            + Text("OR")
            .font(Font.system(size: 100, weight: .bold))
            .foregroundColor(.blueBAM)
            + Text("ES")
            .font(Font.system(size: 100, weight: .bold))
            .foregroundColor(.yellowBAM)

            let scores = sortScores(UserDefaults.standard.scores)

            HStack {
                Text("Rang").font(Font.system(size: 50, weight: .bold)).frame(width: 200, alignment: .center)
                Text("Blocs enlevés").font(Font.system(size: 50, weight: .bold)).frame(width: 400, alignment: .center)
                Text("Temps").font(Font.system(size: 50, weight: .bold)).frame(width: 200, alignment: .center)
                Text("Date").font(Font.system(size: 50, weight: .bold)).frame(width: 400, alignment: .center)
            }.frame(width: 1200).padding(.top)

            ForEach(0..<scores.count, id: \.self) { i in
                let score = scores[i]
                HStack {
                    Text("\(i+1)").font(Font.system(size: 50, weight: .bold)).frame(width: 200, alignment: .center)
                    Text("\(score.score)").font(Font.system(size: 50, weight: .bold)).frame(width: 400, alignment: .center)
                    Text("\(score.time)").font(Font.system(size: 50, weight: .bold)).frame(width: 200, alignment: .center)
                    Text("\(score.date.formatted(.dateTime.day().month().year()))").font(Font.system(size: 50, weight: .bold)).frame(width: 400, alignment: .center)
                }.frame(width: 1200)
            }

            HStack {
                Button {
                    model.score = 0
                    model.time = 0
                    Task {
                        await openImmersiveSpace(id: "Tateru")
                    }
                } label: {
                    Text("Nouvelle partie")
                        .font(Font.system(size: 50, weight: .bold))
                        .padding()
                }.padding()
                Button {
                    openWindow(id: "MainMenu")
                } label: {
                    Text("Menu principal")
                        .font(Font.system(size: 50, weight: .bold))
                        .padding()
                }
                .padding()
            }.padding().padding(.top)
        }
        .padding()
        .background(Color.clear)
        .onAppear {
            dismissWindow(id: "MainMenu")
            dismissWindow(id: "EndMenu")
        }
    }
}

func sortScores(_ scores: [Score]) -> [Score] {
    let sorted = scores.sorted { (lhs, rhs) -> Bool in
        return (lhs.score, lhs.time, lhs.date) < (rhs.score, rhs.time, rhs.date)
    }
    return sorted
}
