import SwiftUI
import AVKit

struct ContentView: View {
    @AppStorage("isSubscribed") private var isSubscribed: Bool = false
    @State private var showPlayer = false
    @State private var selectedVideoURL: URL?
    @State private var animateHeader = false
    @State private var scrollOffset: CGFloat = 0
    @State private var selectedCar: Car? = nil
    @State private var showCarDetails = false
    
    // Theme colors
    let primaryColor = Color(hex: "0F0F13")
    let secondaryColor = Color(hex: "1A1A24")
    let accentColor = Color(hex: "FF3B30") // Ferrari red
    let accentColorAlt = Color(hex: "FFCC00") // Racing yellow
    let textColor = Color.white
    let cardBgColor = Color(hex: "1E1E28").opacity(0.7)
    
    struct Car: Identifiable, Equatable {
        let id = UUID()
        let url: String
        let title: String
        let description: String
        let specs: [String: String]
        let isPremium: Bool
    }

    let verticalImages: [Car] = [
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Endurance-Racing/2025-Ferrari-499P-001-1080.jpg",
            title: "Ferrari 499P",
            description: "The Ferrari 499P is a Le Mans Hypercar built by Ferrari to compete in the FIA World Endurance Championship.",
            specs: ["Power": "680 HP", "Top Speed": "340 km/h", "0-100 km/h": "2.8s", "Weight": "1030 kg"],
            isPremium: true),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Endurance-Racing/2024-Lamborghini-SC63-001-1080.jpg",
            title: "Lamborghini SC63",
            description: "The Lamborghini SC63 is Lamborghini's first Le Mans Hypercar, designed to compete in the FIA WEC and IMSA championships.",
            specs: ["Power": "670 HP", "Top Speed": "330 km/h", "0-100 km/h": "2.9s", "Weight": "1040 kg"],
            isPremium: true),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Endurance-Racing/2024-Peugeot-9X8-001-1080.jpg",
            title: "Peugeot 9X8",
            description: "The Peugeot 9X8 is a Le Mans Hypercar notable for its unique design without a rear wing.",
            specs: ["Power": "680 HP", "Top Speed": "330 km/h", "0-100 km/h": "3.0s", "Weight": "1030 kg"],
            isPremium: false)
    ]

    let horizontalImages: [Car] = [
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Scuderia-Ferrari/2025-Formula1-Ferrari-SF-25-002-1080.jpg",
            title: "Ferrari SF-25",
            description: "The Ferrari SF-25 is Ferrari's Formula 1 car for the 2025 season, featuring advanced aerodynamics and hybrid power unit.",
            specs: ["Power": "1000+ HP", "Top Speed": "370 km/h", "0-100 km/h": "2.6s", "Weight": "798 kg"],
            isPremium: true),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/McLaren/2024-Formula1-McLaren-MCL38-001-1080.jpg",
            title: "McLaren MCL38",
            description: "The McLaren MCL38 is McLaren's Formula 1 car for the 2024 season, featuring the iconic papaya livery.",
            specs: ["Power": "1000+ HP", "Top Speed": "365 km/h", "0-100 km/h": "2.7s", "Weight": "798 kg"],
            isPremium: false),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Williams/2025-Formula1-Williams-FW47-001-1080.jpg",
            title: "Williams FW47",
            description: "The Williams FW47 is Williams' Formula 1 car for the 2025 season, continuing the team's legacy in F1.",
            specs: ["Power": "1000+ HP", "Top Speed": "360 km/h", "0-100 km/h": "2.8s", "Weight": "798 kg"],
            isPremium: true)
    ]
    
    // Demo video URL
    let demoVideoURLString = "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"

    var body: some View {
        GeometryReader { geometry in
            ZStack { // Main ZStack for content and popup
                // Dynamic background with parallax effect
                ZStack {
                    Color(hex: "0F0F13") // Fallback background color
                        .overlay(
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.8),
                                        Color.blue.opacity(0.2),
                                        Color.black.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                        )
                        .blur(radius: 8)
                        .opacity(0.3)
                        .offset(y: -scrollOffset * 0.1) // Subtle parallax
                    
                    // Gradient overlay
                    LinearGradient(
                        gradient: Gradient(colors: [
                            primaryColor,
                            primaryColor.opacity(0.8),
                            secondaryColor.opacity(0.6)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .ignoresSafeArea()
                
                // Animated background elements
                ZStack {
                    // Racing line elements
                    ForEach(0..<5, id: \.self) { index in
                        RacingLine(
                            width: geometry.size.width,
                            offset: CGFloat(index) * 200 - scrollOffset.truncatingRemainder(dividingBy: 200),
                            color: index % 2 == 0 ? accentColor : accentColorAlt
                        )
                    }
                }
                .opacity(0.15)
                .blendMode(.overlay)
                .ignoresSafeArea()

                // Main content
                ScrollView {
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: proxy.frame(in: .named("scroll")).minY
                        )
                    }
                    .frame(height: 0)
                    
                    VStack(spacing: 30) {
                        // Animated header
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("EXOTIC")
                                    .font(.system(size: 18, weight: .regular, design: .monospaced))
                                    .foregroundColor(accentColorAlt)
                                    .tracking(5)
                                    .offset(y: animateHeader ? 0 : -20)
                                    .opacity(animateHeader ? 1 : 0)
                                
                                Text("CAR SHOWCASE")
                                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                                    .foregroundColor(textColor)
                                    .tracking(2)
                                    .shadow(color: accentColor.opacity(0.5), radius: 10, x: 0, y: 0)
                                    .offset(y: animateHeader ? 0 : -30)
                                    .opacity(animateHeader ? 1 : 0)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "speedometer")
                                .font(.system(size: 36))
                                .foregroundColor(accentColor)
                                .rotationEffect(.degrees(animateHeader ? 0 : -180))
                                .opacity(animateHeader ? 1 : 0)
                        }
                        .padding(.top, 50)
                        .padding(.horizontal, 20)
                        .onAppear {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                animateHeader = true
                            }
                        }
                        
                        // Premium subscription toggle
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(cardBgColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(LinearGradient(
                                            gradient: Gradient(colors: [accentColor.opacity(0.7), accentColorAlt.opacity(0.7)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: 1.5)
                                )
                                .shadow(color: accentColor.opacity(0.2), radius: 15, x: 0, y: 10)
                            
                            HStack(spacing: 15) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(isSubscribed ? accentColorAlt : .gray)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("PREMIUM ACCESS")
                                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                        .foregroundColor(textColor)
                                    
                                    Text(isSubscribed ? "Unlock exclusive content" : "Subscribe to unlock all content")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(textColor.opacity(0.7))
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $isSubscribed.animation(.spring()))
                                    .labelsHidden()
                                    .toggleStyle(PremiumToggleStyle(onColor: accentColorAlt, offColor: Color.gray.opacity(0.3)))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                        }
                        .frame(height: 80)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Vertical Carousel - Hypercars
                        carSection(
                            title: "HYPERCARS",
                            icon: "flame.fill",
                            cars: verticalImages,
                            cardWidth: 180,
                            cardHeight: 260
                        )
                        
                        // Horizontal Carousel - Formula 1 Cars
                        carSection(
                            title: "FORMULA 1",
                            icon: "flag.checkered.2.crossed",
                            cars: horizontalImages,
                            cardWidth: 260,
                            cardHeight: 180
                        )
                        
                        // Footer
                        VStack(spacing: 15) {
                            Text("POWERED BY")
                                .font(.system(size: 12, weight: .regular, design: .monospaced))
                                .foregroundColor(textColor.opacity(0.6))
                                .tracking(5)
                            
                            HStack(spacing: 30) {
                                ForEach(["Ferrari", "McLaren", "Williams"], id: \.self) { brand in
                                    Text(brand)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(textColor.opacity(0.7))
                                }
                            }
                        }
                        .padding(.vertical, 40)
                    }
                    .padding(.bottom, 30)
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = -value
                }
                .blur(radius: showPlayer || showCarDetails ? 10 : 0)
                
                // --- Video Player Popup ---
                if showPlayer {
                    // Dimmed background
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showPlayer = false
                            }
                        }
                        .transition(.opacity)

                    if let url = selectedVideoURL {
                        PremiumVideoPlayerView(
                            url: url,
                            isSubscribed: isSubscribed,
                            closeAction: {
                                withAnimation(.spring()) {
                                    showPlayer = false
                                }
                            }
                        )
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                        .zIndex(1)
                    }
                }
                
                // --- Car Details Popup ---
                if showCarDetails, let car = selectedCar {
                    // Dimmed background
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showCarDetails = false
                            }
                        }
                        .transition(.opacity)
                    
                    CarDetailView(
                        car: car,
                        isSubscribed: isSubscribed,
                        accentColor: accentColor,
                        accentColorAlt: accentColorAlt,
                        cardBgColor: cardBgColor,
                        closeAction: {
                            withAnimation(.spring()) {
                                showCarDetails = false
                            }
                        },
                        playVideoAction: {
                            selectedVideoURL = URL(string: demoVideoURLString)
                            withAnimation(.spring()) {
                                showCarDetails = false
                                showPlayer = true
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                        removal: .scale(scale: 0.9).combined(with: .opacity)
                    ))
                    .zIndex(1)
                }
            }
            .preferredColorScheme(.dark)
            .animation(.easeInOut(duration: 0.3), value: showPlayer)
            .animation(.easeInOut(duration: 0.3), value: showCarDetails)
        }
    }

    @ViewBuilder
    private func carSection(title: String, icon: String, cars: [Car], cardWidth: CGFloat, cardHeight: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(accentColor)
                
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                    .foregroundColor(textColor)
                    .tracking(2)
                
                Spacer()
                
                Button(action: {}) {
                    Text("VIEW ALL")
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                        .foregroundColor(accentColorAlt)
                        .tracking(1)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(cars) { car in
                        if let url = URL(string: car.url) {
                            PremiumCarCard(
                                url: url,
                                title: car.title,
                                isPremium: car.isPremium,
                                isSubscribed: isSubscribed,
                                accentColor: accentColor,
                                accentColorAlt: accentColorAlt,
                                cardBgColor: cardBgColor,
                                width: cardWidth,
                                height: cardHeight,
                                action: {
                                    selectedCar = car
                                    withAnimation(.spring()) {
                                        showCarDetails = true
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.5), value: cars)
        }
    }
}

// MARK: - Supporting Views

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
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
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
                        
                        VStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 24))
                                .foregroundColor(accentColorAlt)
                            
                            Text("PREMIUM")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .tracking(2)
                        }
                    }
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
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
                        cornerRadius: 16,
                        style: .continuous
                    )
                )
                .opacity(isPremium && !isSubscribed ? 0 : 1)
                
                // Title
                HStack {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 12)
                }
                .frame(width: width, alignment: .leading)
                .opacity(isPremium && !isSubscribed ? 0 : 1)
            }
            .frame(width: width, height: height)
            .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 10)
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
            
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CarDetailView: View {
    let car: ContentView.Car
    let isSubscribed: Bool
    let accentColor: Color
    let accentColorAlt: Color
    let cardBgColor: Color
    let closeAction: () -> Void
    let playVideoAction: () -> Void
    
    @State private var showSpecs = false
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 24)
                .fill(cardBgColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
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
                        } else {
                            Color.gray
                        }
                    }
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.1),
                                Color.black.opacity(0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    )
                    
                    // Close button
                    Button(action: closeAction) {
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.6))
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(16)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    HStack {
                        Text(car.title)
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if car.isPremium {
                            HStack(spacing: 6) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(accentColorAlt)
                                
                                Text("PREMIUM")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                    .foregroundColor(accentColorAlt)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
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
                        .font(.system(size: 16))
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
                                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                    .foregroundColor(accentColor)
                                
                                Spacer()
                                
                                Image(systemName: showSpecs ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(accentColor)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if showSpecs {
                            VStack(spacing: 12) {
                                ForEach(Array(car.specs.keys.sorted()), id: \.self) { key in
                                    HStack {
                                        Text(key)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        Spacer()
                                        
                                        Text(car.specs[key] ?? "")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.vertical, 5)
                                    
                                    if key != car.specs.keys.sorted().last {
                                        Divider()
                                            .background(Color.white.opacity(0.2))
                                    }
                                }
                            }
                            .padding(15)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                            )
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    
                    Spacer()
                    
                    // Action buttons
                    HStack(spacing: 15) {
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 16))
                                
                                Text("MORE INFO")
                                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                            )
                        }
                        
                        Spacer()
                        
                        Button(action: playVideoAction) {
                            HStack(spacing: 8) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 16))
                                
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
                .padding(24)
            }
        }
        .frame(maxWidth: 500, maxHeight: 600)
        .padding(20)
    }
}

