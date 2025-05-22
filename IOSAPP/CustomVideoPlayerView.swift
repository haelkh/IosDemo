import SwiftUI
import AVKit

struct CustomVideoPlayerView: View {
    let url: URL
    let isSubscribed: Bool
    let closeAction: () -> Void
    
    var body: some View {
        ZStack {
            // Video player background
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.9))
                .shadow(color: Color.black.opacity(0.5), radius: 20)
            
            VStack(spacing: 0) {
                // Video player
                if isSubscribed {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                } else {
                    ZStack {
                        Color.black
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        
                        VStack(spacing: 15) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("Premium Content")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Subscribe to unlock this video")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                
                // Controls
                HStack {
                    Spacer()
                    
                    Button(action: closeAction) {
                        Text("Close")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Capsule())
                    }
                }
                .padding()
            }
            .padding()
        }
        .frame(width: 400, height: 350)
    }
}
