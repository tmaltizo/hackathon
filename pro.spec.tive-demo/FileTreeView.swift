import SwiftUI

struct FileItem: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let children: [FileItem]?
    
}

let fileTreeData = [
    FileItem(name: "MyPythonProject", children: [
        FileItem(name: "src", children: [
            FileItem(name: "init.py", children: nil),
            FileItem(name: "main.py", children: nil),
            FileItem(name: "utils.py", children: nil),
            FileItem(name: "module", children: [
                FileItem(name: "init.py", children: nil),
                FileItem(name: "module.py", children: nil),
                FileItem(name: "helper.py", children: nil),
            ]),
        ]),
        FileItem(name: "tests", children: [
            FileItem(name: "init.py", children: nil),
            FileItem(name: "test_main.py", children: nil),
            FileItem(name: "test_utils.py", children: nil),
        ]),
        FileItem(name: "docs", children: [
            FileItem(name: "index.md", children: nil),
            FileItem(name: "usage.md", children: nil),
        ]),
        FileItem(name: "README.md", children: nil),
        FileItem(name: "LICENSE", children: nil),
        FileItem(name: "requirements.txt", children: nil),
        FileItem(name: "setup.py", children: nil),
        FileItem(name: ".gitignore", children: nil),
    ])
]

struct FileTreeView: View {
    let items: [FileItem]
    @Binding var selectedFile: FileItem?
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                FileTreeRow(item: item, selectedFile: $selectedFile)
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct FileTreeRow: View {
    let item: FileItem
    @Binding var selectedFile: FileItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if item.children != nil {
                    Image(systemName: "folder")
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "doc.plaintext")
                        .foregroundColor(.gray)
                }
                Text(item.name)
                    .foregroundColor(item == selectedFile ? .blue : .primary)
                    .onTapGesture {
                        if item.children == nil {
                            selectedFile = item
                        }
                    }
            }
            if let children = item.children {
                ForEach(children, id: \.self) { child in
                    FileTreeRow(item: child, selectedFile: $selectedFile)
                        .padding(.leading, 20)
                }
            }
        }
    }
}
