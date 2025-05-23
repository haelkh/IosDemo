import SwiftUI
import AVKit

struct PremiumVideoPlayerView<AdContent: View>: View {
    let url: URL?
    let isSubscribed: Bool
    let screenSize: CGSize
    let adContent: AdContent?
    let closeAction: () -> Void

    @State private var isPlaying = true
    @State private var volume: Float = 0.8
    @State private var showFullScreen = false

    private var isCompact: Bool { screenSize.width < 768 }
    private var playerWidth: CGFloat {
        isCompact ? screenSize.width * 0.9 : min(500, screenSize.width * 0.8)
    }
    private var playerHeight: CGFloat {
        isCompact ? screenSize.height * 0.7 : 450
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: isCompact ? 16 : 20)
                .fill(Color(hex: "1E1E28"))
                .shadow(color: Color.black.opacity(0.5), radius: 30)

            VStack(spacing: 0) {
                // Video or Ad
                Group {
                    if let adContent = adContent {
                        adContent
                    } else if let url = url {
                        VideoPlayer(player: AVPlayer(url: url))
                            .onAppear {
                                AVPlayer(url: url).play()
                            }
                    } else {
                        Color.black.overlay(Text("No Content").foregroundColor(.white))
                    }
                }
                .frame(height: isCompact ? 200 : 300)
                .clipShape(RoundedRectangle(cornerRadius: isCompact ? 16 : 20))
                .overlay(
                    RoundedRectangle(cornerRadius: isCompact ? 16 : 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

                // Controls
                VStack(spacing: isCompact ? 16 : 20) {
                    // Header
                    HStack {
                        Text("VIDEO PREVIEW")
                            .font(.system(size: isCompact ? 16 : 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        Spacer()
                        // Full Screen Button
                        if adContent == nil && url != nil {
                            Button(action: {
                                showFullScreen.toggle()
                            }) {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .font(.system(size: isCompact ? 14 : 16, weight: .bold))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(8)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                        // Close Button
                        Button(action: closeAction) {
                            Image(systemName: "xmark")
                                .font(.system(size: isCompact ? 14 : 16, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }

                    // Playback controls
                    if adContent == nil {
                        HStack(spacing: isCompact ? 20 : 30) {
                            Button(action: {}) {
                                Image(systemName: "backward.fill")
                                    .font(.system(size: isCompact ? 18 : 20))
                                    .foregroundColor(.white)
                            }
                            Button(action: { isPlaying.toggle() }) {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: isCompact ? 20 : 24))
                                    .foregroundColor(.white)
                                    .frame(width: isCompact ? 44 : 50, height: isCompact ? 44 : 50)
                                    .background(Color(hex: "FF3B30"))
                                    .clipShape(Circle())
                            }
                            Button(action: {}) {
                                Image(systemName: "forward.fill")
                                    .font(.system(size: isCompact ? 18 : 20))
                                    .foregroundColor(.white)
                            }
                        }

                        HStack(spacing: 15) {
                            Image(systemName: "speaker.wave.1.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: isCompact ? 14 : 16))
                            Slider(value: $volume, in: 0...1)
                                .accentColor(Color(hex: "FF3B30"))
                            Image(systemName: "speaker.wave.3.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: isCompact ? 14 : 16))
                        }
                    }
                }
                .padding(isCompact ? 16 : 20)
            }
        }
        .frame(width: playerWidth, height: playerHeight)
        .fullScreenCover(isPresented: $showFullScreen) {
            if let url = url {
                FullScreenVideoPlayer(url: url) {
                    showFullScreen = false
                }
            }
        }
    }
}

// MARK: - FullScreenVideoPlayer

struct FullScreenVideoPlayer: View {
    let url: URL
    let onClose: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VideoPlayer(player: AVPlayer(url: url))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    AVPlayer(url: url).play()
                }

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
                    .padding()
            }
        }
    }
}
