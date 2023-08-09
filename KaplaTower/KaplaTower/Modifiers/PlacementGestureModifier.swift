//
//  PlacementGesturesModifier.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 08/08/2023.
//

import SwiftUI
import RealityKit

extension View {
    /// Listens for gestures and places an item based on those inputs.
    func placementGesture() -> some View {
        self.modifier(
            PlacementGestureModifier()
        )
    }
}

/// A modifier that adds gestures and positioning to a view.
private struct PlacementGestureModifier: ViewModifier {

    @State private var position: Point3D = .zero
    @State private var startPosition: Point3D? = nil

    func body(content: Content) -> some View {
        content
            .offset(x: position.x, y: position.y)
            .offset(z: position.z)

            // Enable people to move the model anywhere in their space.
            .simultaneousGesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                .onChanged { value in
                    if let startPosition {
                        let delta = value.location3D - value.startLocation3D
                        position = startPosition + delta
                    } else {
                        startPosition = position
                    }
                }
                .onEnded { _ in
                    startPosition = nil
                }
            )
    }
}
