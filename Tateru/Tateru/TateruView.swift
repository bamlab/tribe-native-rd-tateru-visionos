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
    @StateObject var model = TateruViewModel()
    @State var blocks: [Entity] = []
    @State var blocksMoving: [Bool] = []
    @State var isGameOver: Bool = false

    var body: some View {
        RealityView { content in
            // Table
            let table = model.setupTable()
            content.add(table)
            let event = content.subscribe(to: CollisionEvents.Began.self, on: table) { ce in
                isGameOver = true
            }
            Task {
                subs.append(event)
            }

            // Plate
            content.add(model.setupPlate())
            content.add(model.setupDepositArea())

            // Blocks
            for block in blocks {
                content.add(block)
                print("Block: \(block) || \(block.position)")
            }
        }
        .modifier(PlacementGestureModifier(blocks: $blocks, blocksMoving: $blocksMoving))
        .onAppear {
            dismissWindow(id: "MainMenu")
            dismissWindow(id: "EndMenu")
            blocks.append(contentsOf: createTower(model))
            blocksMoving.append(contentsOf: Array(repeating: false, count: 18*3))
        }
        .onChange(of: isGameOver, initial: false) {
            openWindow(id: "EndMenu")
        }
        .onChange(of: blocksMoving, initial: false) { value, newValue in
            let indices = zip(value, newValue).enumerated().filter{$1.0 != $1.1}.map{$0.offset}
            if let index = indices.first {
                model.updateBlockGravity(block: blocks[index], isBlockMoving: blocksMoving[index])
            }
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
        if (i%2 == 0) {
            tower.append(model.setupBlock(position: SIMD3(x: x, y: yi, z: z+0.025), isOddFloor: false))
            tower.append(model.setupBlock(position: SIMD3(x: x, y: yi, z: z), isOddFloor: false))
            tower.append(model.setupBlock(position: SIMD3(x: x, y: yi, z: z-0.025), isOddFloor: false))
        } else {
            tower.append(model.setupBlock(position: SIMD3(x: x-0.025, y: yi, z: z), isOddFloor: true))
            tower.append(model.setupBlock(position: SIMD3(x: x, y: yi, z: z), isOddFloor: true))
            tower.append(model.setupBlock(position: SIMD3(x: x+0.025, y: yi, z: z), isOddFloor: true))
        }
    }
    return tower
}
