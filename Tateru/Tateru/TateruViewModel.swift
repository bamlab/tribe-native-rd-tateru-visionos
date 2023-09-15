//
//  TateruViewModel.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 09/08/2023.
//

import SwiftUI
import RealityKit
import ARKit

@MainActor class TateruViewModel: ObservableObject {

    private let blockSize: SIMD3<Float> = [0.075, 0.015, 0.025]

    func setupBlock(position: SIMD3<Float>, isOddFloor: Bool) -> ModelEntity {
        let width = isOddFloor ? blockSize.z : blockSize.x
        let height = blockSize.y
        let depth = isOddFloor ? blockSize.x : blockSize.z
        let block = ModelEntity(
            mesh: MeshResource.generateBox(width: width, height: height, depth: depth),
            materials: [SimpleMaterial(color: isOddFloor ? .systemBrown : .systemCyan, isMetallic: false)]
        )
        block.components.set(InputTargetComponent())
        block.collision = CollisionComponent(shapes: [.generateBox(width: width, height: height, depth: depth)])
//        block.physicsBody = PhysicsBodyComponent(massProperties: PhysicsMassProperties(mass: 0.1))
        block.setPosition(position, relativeTo: nil)
        return block
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
            mesh: MeshResource.generateBox(width: 0.2, height: 0.01, depth: 0.2, cornerRadius: 10),
            materials: [SimpleMaterial(color: .systemGray, isMetallic: false)]
        )
        plate.collision = CollisionComponent(shapes: [.generateBox(width: 0.2, height: 0.01, depth: 0.2)])
        plate.setPosition(SIMD3(x: 0, y: 1.02, z: -2), relativeTo: nil)
        return plate
    }

    func setupDepositArea() -> ModelEntity {
        var material = SimpleMaterial()
        material.color = SimpleMaterial.BaseColor(tint: UIColor(red: 1, green: 0, blue: 0, alpha: 1))

        let depositArea = ModelEntity(
            mesh: MeshResource.generatePlane(width: 0.5, depth: 0.5, cornerRadius: 50),
            materials: [material]
        )
        depositArea.collision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0, depth: 0.5)], mode: .trigger, filter: .sensor)
        depositArea.setPosition(SIMD3(x: 0.5, y: 1.02, z: -2), relativeTo: nil)
        return depositArea
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

    func updateBlockGravity(block: Entity, isBlockMoving: Bool) {
        if (isBlockMoving) {
            block.components.remove(PhysicsBodyComponent.self)
        } else {
            block.components.set(PhysicsBodyComponent(massProperties: PhysicsMassProperties(mass: 0.1), material: .default, mode: .dynamic))
        }
    }
}
