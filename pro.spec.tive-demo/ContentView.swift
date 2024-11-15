import RealityKit
import RealityKitContent
import SwiftUI

struct CodeEditorRealityView: View {
    var body: some View {
        RealityView { content in
            let codeEditorEntity = ModelEntity(mesh: .generatePlane(width: 1.0, depth: 1.5))
            codeEditorEntity.model?.materials = [SimpleMaterial(color: .white, isMetallic: false)]
            let anchor = AnchorEntity()
            anchor.addChild(codeEditorEntity)
            content.add(anchor)
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            CodeEditorRealityView().edgesIgnoringSafeArea(.all)
        }
    }
}
