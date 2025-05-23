import SwiftUI
import AVKit

// A reusable card view for displaying car previews with optional premium access control
struct PremiumCarCard: View {
    let url: URL                         // URL of the car image
    let title: String                    // Title to display on the card
    let isPremium: Bool                  // Indicates if this car is premium content
    let isSubscribed: Bool               // Whether the user has a subscription
    let accentColor: Color               // Primary accent color
    let accentColorAlt: Color            // Secondary accent color (used in overlay)
    let cardBgColor: Color               // Background color of the card
    let width: CGFloat                   // Width of the card
    let height: CGFloat                  // Height of the card
    let isCompact: Bool                  // Whether layout should be compact
    let action: () -> Void               // Action when card is tapped
    
    @State private var isHovered = false // For hover scaling effect (can be useful on macOS)

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottom) {
                // Async image loader with fallback/error/loading handling
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
                    // Border stroke with gradient
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

                // Overlay lock and "PREMIUM" label if user is not subscribed
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

                // Gradient background for title text (fades into image)
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
                    RoundedRectangle(cornerRadius: isCompact ? 12 : 16, style: .continuous)
                )
                .opacity(isPremium && !isSubscribed ? 0 : 1)

                // Title text overlay (hidden if locked)
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
        .contentShape(Rectangle()) // Ensures full card is tappable
        .buttonStyle(PlainButtonStyle()) // Removes default button styling (like highlight)
    }
}
