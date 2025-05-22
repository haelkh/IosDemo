import SwiftUI

struct AnimatedImageCard: View {
    let url: URL
    let title: String
    let width: CGFloat
    let height: CGFloat
    let onTap: () -> Void

    @State private var isHovered = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: width, height: height)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .clipped()
                        .cornerRadius(16)
                        .shadow(color: .yellow.opacity(0.4), radius: isHovered ? 10 : 4, x: 0, y: 5)
                        .scaleEffect(isHovered ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isHovered)
                        
                case .failure:
                    Image(systemName: "xmark.octagon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            // Title overlay
            Text(title)
                .font(.custom("Orbitron-Regular", size: 14))
                .foregroundColor(.white)
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .padding([.leading, .bottom], 10)
        }
        .frame(width: width, height: height)
    }
}
