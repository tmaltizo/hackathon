import SwiftUI

struct GPTPopupView: View {
    let response: String
    @Binding var position: CGPoint
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Insights")
                    .font(.headline)
                Spacer()
                Button(action: {
                    isVisible = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding([.top, .horizontal])
            Divider()
            Text(response)
                .padding()
        }
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 15)
        .frame(width: 400)
        .position(position)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.position = gesture.location
                }
        )
         // Position the popup closer to the viewer in 3D space
        .focusDistance(1.0)
    }
}
