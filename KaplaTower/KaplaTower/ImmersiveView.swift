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
        .placementGesture()
        .rotateGesture()
    }
}
