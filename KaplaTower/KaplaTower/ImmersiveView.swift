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
    @StateObject var model = ImmersiveViewModel()
    @State var kaplas: [Entity] = []
    @State var kaplasMoving: [Bool] = []

    var body: some View {
        RealityView { content in
            content.add(model.setupTable())
        }
        .onAppear {
            dismissWindow(id: "Content")
            kaplas.append(contentsOf: [
                model.setupKapla(position: SIMD3(x: 0.45, y: 2, z: -2), isOddFloor: true),
                model.setupKapla(position: SIMD3(x: 0.5, y: 2, z: -2), isOddFloor: true),
                model.setupKapla(position: SIMD3(x: 0.55, y: 2, z: -2), isOddFloor: true)
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
    }
}
