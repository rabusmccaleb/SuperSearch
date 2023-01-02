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
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .black
        setUpBackButton()
        setupWebView()

        let url = URL(string: webURL.rawValue)!

        webView.load(URLRequest(url: url))

        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    let backButton : UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = StyleSingleton.s.fontType(fonts: .AvenirNextDemiBold, fontSize: 12)
        button.backgroundColor = .black
        return button
    }()
    
    func setUpBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupWebView() {
        webView.backgroundColor = .black
        self.view.addSubview(webView)
        //
        webView.layer.cornerRadius = 8
        webView.clipsToBounds = true
        //
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: backButton.bottomAnchor),
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