struct PremiumVideoPlayerView: View {
    let url: URL
    let isSubscribed: Bool
    let closeAction: () -> Void
    
    @State private var isPlaying = true
    @State private var volume: Float = 0.8
    
    var body: some View {
        ZStack {
            // Video player background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "1E1E28"))
                .shadow(color: Color.black.opacity(0.5), radius: 30)
            
            VStack(spacing: 0) {
                // Video player
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                
                // Controls
                VStack(spacing: 20) {
                    // Title and close button
                    HStack {
                        Text("VIDEO PREVIEW")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: closeAction) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    
                    // Playback controls
                    HStack(spacing: 30) {
                        Button(action: {}) {
                            Image(systemName: "backward.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        
                        Button(action: { isPlaying.toggle() }) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color(hex: "FF3B30"))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Volume slider
                    HStack(spacing: 15) {
                        Image(systemName: "speaker.wave.1.fill")
                            .foregroundColor(.white.opacity(0.7))
                        
                        Slider(value: $volume, in: 0...1)
                            .accentColor(Color(hex: "FF3B30"))
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(20)
            }
        }
        .frame(width: 500, height: 450)
    }
}

struct PremiumToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            ZStack {
                Capsule()
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 30)
                    .shadow(color: configuration.isOn ? onColor.opacity(0.5) : Color.black.opacity(0.1), radius: 8)
                
                Circle()
                    .fill(Color.white)
                    .shadow(radius: 1)
                    .frame(width: 24, height: 24)
                    .offset(x: configuration.isOn ? 10 : -10)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}

struct RacingLine: View {
    let width: CGFloat
    let offset: CGFloat
    let color: Color
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: offset))
            path.addLine(to: CGPoint(x: width, y: offset + 100))
        }
        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10, 10]))
        .foregroundColor(color)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Helper Extensions

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    func onHover(perform action: @escaping (Bool) -> Void) -> some View {
        #if os(macOS)
        return self.onHover(perform: action)
        #else
        return self // iOS doesn't have onHover, so return the original view
        #endif
    }
}
