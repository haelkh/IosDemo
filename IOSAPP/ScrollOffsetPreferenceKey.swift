import SwiftUI
import AVKit // Import AVKit for video playback functionality

// Custom PreferenceKey to track scroll offset in a ScrollView
struct ScrollOffsetPreferenceKey: PreferenceKey {
    // Default value when no value has been set
    static var defaultValue: CGFloat = 0
    
    // Combines multiple values into a single one
    // In this case, we just take the latest value (nextValue)
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue() // Overwrites with the newest offset value
    }
}
