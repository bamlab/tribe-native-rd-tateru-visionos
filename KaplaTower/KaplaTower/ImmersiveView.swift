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
                let table = model.setupTable()
                content.add(table)
                let event = content.subscribe(to: CollisionEvents.Began.self, on: table) { ce in
                    isGameOver = true
                }
                Task {
                    subs.append(event)
                }
            }
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
            
            RealityView { content in
                content.add(model.setupPlate())
            }
            
            ForEach(Array(kaplas.enumerated()), id: \.offset) { index, element in
                RealityView { content in
                    content.add(element)
                }
                .modifier(PlacementGestureModifier(kaplasMoving: $kaplasMoving, index: index))
                .modifier(RotateGestureModifier(kaplasMoving: $kaplasMoving, index: index))
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
    let x: Float = 0.5
    let y: Float = 1.46
    let z: Float = -2
    for i in 1...18 {
        let yi = y+(Float(i)*0.015)
        if (i%2 == 0) {
            tower.append(model.setupKapla(position: SIMD3(x: x, y: yi+0.0098, z: z+0.025), isOddFloor: false))
            tower.append(model.setupKapla(position: SIMD3(x: x, y: yi+0.019, z: z), isOddFloor: false))
            tower.append(model.setupKapla(position: SIMD3(x: x, y: yi+0.029, z: z-0.025), isOddFloor: false))
        } else {
            tower.append(model.setupKapla(position: SIMD3(x: x-0.025, y: yi-0.0195, z: z), isOddFloor: true))
            tower.append(model.setupKapla(position: SIMD3(x: x, y: yi-0.0098, z: z), isOddFloor: true))
            tower.append(model.setupKapla(position: SIMD3(x: x+0.025, y: yi, z: z), isOddFloor: true))
        }
    }
    return tower
}
