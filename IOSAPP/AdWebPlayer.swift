import SwiftUI
import WebKit

// A SwiftUI wrapper for displaying a local HTML ad using WKWebView
struct AdWebPlayer: UIViewRepresentable {
    
    // Creates and configures the WKWebView instance
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        // Load local "adplayer.html" file from the app bundle
        if let htmlPath = Bundle.main.path(forResource: "adplayer", ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(url, allowingReadAccessTo: url) // Grant access to the file path
        }
        
        return webView
    }

    // Called when the SwiftUI view updates (not used here)
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
