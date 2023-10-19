//
//  PlacementGesturesModifier.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 08/08/2023.
//

import SwiftUI
import RealityKit

//extension View {
//    /// Listens for gestures and places an item based on those inputs.
//    func placementGesture() -> some View {
//        self.modifier(
//            PlacementGestureModifier()
//        )
//    }
//}

/// A modifier that adds gestures and positioning to a view.
struct PlacementGestureModifier: ViewModifier {

    @State private var position: Point3D = .zero
    @State private var startPosition: Point3D? = nil
    @Binding var blocksMoving: [Bool]
    var index: Int

    func body(content: Content) -> some View {
        content
            .position(x: position.x, y: position.y)
            .offset(z: position.z)

            // Enable people to move the model anywhere in their space.
            .simultaneousGesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                .onChanged { value in
                    blocksMoving[index] = true
                    if let startPosition {
                        let delta = value.location3D - value.startLocation3D
                        position = startPosition + delta
                    } else {
                        startPosition = position
                    }
                }
                .onEnded { _ in
                    blocksMoving[index] = false
                    startPosition = nil
                }
            )
    }
}
