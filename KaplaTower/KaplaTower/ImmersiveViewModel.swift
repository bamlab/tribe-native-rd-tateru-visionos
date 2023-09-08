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
            materials: [SimpleMaterial(color: isOddFloor ? .systemBrown : .systemGreen, isMetallic: false)]
        )
        kapla.components.set(InputTargetComponent())
        kapla.collision = CollisionComponent(shapes: [.generateBox(width: width, height: height, depth: depth)])
        kapla.physicsBody = PhysicsBodyComponent(massProperties: PhysicsMassProperties(mass: 0.1), material: .default, mode: .dynamic)
        kapla.position = position
        return kapla
    }

    func setupTable() -> ModelEntity {
        let table = ModelEntity(
            mesh: MeshResource.generateBox(width: 1, height: 0.01, depth: 1),
            materials: [SimpleMaterial(color: .systemPink, isMetallic: false)]
        )
        table.collision = CollisionComponent(shapes: [.generateBox(width: 1, height: 0.01, depth: 1)])
        table.position = SIMD3(x: 0, y: 1.5, z: -2)
        return table
    }
    
    func setupPlate() -> ModelEntity {
        let plate = ModelEntity(
            mesh: MeshResource.generateBox(width: 0.5, height: 0.01, depth: 0.5, cornerRadius: 10),
            materials: [SimpleMaterial(color: .systemGray, isMetallic: false)]
        )
        plate.collision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.01, depth: 0.5)])
        plate.position = SIMD3(x: 0, y: 1.7, z: -2)
        return plate
    }

    func updateKaplaGravity(kapla: Entity, isKaplaMoving: Bool) {
        if (isKaplaMoving) {
            kapla.components.remove(PhysicsBodyComponent.self)
        } else {
            kapla.components.set(PhysicsBodyComponent(massProperties: PhysicsMassProperties(mass: 0.1), material: .default, mode: .dynamic))
        }
    }

//    func updateKaplaGravity(isKaplaMoving: Bool) {
//        kaplaEntity.children.forEach { child in
//            if (isKaplaMoving) {
//                child.components.remove(PhysicsBodyComponent.self)
//            } else {
//                child.components.set(PhysicsBodyComponent())
//            }
//        }
//    }
}
