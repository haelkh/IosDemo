import SwiftUI
import AVKit

struct PremiumToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    var size: ToggleSize = .normal
    
    enum ToggleSize {
        case small, normal
        
        var width: CGFloat {
            switch self {
            case .small: return 44
            case .normal: return 50
            }
        }
        
        var height: CGFloat {
            switch self {
            case .small: return 26
            case .normal: return 30
            }
        }
        
        var circleSize: CGFloat {
            switch self {
            case .small: return 20
            case .normal: return 24
            }
        }
        
        var offset: CGFloat {
            switch self {
            case .small: return 8
            case .normal: return 10
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            ZStack {
                Capsule()
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: size.width, height: size.height)
                    .shadow(color: configuration.isOn ? onColor.opacity(0.5) : Color.black.opacity(0.1), radius: 8)
                
                Circle()
                    .fill(Color.white)
                    .shadow(radius: 1)
                    .frame(width: size.circleSize, height: size.circleSize)
                    .offset(x: configuration.isOn ? size.offset : -size.offset)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}
