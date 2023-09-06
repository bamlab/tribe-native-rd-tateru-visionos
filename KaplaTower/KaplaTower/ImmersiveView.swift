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
    @StateObject var model = ImmersiveViewModel()
    @State var isKaplaMoving: Bool = false

    var body: some View {
        RealityView { content in
            content.add(model.setupTable())
        }

        RealityView { content in
            content.add(model.setupPlate())
        }
        
        RealityView { content in
            content.add(model.setupKapla())
        }
        .task {
            await model.runSession()
        }
        .onAppear {
            dismissWindow(id: "Content")
        }
        .onChange(of: isKaplaMoving, initial: false) { _, newValue  in
            model.updateKaplaGravity(isKaplaMoving: newValue)
        }
        .modifier(PlacementGestureModifier(isKaplaMoving: $isKaplaMoving))
        .modifier(RotateGestureModifier(isKaplaMoving: $isKaplaMoving))
    }
}
