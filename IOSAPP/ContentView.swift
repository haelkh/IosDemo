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
    @State private var useAdPlayer = false

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
            isPremium: false),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/LMP/Toyota/2021-Toyota-GR010-Hybrid-001-1080.jpg",
            title: "Toyota GR010 Hybrid",
            description: "Toyota's GR010 Hybrid is a Le Mans Hypercar for the FIA WEC with hybrid technology and aerodynamic design.",
            specs: ["Power": "680 HP", "Top Speed": "330 km/h", "0-100 km/h": "2.9s", "Weight": "1040 kg"],
            isPremium: true),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Endurance-Racing/2023-Porsche-963-LMDh-001-1080.jpg",
            title: "Porsche 963",
            description: "The Porsche 963 is Porsche's 2025 Le Mans Hypercar for the FIA WEC and IMSA series.",
            specs: ["Power": "680 HP", "Top Speed": "330 km/h", "0-100 km/h": "2.8s", "Weight": "1030 kg"],
            isPremium: true),
        Car(url: "https://www.dailysportscar.com/wp-content/uploads/2024/01/01-Cadillac-Racing-Cadillac-V-Series-R-IMSA-2024-Daytona-ROAR-4.jpg",
            title: "Cadillac V-Series.R",
            description: "Cadillac's V-Series.R is their endurance racer with a powerful V8 and advanced design.",
            specs: ["Power": "670 HP", "Top Speed": "330 km/h", "0-100 km/h": "2.9s", "Weight": "1040 kg"],
            isPremium: false),
        Car(url: "https://hips.hearstapps.com/hmg-prod/images/image001-1660689528.jpg?crop=1.00xw:0.891xh;0,0.0302xh&resize=1200:*",
            title: "Acura ARX-06",
            description: "The Acura ARX-06 is an IMSA-spec endurance prototype featuring a hybrid powertrain and aggressive aerodynamics.",
            specs: ["Power": "670 HP", "Top Speed": "325 km/h", "0-100 km/h": "3.0s", "Weight": "1040 kg"],
            isPremium: false),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Endurance-Racing/2022-BMW-M-Hybrid-V8-001-1080.jpg",
            title: "BMW M Hybrid V8",
            description: "BMW's M Hybrid V8 is designed for the WEC and IMSA series, combining hybrid power with striking looks.",
            specs: ["Power": "670 HP", "Top Speed": "330 km/h", "0-100 km/h": "2.9s", "Weight": "1030 kg"],
            isPremium: true),
        Car(url: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/2024_6_Hours_of_Spa-Francorchamps_Isotta_Fraschini_Isotta_Fraschini_Tipo_6_LMH_Competizione_No.11_%28DSC02256%29.jpg/500px-2024_6_Hours_of_Spa-Francorchamps_Isotta_Fraschini_Isotta_Fraschini_Tipo_6_LMH_Competizione_No.11_%28DSC02256%29.jpg",
            title: "Isotta Fraschini Tipo 6",
            description: "The Tipo 6 is a niche Le Mans Hypercar from Isotta Fraschini, reviving a legendary Italian brand.",
            specs: ["Power": "680 HP", "Top Speed": "325 km/h", "0-100 km/h": "3.0s", "Weight": "1030 kg"],
            isPremium: false),
        Car(url: "https://www.turbo.fr/sites/default/files/styles/header_image/public/2023-06/alpine%20a424-1.jpg.webp?itok=uUkLkB7J",
            title: "Alpine A424",
            description: "Alpine's A424 is the brand’s Hypercar entry to the WEC, showcasing French engineering at Le Mans.",
            specs: ["Power": "670 HP", "Top Speed": "330 km/h", "0-100 km/h": "2.9s", "Weight": "1030 kg"],
            isPremium: true)
    ]

    let horizontalImages: [Car] = [
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Scuderia-Ferrari/2025-Formula1-Ferrari-SF-25-002-1080.jpg",
            title: "Ferrari SF-25",
            description: "The Ferrari SF-25 is Ferrari's 2025 F1 car, featuring advanced aerodynamics and hybrid power unit.",
            specs: ["Power": "1000+ HP", "Top Speed": "370 km/h", "0-100 km/h": "2.6s", "Weight": "798 kg"],
            isPremium: true),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/McLaren/2024-Formula1-McLaren-MCL38-001-1080.jpg",
            title: "McLaren MCL38",
            description: "McLaren's 2024 Formula 1 car with iconic papaya livery and competitive performance.",
            specs: ["Power": "1000+ HP", "Top Speed": "365 km/h", "0-100 km/h": "2.7s", "Weight": "798 kg"],
            isPremium: false),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Williams/2025-Formula1-Williams-FW47-001-1080.jpg",
            title: "Williams FW47",
            description: "Williams’ 2025 F1 car, built to compete with cutting-edge performance.",
            specs: ["Power": "1000+ HP", "Top Speed": "360 km/h", "0-100 km/h": "2.8s", "Weight": "798 kg"],
            isPremium: true),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Red-Bull-Racing/2025-Formula1-Red-Bull-Racing-RB21-002-1080.jpg",
            title: "Red Bull RB21",
            description: "Red Bull's 2025 title contender with advanced aerodynamics and hybrid tech.",
            specs: ["Power": "1000+ HP", "Top Speed": "370 km/h", "0-100 km/h": "2.5s", "Weight": "798 kg"],
            isPremium: true),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Mercedes/2024-Formula1-Mercedes-AMG-W15-F1-E-Performance-001-1080.jpg",
            title: "Mercedes W16",
            description: "Mercedes-AMG’s W16 brings cutting-edge hybrid innovation for 2025.",
            specs: ["Power": "1000+ HP", "Top Speed": "365 km/h", "0-100 km/h": "2.6s", "Weight": "798 kg"],
            isPremium: true),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Aston-Martin/2024-Formula1-Aston-Martin-AMR24-001-1080.jpg",
            title: "Aston Martin AMR25",
            description: "Aston Martin’s latest F1 machine with sleek green livery and great downforce.",
            specs: ["Power": "1000+ HP", "Top Speed": "360 km/h", "0-100 km/h": "2.7s", "Weight": "798 kg"],
            isPremium: false),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Alpine/2024-Formula1-Alpine-A524-001-1080.jpg",
            title: "Alpine A524",
            description: "Alpine’s 2025 Formula 1 car continues the French team’s competitive streak.",
            specs: ["Power": "1000+ HP", "Top Speed": "360 km/h", "0-100 km/h": "2.7s", "Weight": "798 kg"],
            isPremium: false),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Sauber/2025-Formula1-Sauber-C45-001-1080.jpg",
            title: "Kick Sauber C45",
            description: "Kick Sauber’s bold new look and performance ambitions for the 2025 season.",
            specs: ["Power": "1000+ HP", "Top Speed": "360 km/h", "0-100 km/h": "2.8s", "Weight": "798 kg"],
            isPremium: false),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Sauber/2024-Formula1-Sauber-C44-001-1080.jpg",
            title: "Stake Sauber C44",
            description: "The C44 from Stake Sauber features unique livery and refined aerodynamics for 2024.",
            specs: ["Power": "1000+ HP", "Top Speed": "360 km/h", "0-100 km/h": "2.8s", "Weight": "798 kg"],
            isPremium: false),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/AlphaTauri/2023-Formula1-AlphaTauri-AT04-001-1080.jpg",
            title: "AlphaTauri AT04",
            description: "AlphaTauri’s sleek and agile AT04 joins the 2024 F1 grid with fresh updates.",
            specs: ["Power": "1000+ HP", "Top Speed": "360 km/h", "0-100 km/h": "2.8s", "Weight": "798 kg"],
            isPremium: false)
    ]

    // Demo video URL
    let demoVideoURLString = "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"

    var body: some View {
        GeometryReader { geometry in
            let screenSize = geometry.size
            let isCompact = screenSize.width < 768 // iPhone and small devices
            let isRegular = screenSize.width >= 768 && screenSize.width < 1024 // iPad portrait
            let isLarge = screenSize.width >= 1024 // iPad landscape and larger
            
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
                            width: screenSize.width,
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
                    
                    VStack(spacing: isCompact ? 20 : 30) {
                        // Animated header
                        VStack(spacing: isCompact ? 20 : 30) {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("EXOTIC")
                                        .font(.system(size: isCompact ? 14 : isRegular ? 16 : 18, weight: .regular, design: .monospaced))
                                        .foregroundColor(accentColorAlt)
                                        .tracking(isCompact ? 3 : 5)
                                        .offset(y: animateHeader ? 0 : -20)
                                        .opacity(animateHeader ? 1 : 0)
                                    
                                    Text("CAR SHOWCASE")
                                        .font(.system(size: isCompact ? 24 : isRegular ? 32 : 36, weight: .bold, design: .monospaced))
                                        .foregroundColor(textColor)
                                        .tracking(isCompact ? 1 : 2)
                                        .shadow(color: accentColor.opacity(0.5), radius: 10, x: 0, y: 0)
                                        .offset(y: animateHeader ? 0 : -30)
                                        .opacity(animateHeader ? 1 : 0)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(isCompact ? 2 : 1)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "speedometer")
                                    .font(.system(size: isCompact ? 28 : 36))
                                    .foregroundColor(accentColor)
                                    .rotationEffect(.degrees(animateHeader ? 0 : -180))
                                    .opacity(animateHeader ? 1 : 0)
                            }
                            .padding(.top, isCompact ? 20 : 50)
                            .padding(.horizontal, isCompact ? 16 : 20)
                            .onAppear {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                    animateHeader = true
                                }
                            }
                            
                            // Premium subscription toggle
                            ZStack {
                                RoundedRectangle(cornerRadius: isCompact ? 16 : 20)
                                    .fill(cardBgColor)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: isCompact ? 16 : 20)
                                            .stroke(LinearGradient(
                                                gradient: Gradient(colors: [accentColor.opacity(0.7), accentColorAlt.opacity(0.7)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ), lineWidth: 1.5)
                                    )
                                    .shadow(color: accentColor.opacity(0.2), radius: 15, x: 0, y: 10)
                                
                                HStack(spacing: isCompact ? 12 : 15) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: isCompact ? 20 : 24))
                                        .foregroundColor(isSubscribed ? accentColorAlt : .gray)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("PREMIUM ACCESS")
                                            .font(.system(size: isCompact ? 14 : 16, weight: .semibold, design: .monospaced))
                                            .foregroundColor(textColor)
                                        
                                        Text(isSubscribed ? "Unlock exclusive content" : "Subscribe to unlock all content")
                                            .font(.system(size: isCompact ? 10 : 12, weight: .medium))
                                            .foregroundColor(textColor.opacity(0.7))
                                            .lineLimit(isCompact ? 2 : 1)
                                    }
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $isSubscribed.animation(.spring()))
                                        .labelsHidden()
                                        .toggleStyle(PremiumToggleStyle(
                                            onColor: accentColorAlt,
                                            offColor: Color.gray.opacity(0.3),
                                            size: isCompact ? .small : .normal
                                        ))
                                }
                                .padding(.horizontal, isCompact ? 16 : 20)
                                .padding(.vertical, isCompact ? 12 : 15)
                            }
                            .frame(height: isCompact ? 70 : 80)
                            .padding(.horizontal, isCompact ? 16 : 20)
                            .padding(.top, 10)
                        }
                        
                        // Vertical Carousel - Hypercars
                        horizontalCarSection(
                            title: "HYPERCARS",
                            icon: "flame.fill",
                            cars: verticalImages,
                            screenSize: screenSize,
                            isCompact: isCompact,
                            isRegular: isRegular
                        )

                                        // Vertical Layout - Formula 1 Cars
                        verticalCarSection(
                            title: "FORMULA 1",
                            icon: "flag.checkered.2.crossed",
                            cars: horizontalImages,
                            screenSize: screenSize,
                            isCompact: isCompact,
                            isRegular: isRegular
                        )
                        // Footer
                        VStack(spacing: 15) {
                            Text("POWERED BY")
                                .font(.system(size: isCompact ? 10 : 12, weight: .regular, design: .monospaced))
                                .foregroundColor(textColor.opacity(0.6))
                                .tracking(isCompact ? 3 : 5)
                            
                            Text("Hassan Mohsen Elkhatib").font(.system(size: isCompact ? 14 : 16, weight: .regular, design: .monospaced))
                                .foregroundColor(Color.red)
                                .tracking(isCompact ? 3 : 5)
                        }
                        .padding(.vertical, isCompact ? 30 : 40)
                    }
                    .padding(.bottom, isCompact ? 20 : 30)
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = -value
                }
                .blur(radius: showPlayer || showCarDetails ? 10 : 0)
                
                // --- Video Player Popup ---
                if showPlayer {
                    if useAdPlayer {
                        // Ad playback using AdWebPlayer
                        PremiumVideoPlayerView(
                            url: nil,
                            isSubscribed: isSubscribed,
                            screenSize: screenSize,
                            adContent: AdWebPlayer(), // Make sure AdWebPlayer is a SwiftUI view
                            closeAction: {
                                withAnimation(.spring()) {
                                    showPlayer = false
                                }
                            }
                        )
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                        .zIndex(1)
                    } else if let url = selectedVideoURL {
                        // Premium video playback
                        PremiumVideoPlayerView<EmptyView>(
                            url: selectedVideoURL,
                            isSubscribed: isSubscribed,
                            screenSize: screenSize,
                            adContent: nil,
                            closeAction: {
                                withAnimation(.spring()) {
                                    showPlayer = false
                                }
                            }
                        )
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                        .zIndex(1)
                    } else {
                        Text("No video available.")
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
                        screenSize: screenSize,
                        closeAction: {
                            withAnimation(.spring()) {
                                showCarDetails = false
                            }
                        },
                        playVideoAction: {
                            if isSubscribed {
                                selectedVideoURL = URL(string: demoVideoURLString)
                            }else {
                                useAdPlayer = true
                                selectedVideoURL = nil
                            }
                                    
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
    private func horizontalCarSection( // This is now VERTICAL layout
        title: String,
        icon: String,
        cars: [Car],
        screenSize: CGSize,
        isCompact: Bool,
        isRegular: Bool
    ) -> some View {
        let cardWidth: CGFloat = isCompact ? screenSize.width * 0.5 : 260
        let cardHeight: CGFloat = isCompact ? cardWidth * 1.5 : 260
        
        VStack(alignment: .leading, spacing: 15) {
            sectionHeader(title: title, icon: icon, isCompact: isCompact)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: isCompact ? 16 : 20) {
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
                                isCompact: isCompact,
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
                .padding(.horizontal, isCompact ? 16 : 20)
            }
        }
    }

       
    @ViewBuilder
    private func verticalCarSection( // This is now HORIZONTAL layout
        title: String,
        icon: String,
        cars: [Car],
        screenSize: CGSize,
        isCompact: Bool,
        isRegular: Bool
    ) -> some View {
        let cardWidth: CGFloat = isCompact ? screenSize.width * 1 : 260
        let cardHeight: CGFloat = isCompact ? cardWidth * 0.5 : 260
        
        VStack(alignment: .leading, spacing: 15) {
            sectionHeader(title: title, icon: icon, isCompact: isCompact)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: isCompact ? 16 : 20) {
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
                                isCompact: isCompact,
                                action: {
                                    selectedCar = car
                                    withAnimation(.spring()) {
                                        showCarDetails = true
                                    }
                                }
                            )    .contentShape(Rectangle()) // Ensures full area is tappable

                        }
                    }
                }
                .padding(.horizontal, isCompact ? 16 : 20)
            }
        }
    }

       
       private func sectionHeader(title: String, icon: String, isCompact: Bool) -> some View {
           HStack(spacing: 10) {
               Image(systemName: icon)
                   .font(.system(size: isCompact ? 16 : 18, weight: .bold))
                   .foregroundColor(accentColor)
               
               Text(title)
                   .font(.system(
                       size: isCompact ? 18 : 22,
                       weight: .bold,
                       design: .monospaced
                   ))
                   .foregroundColor(textColor)
                   .tracking(isCompact ? 1 : 2)
               
               Spacer()
           }
           .padding(.horizontal, isCompact ? 16 : 20)
           .padding(.top, 10)
       }
    @ViewBuilder
    private func carSection(
        title: String,
        icon: String,
        cars: [Car],
        screenSize: CGSize,
        isCompact: Bool,
        isRegular: Bool
    ) -> some View {
        let cardWidth: CGFloat = {
            if isCompact {
                return screenSize.width * 0.7 // 70% of screen width on phones
            } else if isRegular {
                return 220 // Fixed size for tablets
            } else {
                return 260 // Larger size for big screens
            }
        }()
        
        let cardHeight: CGFloat = {
            if isCompact {
                return cardWidth * 0.75 // Maintain aspect ratio
            } else {
                return title == "HYPERCARS" ? 260 : 180
            }
        }()
        
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: isCompact ? 16 : 18, weight: .bold))
                    .foregroundColor(accentColor)
                
                Text(title)
                    .font(.system(size: isCompact ? 18 : 22, weight: .bold, design: .monospaced))
                    .foregroundColor(textColor)
                    .tracking(isCompact ? 1 : 2)
                
                Spacer()
                
            }
            .padding(.horizontal, isCompact ? 16 : 20)
            .padding(.top, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: isCompact ? 16 : 20) {
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
                                isCompact: isCompact,
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
                .padding(.horizontal, isCompact ? 16 : 20)
                .padding(.vertical, 10)
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.5), value: cars)
        }
    }
    
}

// MARK: - Supporting Views







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
