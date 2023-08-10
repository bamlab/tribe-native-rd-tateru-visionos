//
//  ImmersiveViewModel.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 09/08/2023.
//

import SwiftUI
import RealityKit
import ARKit

@MainActor class ImmersiveViewModel: ObservableObject {

    private let session = ARKitSession()
    private let planeData = PlaneDetectionProvider(alignments: [.horizontal, .vertical])
    private let worldTracking = WorldTrackingProvider()
    private var contentEntity = Entity()

    private let kaplaSize: SIMD3<Float> = [0.117, 0.0234, 0.0078]

    func setupContentEntity() -> Entity {
        let kapla = ModelEntity(
            mesh: MeshResource.generateBox(width: kaplaSize.x, height: kaplaSize.y, depth: kaplaSize.z),
            materials: [SimpleMaterial(color: .systemBrown, isMetallic: false)]
        )
        kapla.components.set(InputTargetComponent())
        kapla.components.set(CollisionComponent(shapes: [.generateBox(width: kaplaSize.x, height: kaplaSize.y, depth: kaplaSize.z)]))
        kapla.components.set(PhysicsMotionComponent())
        kapla.components.set(PhysicsBodyComponent())
        kapla.position = SIMD3(x: 0, y: 1, z: -2)
        contentEntity.addChild(kapla)
        return contentEntity
    }

    func runSession() async {

        print("WorldTrackingProvider.isSupported: \(WorldTrackingProvider.isSupported)")
        print("PlaneDetectionProvider.isSupported: \(PlaneDetectionProvider.isSupported)")
        print("SceneReconstructionProvider.isSupported: \(SceneReconstructionProvider.isSupported)")
        print("HandTrackingProvider.isSupported: \(HandTrackingProvider.isSupported)")

        Task {
            let authorizationResult = await session.requestAuthorization(for: [.worldSensing])

            for (authorizationType, authorizationStatus) in authorizationResult {
                print("Authorization status for \(authorizationType): \(authorizationStatus)")
                switch authorizationStatus {
                case .allowed:
                    break
                case .denied:
                    // Need to handle this.
                    break
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
            }
        }

        Task {
            try await session.run([planeData])

            for await update in planeData.anchorUpdates {
                // Skip planes that are windows.
                if update.anchor.classification != .table { continue }

                switch update.event {
                case .added, .updated:
                    updatePlane(update.anchor)
                case .removed:
                    removePlane(update.anchor)
                @unknown default:
                    break
                }
            }
        }
    }

    var entityMap: [UUID: Entity] = [:]

    func updatePlane(_ anchor: PlaneAnchor) {
        if entityMap[anchor.id] == nil {
            // Add a new entity to represent this plane.
            let entity = ModelEntity(
                mesh: .generateText(anchor.classification.description)
            )
            entityMap[anchor.id] = entity
            contentEntity.addChild(entity)
        }
        entityMap[anchor.id]?.transform = Transform(matrix: anchor.transform)
    }

    func removePlane(_ anchor: PlaneAnchor) {
        entityMap[anchor.id]?.removeFromParent()
        entityMap.removeValue(forKey: anchor.id)
    }
}
