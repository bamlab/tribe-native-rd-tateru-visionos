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
    private var kaplaEntity = Entity()
    private var tableEntity = Entity()
    private var plateEntity = Entity()

    private let kaplaSize: SIMD3<Float> = [0.117, 0.0234, 0.0078]

    var isKaplaMoving: Bool = false

    func setupKapla() -> Entity {
        let kapla = ModelEntity(
            mesh: MeshResource.generateBox(width: kaplaSize.x, height: kaplaSize.y, depth: kaplaSize.z),
            materials: [SimpleMaterial(color: .systemBrown, isMetallic: false)]
        )
        kapla.components.set(InputTargetComponent())
        kapla.collision = CollisionComponent(shapes: [.generateBox(width: kaplaSize.x, height: kaplaSize.y, depth: kaplaSize.z)])
        kapla.physicsBody = PhysicsBodyComponent(massProperties: PhysicsMassProperties(mass: 0.1), material: .default, mode: .dynamic)
        kapla.position = SIMD3(x: 0.5, y: 2, z: -2)
        kaplaEntity.addChild(kapla)
        return kaplaEntity
    }

    func setupTable() -> Entity {
        let table = ModelEntity(
            mesh: MeshResource.generateBox(width: 1, height: 0.01, depth: 1),
            materials: [SimpleMaterial(color: .systemPink, isMetallic: true)]
        )
        table.collision = CollisionComponent(shapes: [.generateBox(width: 1, height: 0.01, depth: 1)])
        table.position = SIMD3(x: 0, y: 1.5, z: -2)
        tableEntity.addChild(table)
        return tableEntity
    }
    
    func setupPlate() -> Entity {
        let plate = ModelEntity(
            mesh: MeshResource.generateBox(width: 0.5, height: 0.01, depth: 0.5, cornerRadius: 10),
            materials: [SimpleMaterial(color: .systemGray, isMetallic: true)]
        )
        plate.collision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.01, depth: 0.5)])
        plate.position = SIMD3(x: 0, y: 1.7, z: -2)
        plateEntity.addChild(plate)
        return plateEntity
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

    func updateKaplaGravity(isKaplaMoving: Bool) {
        kaplaEntity.children.forEach { child in
            if (isKaplaMoving) {
                child.components.remove(PhysicsBodyComponent.self)
            } else {
                child.components.set(PhysicsBodyComponent())
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
            kaplaEntity.addChild(entity)
        }
        entityMap[anchor.id]?.transform = Transform(matrix: anchor.transform)
    }

    func removePlane(_ anchor: PlaneAnchor) {
        entityMap[anchor.id]?.removeFromParent()
        entityMap.removeValue(forKey: anchor.id)
    }
}
