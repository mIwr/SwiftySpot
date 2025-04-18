//
//  CaptchaChallengeScreen.swift
//  RhythmRider
//
//  Created by developer on 11.04.2025.
//

import SwiftUI
import WebKit

struct CaptchaChallengeScreen: View {
    
    @Binding var presented: Bool
    @Binding var interactRef: String
    
    fileprivate let _challengeUrl: URL
    fileprivate let _callbackUrl: String
    
    init(presented: Binding<Bool>, interactRef: Binding<String>, challengeUrl: URL, callbackUrl: String) {
        _presented = presented
        _interactRef = interactRef
        _challengeUrl = challengeUrl
        _callbackUrl = callbackUrl
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            WebView(url: _challengeUrl, didFinishLoadHandler: didFinishLoad, decidePolicyNavigationHandler: decidePolicyForNavigation)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button(action: {
                presented = false
            }, label: {
                Text(R.string.localizable.generalClose())
                    .font(.headline)
                    .foregroundColor(Color(R.color.primary))
            })
            .buttonStyle(AccentWideButtonStyle())
            .padding(.horizontal, 16.0)
            .padding(.bottom)
        }
    }
    
    func didFinishLoad(_ webView: WKWebView, _ navigation: WKNavigation) {
        guard let safeUrl = webView.url, presented else {return}
        print("Load finish for \(safeUrl)")
        if (!checkCallbackUrlReach(url: safeUrl)) {
            return
        }
        if let safeurlQueryDict = safeUrl.queryDictionary(), let safeInteractRef = safeurlQueryDict["interact_ref"] {
            interactRef = safeInteractRef
        }
        presented = false
    }
    
    func decidePolicyForNavigation(_ webView: WKWebView, _ navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    fileprivate func checkCallbackUrlReach(url: URL) -> Bool {
        let urlStr = url.absoluteString
        if (!urlStr.hasPrefix(_callbackUrl)) {
            return false
        }
        return true
    }
}

#Preview {
    @State var presented = true
    @State var interactRef = ""
    CaptchaChallengeScreen(presented: $presented, interactRef: $interactRef, challengeUrl: URL(string: "https://google.com")!, callbackUrl: "https://url.com")
}
