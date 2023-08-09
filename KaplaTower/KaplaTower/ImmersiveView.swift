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
    let boxSize: SIMD3<Float> = [0.117, 0.0234, 0.0078]

    var body: some View {
        RealityView { content in
            let cubeEntity = ModelEntity(
                mesh: MeshResource.generateBox(width: boxSize.x, height: boxSize.y, depth: boxSize.z),
                materials: [SimpleMaterial(color: .systemBrown, isMetallic: false)]
            )

            cubeEntity.components.set(InputTargetComponent())
            cubeEntity.components.set(CollisionComponent(shapes: [.generateBox(width: boxSize.x, height: boxSize.y, depth: boxSize.z)]))

            content.add(cubeEntity)
        }
        .onAppear {
            dismissWindow(id: "Content")
        }
        .placementGesture()
        .rotateGesture()
    }
}
