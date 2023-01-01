//
//  WebView.swift
//  SuperSearch
//
//  Created by Clarke Kent on 12/31/22.
//

import UIKit
import WebKit

class WebView: UIViewController, WKNavigationDelegate, WKUIDelegate {
    var webURL : pageDefaults = .google
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupUI()

        let url = URL(string: webURL.rawValue)!

        webView.load(URLRequest(url: url))

        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: self.view.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

enum pageDefaults : String {
    case google = "https://www.google.com/"
    case youtube = "https://m.youtube.com/"
    case wiki = "https://en.m.wikipedia.org/"
    case chatBotGTP_web = "https://chat.openai.com/chat"
}
