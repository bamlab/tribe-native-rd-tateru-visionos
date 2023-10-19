//
//  TateruView.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 08/08/2023.
//

import SwiftUI
import RealityKit

struct TateruView: View {
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow

    @State private var subs: [EventSubscription] = []
    @State private var blocks: [Entity] = []
    @State private var blocksMoving: [Bool] = []
    @State private var isEndGame: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @StateObject var model: TateruViewModel

    var body: some View {
        RealityView { content in
            // Table
            let table = model.setupTable()
            content.add(table)

            // Plate
            content.add(model.setupPlate())

            // Deposite Area
            let depositArea = model.setupDepositArea()
            content.add(depositArea)

            // Blocks
            for block in blocks {
                content.add(block)
                print("Block: \(block) || \(block.position)")
            }

            // Events
            let eventTable = content.subscribe(to: CollisionEvents.Began.self, on: table) { event in
                isEndGame = true
            }
            let eventDepositArea = content.subscribe(to: CollisionEvents.Began.self, on: depositArea) { event in
                event.entityB.removeFromParent()
                model.score += 1
                if (model.score == 17*2) {
                    isEndGame = true
                }
            }
            Task {
                subs.append(eventTable)
                subs.append(eventDepositArea)
            }
        }
        .modifier(PlacementGestureModifier(blocks: $blocks, blocksMoving: $blocksMoving))
        .onAppear {
            dismissWindow(id: "MainMenu")
            dismissWindow(id: "EndMenu")
            dismissWindow(id: "Scoreboard")
            openWindow(id: "ScoreInGame")
            blocks.append(contentsOf: createTower(model))
            blocksMoving.append(contentsOf: Array(repeating: false, count: 18*3))
        }
        .onDisappear {
            dismissWindow(id: "ScoreInGame")
        }
        .onChange(of: isEndGame, initial: false) {
            openWindow(id: "EndMenu")
        }
        .onChange(of: blocksMoving, initial: false) { value, newValue in
            let indices = zip(value, newValue).enumerated().filter{$1.0 != $1.1}.map{$0.offset}
            if let index = indices.first {
                model.updateBlockGravity(block: blocks[index], isBlockMoving: blocksMoving[index])
            }
        }
        .onReceive(timer) { _ in
            model.time += 1
        }
    }
}

@MainActor func createTower(_ model: TateruViewModel) -> [ModelEntity] {
    var tower: [ModelEntity] = []
    let x: Float = 0
    let y: Float = 1.02
    let z: Float = -2
    for i in 1...18 {
        let yi = y+(Float(i)*0.015)
        let colorL: UIColor = getBlocColor(red: Int.random(in: 200...230))
        let colorM: UIColor = getBlocColor(red: Int.random(in: 200...230))
        let colorR: UIColor = getBlocColor(red: Int.random(in: 200...230))
        if (i%2 == 0) {
            tower.append(model.setupBlock(position: SIMD3(x: x, y: yi, z: z+0.025), color: colorL, isOddFloor: false))
            tower.append(model.setupBlock(position: SIMD3(x: x, y: yi, z: z), color: colorM, isOddFloor: false))
            tower.append(model.setupBlock(position: SIMD3(x: x, y: yi, z: z-0.025), color: colorR, isOddFloor: false))
        } else {
            tower.append(model.setupBlock(position: SIMD3(x: x-0.025, y: yi, z: z), color: colorR, isOddFloor: true))
            tower.append(model.setupBlock(position: SIMD3(x: x, y: yi, z: z), color: colorM, isOddFloor: true))
            tower.append(model.setupBlock(position: SIMD3(x: x+0.025, y: yi, z: z), color: colorL, isOddFloor: true))
        }
    }
    return tower
}

private func getBlocColor(red: Int) -> UIColor {
    var green: Int = 0
    var blue: Int = 0
    switch red {
    case 200..<210:
        green = red - Int.random(in: 30..<35)
        blue = green - Int.random(in: 40..<46)
    case 210..<217:
        green = red - Int.random(in: 25..<30)
        blue = green - Int.random(in: 34..<40)
    case 217..<224:
        green = red - Int.random(in: 20..<25)
        blue = green - Int.random(in: 28..<34)
    default:
        green = red - Int.random(in: 15..<20)
        blue = green - Int.random(in: 22..<28)
    }
    return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
}
