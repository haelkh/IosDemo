import SwiftUI
import AVKit

struct CarDetailView: View {
    let car: ContentView.Car
    let isSubscribed: Bool
    let accentColor: Color
    let accentColorAlt: Color
    let cardBgColor: Color
    let screenSize: CGSize
    let closeAction: () -> Void
    let playVideoAction: () -> Void
    
    @State private var showSpecs = false
    
    private var isCompact: Bool { screenSize.width < 768 }
    private var maxWidth: CGFloat {
        if isCompact {
            return screenSize.width * 0.9
        } else {
            return min(500, screenSize.width * 0.8)
        }
    }
    private var maxHeight: CGFloat {
        if isCompact {
            return screenSize.height * 0.85
        } else {
            return min(600, screenSize.height * 0.8)
        }
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                // Card background
                RoundedRectangle(cornerRadius: isCompact ? 20 : 24)
                    .fill(cardBgColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: isCompact ? 20 : 24)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [accentColor.opacity(0.7), accentColorAlt.opacity(0.5)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: accentColor.opacity(0.3), radius: 30, x: 0, y: 15)
                
                VStack(spacing: 0) {
                    // Header with image
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: URL(string: car.url)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: screenSize.width * 0.95, height: isCompact ? 180 : 220) // ✅ Force width
                                    .clipped()
                            } else {
                                Color.gray
                                    .frame(width: screenSize.width * 0.95, height: isCompact ? 180 : 220) // ✅ Add width here too
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: isCompact ? 20 : 24, style: .continuous))

                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.black.opacity(0.1),
                                    Color.black.opacity(0.5)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .clipShape(RoundedRectangle(cornerRadius: isCompact ? 20 : 24, style: .continuous))
                        )
                        
                        // Close button
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
                    
                    // Content
                    VStack(alignment: .leading, spacing: isCompact ? 16 : 20) {
                        // Title
                        HStack {
                            Text(car.title)
                                .font(.system(size: isCompact ? 20 : 24, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .lineLimit(isCompact ? 2 : 1)
                            
                            Spacer()
                            
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
                        
                        // Description
                        Text(car.description)
                            .font(.system(size: isCompact ? 14 : 16))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(5)
                        
                        // Specs
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
                                    
                                    Image(systemName: showSpecs ? "chevron.up" : "chevron.down")
                                        .font(.system(size: isCompact ? 12 : 14, weight: .bold))
                                        .foregroundColor(accentColor)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if showSpecs {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: isCompact ? 1 : 2), spacing: 12) {
                                    ForEach(Array(car.specs.keys.sorted()), id: \.self) { key in
                                        HStack {
                                            Text(key)
                                                .font(.system(size: isCompact ? 12 : 14, weight: .medium))
                                                .foregroundColor(.white.opacity(0.7))
                                            
                                            Spacer()
                                            
                                            Text(car.specs[key] ?? "")
                                                .font(.system(size: isCompact ? 12 : 14, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, isCompact ? 10 : 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white.opacity(0.05))
                                        )
                                    }
                                }
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        
                        // Action buttons
                        if isCompact {
                            VStack(spacing: 12) {
                                

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
                                            .fill(car.isPremium && !isSubscribed ? Color.gray : accentColorAlt)
                                    )
                                }
                                .disabled(car.isPremium && !isSubscribed)
                                .opacity(car.isPremium && !isSubscribed ? 0.5 : 1)
                            }
                        } else {
                            HStack(spacing: 15) {
                                
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
        .frame(width: screenSize.width * 0.95) // ✅ Keep inside screen
        .frame(maxWidth: .infinity)
        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
        .padding(isCompact ? 16 : 20)
    }
}
