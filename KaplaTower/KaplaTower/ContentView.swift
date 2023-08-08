//
//  ContentView.swift
//  KaplaTower
//
//  Created by Guillaume Saladin on 08/08/2023.
//

import SwiftUI
import RealityKit

struct ContentView: View {

    @State private var showImmersiveSpace = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        NavigationSplitView {
            List {
                Text("Kapla")
            }.navigationTitle("Sidebar")
        } detail: {
            Button("Show Kapla") {
                Task {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                }
            }
            .navigationTitle("Content")
            .padding()
        }
    }
}
