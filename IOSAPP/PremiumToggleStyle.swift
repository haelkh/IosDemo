import SwiftUI
import AVKit  // Import AVKit (though not used in this code)

// Custom ToggleStyle for creating premium-looking toggle switches
struct PremiumToggleStyle: ToggleStyle {
    // Customization options
    var onColor: Color       // Color when toggle is ON
    var offColor: Color      // Color when toggle is OFF
    var size: ToggleSize = .normal  // Size variant (small or normal)
    
    // Enum to define different size options
    enum ToggleSize {
        case small, normal
        
        // Width of the toggle track
        var width: CGFloat {
            switch self {
            case .small: return 44
            case .normal: return 50
            }
        }
        
        // Height of the toggle track
        var height: CGFloat {
            switch self {
            case .small: return 26
            case .normal: return 30
            }
        }
        
        // Size of the thumb circle
        var circleSize: CGFloat {
            switch self {
            case .small: return 20
            case .normal: return 24
            }
        }
        
        // Offset for the thumb circle position
        var offset: CGFloat {
            switch self {
            case .small: return 8
            case .normal: return 10
            }
        }
    }
    
    // Creates the view for the toggle
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label  // The label provided with the toggle
            
            // The actual toggle switch
            ZStack {
                // Background capsule (track)
                Capsule()
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: size.width, height: size.height)
                    .shadow(color: configuration.isOn ? onColor.opacity(0.5) : Color.black.opacity(0.1), radius: 8)
                
                // Thumb circle
                Circle()
                    .fill(Color.white)
                    .shadow(radius: 1)
                    .frame(width: size.circleSize, height: size.circleSize)
                    .offset(x: configuration.isOn ? size.offset : -size.offset)
            }
            // Tap gesture to toggle state with animation
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}
