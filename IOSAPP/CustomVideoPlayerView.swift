import SwiftUI
import AVKit

struct CustomVideoPlayerView: View {
    let url: URL
    let isSubscribed: Bool
    let closeAction: () -> Void // Action to close the popup

    @State private var player: AVPlayer?
    @State private var playerItemStatusObserver: NSKeyValueObservation?
    @State private var isPlaying = false
    @State private var progress: Float = 0
    @State private var timeObserver: Any?
    @State private var showControls = true
    @State private var showLoading = true // Show loading indicator initially
    @State private var showPlaybackError = false

    // Timer to auto-hide controls
    @State private var controlsTimer: Timer?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Video Player Area
                ZStack {
                    if let player = player {
                        VideoPlayer(player: player)
                            .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)) { _ in
                                self.isPlaying = false
                                self.player?.seek(to: .zero) // Rewind to beginning
                                self.progress = 0
                                withAnimation { self.showControls = true }
                            }
                            .overlay(
                                playPauseOverlay
                            )
                            .onTapGesture {
                                withAnimation {
                                    showControls.toggle()
                                }
                                resetControlsTimer()
                            }
                    }

                    if showLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                    }
                    
                    if showPlaybackError {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                            Text("Error loading video")
                                .foregroundColor(.white)
                        }
                    }

                    // Close button
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: closeAction) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding()
                            }
                        }
                        Spacer()
                    }
                    .opacity(showControls ? 1 : 0)

                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.85)

                // Controls Area
                if showControls {
                    playerControls()
                        .frame(height: geometry.size.height * 0.15)
                        .background(Color.black.opacity(0.7))
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(16/9, contentMode: .fit)
        .frame(maxWidth: 600, maxHeight: 400)
        .background(Color.black)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
        .onAppear {
            setupPlayer()
            resetControlsTimer()
        }
        .onDisappear(perform: cleanupPlayer)
    }

    @ViewBuilder
    private var playPauseOverlay: some View {
        if showControls && !showLoading && !showPlaybackError {
             Button(action: {
                togglePlayPause()
                resetControlsTimer()
            }) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.8))
            }
            .transition(.opacity)
        }
    }
    
    @ViewBuilder
    private func playerControls() -> some View {
        VStack(spacing: 5) {
            Slider(value: $progress, in: 0...1, onEditingChanged: sliderEditingChanged)
                .accentColor(.yellow)
                .padding(.horizontal)

            HStack {
                Button(action: {
                    togglePlayPause()
                    resetControlsTimer()
                }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding(.leading)
                Spacer()
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 5)
        }
    }

    private func setupPlayer() {
        showLoading = true
        showPlaybackError = false
        if !isSubscribed {
            print("User is not subscribed - ads would be shown here or content limited.")
        }

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // Observe player item status
        playerItemStatusObserver = playerItem.observe(\.status, options: [.new, .initial]) { item, _ in
            // 'self' is captured by value here, which is fine for structs.
            DispatchQueue.main.async {
                switch item.status {
                case .readyToPlay:
                    self.showLoading = false
                    self.player?.play()
                    self.isPlaying = true
                    self.resetControlsTimer()
                case .failed:
                    self.showLoading = false
                    self.showPlaybackError = true
                    print("Player item failed to load: \(item.error?.localizedDescription ?? "Unknown error")")
                case .unknown:
                    self.showLoading = true
                @unknown default:
                    self.showLoading = true
                }
            }
        }

        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
                                                      queue: .main) { time in
            // 'self' is captured by value here.
            guard let duration = self.player?.currentItem?.duration, duration.seconds > 0 else { return }
            if !duration.isIndefinite {
                 self.progress = Float(time.seconds / duration.seconds)
            }
        }
    }

    private func cleanupPlayer() {
        player?.pause()
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        playerItemStatusObserver?.invalidate()
        playerItemStatusObserver = nil
        player = nil
        controlsTimer?.invalidate()
        controlsTimer = nil
    }

    private func togglePlayPause() {
        guard let player = player, !showLoading, !showPlaybackError else { return }

        if isPlaying {
            player.pause()
        } else {
            if progress >= 1.0 {
                player.seek(to: .zero) { _ in player.play() }
            } else {
                player.play()
            }
        }
        isPlaying.toggle()
        if isPlaying {
            resetControlsTimer()
        } else {
            controlsTimer?.invalidate()
            withAnimation { showControls = true }
        }
    }
    
    private func sliderEditingChanged(editing: Bool) {
        guard let player = player, let duration = player.currentItem?.duration else { return }
        
        if editing {
            controlsTimer?.invalidate()
            player.pause()
        } else {
            let targetTime = CMTime(seconds: duration.seconds * Double(progress), preferredTimescale: 600)
            player.seek(to: targetTime) { _ in // 'self' captured by value in this completion
                if self.isPlaying == true { // Use self.isPlaying directly
                    player.play()
                }
            }
            resetControlsTimer()
        }
    }

    private func resetControlsTimer() {
        controlsTimer?.invalidate()
        if isPlaying {
            controlsTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                // 'self' captured by value
                withAnimation {
                    self.showControls = false
                }
            }
        }
    }
}
