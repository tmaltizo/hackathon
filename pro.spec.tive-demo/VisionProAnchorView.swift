//
//  VisionProAnchorView.swift
//  pro.spec.tive-demo
//
//  Created by 290028062 on 11/14/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct VisionProAnchorView: View {
    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity(world: [0, 1, -1]) // Position 1 meter in front
//            let viewBox = try! ModelEntity.load(named: "codeEditor") // Optional 3D container

//            anchor.addChild(viewBox)
            content.add(anchor)
        }
        .overlay(
            CodeEditorView()
                .frame(width: 1200, height: 800)
                .cornerRadius(20)
                .shadow(radius: 10)
        )
    }
}
