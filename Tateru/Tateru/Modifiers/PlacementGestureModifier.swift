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

    @State private var position: Point3D? = nil
    @Binding var blocks: [Entity]
    @Binding var blocksMoving: [Bool]

    func body(content: Content) -> some View {
        content
            // Enable people to move the model anywhere in their space.
            .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .targetedToAnyEntity()
                .onChanged { value in
                    if let index = blocks.firstIndex(of: value.entity) {
                        blocksMoving[index] = true
                    }
                    if let position {
                        if let block = blocks.first(where: { elm in
                            elm == value.entity
                        }) {
                            print("Block : \(block.position)")
                        }
                        print("Start Position : \(value.entity.position)")
                        let delta = value.location3D - value.startLocation3D
                        print("Delta : \(delta)")
                        let newPosition = position + delta
                        print("New Position : \(newPosition)")
                        let newPositionEntity = value.convert(newPosition, from: .global, to: .scene)
                        print("New Position Entity : \(newPositionEntity)")
                        value.entity.setPosition(newPositionEntity, relativeTo: nil)
                        print("End Position : \(value.entity.position)")
                    } else {
                        position = Point3D(value.entity.position)
                    }
                }
                .onEnded { value in
                    if let index = blocks.firstIndex(of: value.entity) {
                        blocksMoving[index] = false
                    }
                    position = nil
                }
            )
    }
}