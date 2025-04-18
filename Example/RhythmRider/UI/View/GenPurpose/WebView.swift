import SwiftUI
import WebKit

typealias WKDidFinishLoadHandler = (_ webview: WKWebView, _ navigation: WKNavigation) -> Void
typealias WKDecidePolicyNavigationHandler = (_ webview: WKWebView, _ navigationResponse: WKNavigationResponse, _ decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) -> Void

struct WebView {
    
    let url: URL
    let didFinishLoadHandler: WKDidFinishLoadHandler?
    let decidePolicyNavigationHandler: WKDecidePolicyNavigationHandler?
    
    init(url: URL, didFinishLoadHandler: WKDidFinishLoadHandler? = nil, decidePolicyNavigationHandler: WKDecidePolicyNavigationHandler? = nil) {
        self.url = url
        self.didFinishLoadHandler = didFinishLoadHandler
        self.decidePolicyNavigationHandler = decidePolicyNavigationHandler
    }
    
    func makeCoordinator() -> WebView.Coordinator {
        return Coordinator(didFinishLoadHandler: didFinishLoadHandler, decidePolicyNavigationHandler: decidePolicyNavigationHandler)
     }
    
    func makeWebView(context: Context) -> WKWebView {
        let wkWebView = WKWebView()
        wkWebView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        wkWebView.load(request)
        return wkWebView
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        let didFinishLoadHandler: WKDidFinishLoadHandler?
        let decidePolicyNavigationHandler: WKDecidePolicyNavigationHandler?
      
        init(didFinishLoadHandler: WKDidFinishLoadHandler? = nil, decidePolicyNavigationHandler: WKDecidePolicyNavigationHandler? = nil) {
            self.didFinishLoadHandler = didFinishLoadHandler
            self.decidePolicyNavigationHandler = decidePolicyNavigationHandler
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let safeDidFinishLoadHandler = didFinishLoadHandler else {return}
            safeDidFinishLoadHandler(webView, navigation)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            guard let safeDecidePolicyNavigationHandler = decidePolicyNavigationHandler else {
                decisionHandler(.allow)
                return
            }
            safeDecidePolicyNavigationHandler(webView, navigationResponse, decisionHandler)
        }
    }
}

//MARK: - extensions
#if os(macOS)
extension WebView: NSViewRepresentable {
    func makeNSView(context: Context) -> WKWebView {
        makeWebView(context: context)
    }
    func updateNSView(_ nsView: WKWebView, context: Context) {
        
    }
}
#else
extension WebView: UIViewRepresentable {

     func makeUIView(context: Context) -> WKWebView {
         makeWebView(context: context)
     }
    
     func updateUIView(_ uiView: WKWebView, context: Context) {
     }
}
#endif

#Preview(body: {
    WebView(url: URL(string: "https://google.com")!) { webview, navigation in
        guard let safeWebviewUrl = webview.url else {
            print("No loaded page")
            return
        }
        print("Visited page \(safeWebviewUrl.absoluteString)")
    }
})
