import SwiftUI
import AVKit

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
