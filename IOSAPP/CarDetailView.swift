import SwiftUI
import AVKit  // For potential video functionality (though not directly used here)

// View for displaying detailed car information
struct CarDetailView: View {
    // Input properties
    let car: ContentView.Car           // Car data to display
    let isSubscribed: Bool             // User's subscription status
    let accentColor: Color             // Primary accent color
    let accentColorAlt: Color          // Secondary accent color
    let cardBgColor: Color             // Background color for the card
    let screenSize: CGSize             // Current screen dimensions
    let closeAction: () -> Void        // Handler for close button
    let playVideoAction: () -> Void    // Handler for video playback
    
    @State private var showSpecs = false  // Toggle for showing/hiding specs
    
    // Device size helpers
    private var isCompact: Bool { screenSize.width < 768 }  // iPhone vs iPad
    private var maxWidth: CGFloat {
        isCompact ? screenSize.width * 0.9 : min(500, screenSize.width * 0.8)
    }
    private var maxHeight: CGFloat {
        isCompact ? screenSize.height * 0.85 : min(600, screenSize.height * 0.8)
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                // Main card container
                RoundedRectangle(cornerRadius: isCompact ? 20 : 24)
                    .fill(cardBgColor)  // Solid background
                    .overlay(
                        RoundedRectangle(cornerRadius: isCompact ? 20 : 24)
                            .stroke(  // Gradient border
                                LinearGradient(
                                    gradient: Gradient(colors: [accentColor.opacity(0.7), accentColorAlt.opacity(0.5)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: accentColor.opacity(0.3), radius: 30, x: 0, y: 15)  // Colored shadow
                
                VStack(spacing: 0) {
                    // Header section with car image
                    ZStack(alignment: .topTrailing) {
                        // Async image loading
                        AsyncImage(url: URL(string: car.url)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: screenSize.width * 0.95, height: isCompact ? 180 : 220)
                                    .clipped()
                            } else {
                                Color.gray  // Placeholder while loading
                                    .frame(width: screenSize.width * 0.95, height: isCompact ? 180 : 220)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: isCompact ? 20 : 24, style: .continuous))
                        .overlay(  // Dark gradient overlay
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.1), Color.black.opacity(0.5)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .clipShape(RoundedRectangle(cornerRadius: isCompact ? 20 : 24, style: .continuous))
                        )
                        
                        // Close button (top-right)
                        Button(action: closeAction) {
                            ZStack {
                                Circle()
                                    .fill(Color.black.opacity(0.6))
                                    .frame(width: isCompact ? 32 : 36, height: isCompact ? 32 : 36)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: isCompact ? 12 : 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(isCompact ? 12 : 16)
                    }
                    
                    // Content section
                    VStack(alignment: .leading, spacing: isCompact ? 16 : 20) {
                        // Title row
                        HStack {
                            Text(car.title)
                                .font(.system(size: isCompact ? 20 : 24, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .lineLimit(isCompact ? 2 : 1)
                            
                            Spacer()
                            
                            // Premium badge (if applicable)
                            if car.isPremium {
                                HStack(spacing: 6) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: isCompact ? 12 : 14))
                                        .foregroundColor(accentColorAlt)
                                    
                                    Text("PREMIUM")
                                        .font(.system(size: isCompact ? 10 : 12, weight: .semibold, design: .monospaced))
                                        .foregroundColor(accentColorAlt)
                                }
                                .padding(.horizontal, isCompact ? 8 : 10)
                                .padding(.vertical, isCompact ? 4 : 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(accentColorAlt.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(accentColorAlt.opacity(0.5), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        // Description text
                        Text(car.description)
                            .font(.system(size: isCompact ? 14 : 16))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(5)
                        
                        // Specifications section (expandable)
                        VStack(alignment: .leading, spacing: 15) {
                            Button(action: {
                                withAnimation(.spring()) {
                                    showSpecs.toggle()
                                }
                            }) {
                                HStack {
                                    Text("SPECIFICATIONS")
                                        .font(.system(size: isCompact ? 14 : 16, weight: .semibold, design: .monospaced))
                                        .foregroundColor(accentColor)
                                    
                                    Spacer()
                                    
                                    // Chevron indicator
                                    Image(systemName: showSpecs ? "chevron.up" : "chevron.down")
                                        .font(.system(size: isCompact ? 12 : 14, weight: .bold))
                                        .foregroundColor(accentColor)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Specifications grid (shown when expanded)
                            if showSpecs {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: isCompact ? 1 : 2), spacing: 12) {
                                    ForEach(Array(car.specs.keys.sorted()), id: \.self) { key in
                                        HStack {
                                            Text(key)  // Spec name
                                                .font(.system(size: isCompact ? 12 : 14, weight: .medium))
                                                .foregroundColor(.white.opacity(0.7))
                                            
                                            Spacer()
                                            
                                            Text(car.specs[key] ?? "")  // Spec value
                                                .font(.system(size: isCompact ? 12 : 14, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, isCompact ? 10 : 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white.opacity(0.05))  // Slight highlight
                                        )
                                    }
                                }
                                .transition(.opacity.combined(with: .move(edge: .top)))  // Animated appearance
                            }
                        }
                        
                        // Action buttons (different layout for compact/regular)
                        if isCompact {
                            VStack(spacing: 12) {
                                // Watch Video button
                                Button(action: playVideoAction) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 16))
                                        
                                        Text("WATCH VIDEO")
                                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(car.isPremium && !isSubscribed ? Color.gray : accentColorAlt)  // Disabled state
                                    )
                                }
                                .disabled(car.isPremium && !isSubscribed)
                                .opacity(car.isPremium && !isSubscribed ? 0.5 : 1)
                            }
                        } else {
                            HStack(spacing: 15) {
                                // Watch Video button (regular layout)
                                Button(action: playVideoAction) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 12))
                                        
                                        Text("WATCH VIDEO")
                                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                                    }
                                    .foregroundColor(.black)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(car.isPremium && !isSubscribed ? Color.gray : accentColorAlt)
                                    )
                                }
                                .disabled(car.isPremium && !isSubscribed)
                                .opacity(car.isPremium && !isSubscribed ? 0.5 : 1)
                            }
                        }
                    }
                    .padding(isCompact ? 16 : 24)
                }
            }
        }
        // Responsive sizing
        .frame(width: screenSize.width * 0.95)
        .frame(maxWidth: .infinity)
        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
        .padding(isCompact ? 16 : 20)
    }
}
