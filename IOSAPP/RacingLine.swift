import SwiftUI
import AVKit // (Note: AVKit imported but not used in this code)

// A custom SwiftUI View that draws a diagonal dashed line
struct RacingLine: View {
    // Configuration properties:
    let width: CGFloat    // Width of the line (horizontal extent)
    let offset: CGFloat   // Starting vertical offset (y-position)
    let color: Color      // Color of the line
    
    var body: some View {
        // Create a Path to define the line shape
        Path { path in
            // Start drawing from the left edge (x:0) at the specified offset (y:offset)
            path.move(to: CGPoint(x: 0, y: offset))
            
            // Draw a line diagonally down to the right edge (x:width),
            // ending 100 points lower than it started (y:offset + 100)
            path.addLine(to: CGPoint(x: width, y: offset + 100))
        }
        // Style the line:
        .stroke(style: StrokeStyle(
            lineWidth: 2,      // 2-point thick line
            dash: [10, 10]     // Dashed pattern: 10 points on, 10 points off
        ))
        .foregroundColor(color) // Apply the specified color
    }
}
