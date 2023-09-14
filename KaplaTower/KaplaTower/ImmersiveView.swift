//
//  ImmersiveView.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 08/08/2023.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var subs: [EventSubscription] = []
    @StateObject var model = ImmersiveViewModel()
    @State var kaplas: [Entity] = []
    @State var kaplasMoving: [Bool] = []
    @State var isGameOver: Bool = false

    var body: some View {
        if (!isGameOver) {
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

                // Kaplas
                for kapla in kaplas {
                    content.add(kapla)
                    print("Kapla: \(kapla) || \(kapla.position)")
                }
            }
            .modifier(PlacementGestureModifier(kaplas: $kaplas, kaplasMoving: $kaplasMoving))
            .onAppear {
                dismissWindow(id: "Content")
                kaplas.append(contentsOf: createTower(model))
                kaplasMoving.append(contentsOf: Array(repeating: false, count: 18*3))
            }
            .onChange(of: kaplasMoving, initial: false) { value, newValue in
                let indices = zip(value, newValue).enumerated().filter{$1.0 != $1.1}.map{$0.offset}
                if let index = indices.first {
                    model.updateKaplaGravity(kapla: kaplas[index], isKaplaMoving: kaplasMoving[index])
                }
            }
        } else {
            RealityView { content in
                content.add(model.setupGameOver())
            }
        }
    }
}

@MainActor func createTower(_ model: ImmersiveViewModel) -> [ModelEntity] {
    var tower: [ModelEntity] = []
    let x: Float = 0
    let y: Float = 1.02
    let z: Float = -2
    for i in 1...18 {
        let yi = y+(Float(i)*0.015)
        if (i%2 == 0) {
            tower.append(model.setupKapla(position: SIMD3(x: x, y: yi, z: z+0.025), isOddFloor: false))
            tower.append(model.setupKapla(position: SIMD3(x: x, y: yi, z: z), isOddFloor: false))
            tower.append(model.setupKapla(position: SIMD3(x: x, y: yi, z: z-0.025), isOddFloor: false))
        } else {
            tower.append(model.setupKapla(position: SIMD3(x: x-0.025, y: yi, z: z), isOddFloor: true))
            tower.append(model.setupKapla(position: SIMD3(x: x, y: yi, z: z), isOddFloor: true))
            tower.append(model.setupKapla(position: SIMD3(x: x+0.025, y: yi, z: z), isOddFloor: true))
        }
    }
    return tower
}
