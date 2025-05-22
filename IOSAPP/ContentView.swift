import SwiftUI

struct ContentView: View {
    @AppStorage("isSubscribed") private var isSubscribed: Bool = false
    @State private var showPlayer = false
    @State private var selectedVideoURL: URL?
    @State private var animateHeader = false

    struct Car: Identifiable, Equatable {
        let id = UUID()
        let url: String
        let title: String
    }

    let verticalImages: [Car] = [
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Endurance-Racing/2025-Ferrari-499P-001-1080.jpg", title: "Ferrari 499P"),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Endurance-Racing/2024-Lamborghini-SC63-001-1080.jpg", title: "Lamborghini SC63"),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Endurance-Racing/2024-Peugeot-9X8-001-1080.jpg", title: "Peugeot 9X8")
    ]

    let horizontalImages: [Car] = [
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Scuderia-Ferrari/2025-Formula1-Ferrari-SF-25-002-1080.jpg", title: "Ferrari SF-25"),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/McLaren/2024-Formula1-McLaren-MCL38-001-1080.jpg", title: "McLaren MCL38"),
        Car(url: "https://www.wsupercars.com/wallpapers-regular/Formula-1/Williams/2025-Formula1-Williams-FW47-001-1080.jpg", title: "Williams FW47")
    ]
    
    // Demo video URL
    let demoVideoURLString = "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"

    var body: some View {
        NavigationView {
            ZStack { // Main ZStack for content and popup
                LinearGradient(colors: [.black, .gray.opacity(0.9)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        Text("🚗 Car Showcase")
                            .font(.custom("Orbitron-Regular", size: 32)) // Ensure "Orbitron-Regular" is added to your project
                            .foregroundColor(.yellow)
                            .shadow(radius: 5)
                            .padding(.top, 50)
                            .offset(y: animateHeader ? 0 : -40)
                            .opacity(animateHeader ? 1 : 0)
                            .onAppear {
                                withAnimation(.easeOut(duration: 0.8)) {
                                    animateHeader = true
                                }
                            }

                        Toggle(isOn: $isSubscribed.animation(.easeInOut)) {
                            Text("Premium Subscription")
                                .foregroundColor(.white)
                                .font(.custom("Orbitron-Regular", size: 16))
                        }
                        .padding(.horizontal)
                        .toggleStyle(SwitchToggleStyle(tint: .yellow))

                        // Vertical Carousel
                        carSection(title: "🏁 Hypercars", cars: verticalImages, cardWidth: 180, cardHeight: 260)

                        // Horizontal Carousel
                        carSection(title: "🏎 Formula 1 Cars", cars: horizontalImages, cardWidth: 260, cardHeight: 180)
                        
                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
                .blur(radius: showPlayer ? 10 : 0) // Blur background when player is shown

                // --- Video Player Popup ---
                if showPlayer {
                    // Dimmed background
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .onTapGesture { // Optional: dismiss on tap outside
                            withAnimation {
                                showPlayer = false
                            }
                        }
                        .transition(.opacity) // Animate background dimming

                    if let url = selectedVideoURL {
                        CustomVideoPlayerView(
                            url: url,
                            isSubscribed: isSubscribed,
                            closeAction: {
                                withAnimation {
                                    showPlayer = false
                                }
                            }
                        )
                        .transition(.scale.combined(with: .opacity)) // Animate popup appearance
                        .zIndex(1) // Ensure popup is on top
                    }
                }
            }
            .navigationBarHidden(true)
            .animation(.easeInOut, value: showPlayer) // Animate overall changes related to showPlayer
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Recommended for broader compatibility
    }

    @ViewBuilder
    private func carSection(title: String, cars: [Car], cardWidth: CGFloat, cardHeight: CGFloat) -> some View {
        Group {
            Text(title)
                .font(.custom("Orbitron-Regular", size: 22))
                .foregroundColor(.white)
                .padding(.top)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(cars) { car in
                        if let url = URL(string: car.url) {
                            AnimatedImageCard(
                                url: url,
                                title: car.title,
                                width: cardWidth,
                                height: cardHeight
                            ) {
                                selectedVideoURL = URL(string: demoVideoURLString)
                                withAnimation(.spring()) { // Use spring for a bouncier feel
                                    showPlayer = true
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .transition(.slide) // Example transition, adjust as needed
            .animation(.easeInOut(duration: 0.5), value: cars)
        }
    }
}
