//
//  RotateGestureModifier.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 08/08/2023.
//

import SwiftUI
import RealityKit

//extension View {
//    /// Listens for gestures and places an item based on those inputs.
//    func rotateGesture(isKaplaMoving: inout Bool) -> some View {
//        self.modifier(
//            RotateGestureModifier(isKaplaMoving: isKaplaMoving)
//        )
//    }
//}

/// A modifier that adds gestures and positioning to a view.
struct RotateGestureModifier: ViewModifier {

    @State private var rotation: Rotation3D = .init()
    @State private var startRotation: Rotation3D? = nil
    @Binding var kaplasMoving: [Bool]
    var index: Int

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(rotation)
            
            // Enable people to rotate the model anywhere in their space.
            .simultaneousGesture(RotateGesture3D()
                .onChanged { value in
                    kaplasMoving[index] = true
                    if startRotation != nil {
                        rotation = value.rotation
                    } else {
                        startRotation = rotation
                    }
                }
                .onEnded { _ in
                    kaplasMoving[index] = false
                    startRotation = nil
                }
            )
    }
}

