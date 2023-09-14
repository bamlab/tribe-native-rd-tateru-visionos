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

    private let kaplaSize: SIMD3<Float> = [0.075, 0.015, 0.025]

    func setupKapla(position: SIMD3<Float>, isOddFloor: Bool) -> ModelEntity {
        let width = isOddFloor ? kaplaSize.z : kaplaSize.x
        let height = kaplaSize.y
        let depth = isOddFloor ? kaplaSize.x : kaplaSize.z
        let kapla = ModelEntity(
            mesh: MeshResource.generateBox(width: width, height: height, depth: depth),
            materials: [SimpleMaterial(color: isOddFloor ? .systemBrown : .systemCyan, isMetallic: false)]
        )
        kapla.components.set(InputTargetComponent())
        kapla.collision = CollisionComponent(shapes: [.generateBox(width: width, height: height, depth: depth)])
//        kapla.physicsBody = PhysicsBodyComponent(massProperties: PhysicsMassProperties(mass: 0.1))
        kapla.setPosition(position, relativeTo: nil)
        return kapla
    }

    func setupTable() -> ModelEntity {
        var material = SimpleMaterial()
        material.color = SimpleMaterial.BaseColor(tint: UIColor(red: 0, green: 0, blue: 0, alpha: 0))

        let table = ModelEntity(
            mesh: MeshResource.generateBox(width: 2, height: 0.01, depth: 2),
            materials: [material]
        )
        table.collision = CollisionComponent(shapes: [.generateBox(width: 2, height: 0.01, depth: 2)], mode: .trigger, filter: .sensor)
        table.setPosition(SIMD3(x: 0, y: 1, z: -2), relativeTo: nil)
        return table
    }
    
    func setupPlate() -> ModelEntity {
        let plate = ModelEntity(
            mesh: MeshResource.generateBox(width: 0.5, height: 0.01, depth: 0.5, cornerRadius: 10),
            materials: [SimpleMaterial(color: .systemGray, isMetallic: false)]
        )
        plate.collision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.01, depth: 0.5)])
        plate.setPosition(SIMD3(x: 0, y: 1.02, z: -2), relativeTo: nil)
        return plate
    }
    
    func setupGameOver() -> ModelEntity {
        let textMesh = MeshResource.generateText(
            "GAME OVER",
            extrusionDepth: 0.1,
            font: .init(
                descriptor: .init(name: "Helvetica", size: 0),
                size: 0.3
            )
        )
        let gameOver = ModelEntity(
            mesh: textMesh,
            materials: [SimpleMaterial(color: .systemRed, isMetallic: true)]
        )
        gameOver.setPosition(SIMD3(x: -1, y: 1.5, z: -2), relativeTo: nil)
        return gameOver
    }

    func updateKaplaGravity(kapla: Entity, isKaplaMoving: Bool) {
        if (isKaplaMoving) {
            kapla.components.remove(PhysicsBodyComponent.self)
        } else {
            kapla.components.set(PhysicsBodyComponent(massProperties: PhysicsMassProperties(mass: 0.1), material: .default, mode: .dynamic))
        }
    }
}
