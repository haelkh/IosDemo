import SwiftUI
import WebKit

struct AdWebPlayer: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        if let htmlPath = Bundle.main.path(forResource: "adplayer", ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
