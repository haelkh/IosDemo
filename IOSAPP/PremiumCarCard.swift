import SwiftUI
import AVKit

struct PremiumCarCard: View {
    let url: URL
    let title: String
    let isPremium: Bool
    let isSubscribed: Bool
    let accentColor: Color
    let accentColorAlt: Color
    let cardBgColor: Color
    let width: CGFloat
    let height: CGFloat
    let isCompact: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottom) {
                // Image
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                        Color.gray
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                            )
                    } else {
                        Color.gray.opacity(0.3)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
                            )
                    }
                }
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: isCompact ? 12 : 16))
                .overlay(
                    RoundedRectangle(cornerRadius: isCompact ? 12 : 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [accentColor.opacity(0.7), accentColorAlt.opacity(0.5)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                
                // Premium overlay
                if isPremium && !isSubscribed {
                    ZStack {
                        Color.black.opacity(0.7)
                        
                        VStack(spacing: isCompact ? 6 : 8) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: isCompact ? 20 : 24))
                                .foregroundColor(accentColorAlt)
                            
                            Text("PREMIUM")
                                .font(.system(size: isCompact ? 12 : 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .tracking(2)
                        }
                    }
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: isCompact ? 12 : 16))
                }
                
                // Title background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.8),
                        Color.black.opacity(0.4),
                        Color.clear
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(width: width, height: height / 2.5)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: isCompact ? 12 : 16,
                        style: .continuous
                    )
                )
                .opacity(isPremium && !isSubscribed ? 0 : 1)
                
                // Title
                HStack {
                    Text(title)
                        .font(.system(size: isCompact ? 12 : 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                        .lineLimit(isCompact ? 2 : 1)
                        .padding(.horizontal, isCompact ? 8 : 12)
                        .padding(.bottom, isCompact ? 8 : 12)
                }
                .frame(width: width, alignment: .leading)
                .opacity(isPremium && !isSubscribed ? 0 : 1)
            }
            .frame(width: width, height: height)
            .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 10)
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
            
        }
        .frame(width: width, height: height)
        .contentShape(Rectangle()) // ✅ Makes entire frame tappable
        .buttonStyle(PlainButtonStyle()) // ✅ Prevents iOS-style button effects
    }
}
