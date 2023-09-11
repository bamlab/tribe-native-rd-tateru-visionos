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
                kaplas.append(contentsOf: [
                    model.setupKapla(position: SIMD3(x: 0.475, y: 1.3, z: -2), isOddFloor: true),
                    model.setupKapla(position: SIMD3(x: 0.5, y: 1.4, z: -2), isOddFloor: true),
                    model.setupKapla(position: SIMD3(x: 0.525, y: 1.5, z: -2), isOddFloor: true)
                ])
                kaplasMoving.append(contentsOf: [false, false, false])
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
