//
//  WebQueryView.swift
//  SuperSearch
//
//  Created by Clarke Kent on 1/1/23.
//

import Foundation
import UIKit
import WebKit

class WebQueryView : UIViewController, WKNavigationDelegate, WKUIDelegate {
    var webURL : queryDefaults = .google
    var QueryParameters : String = ""
    
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
        let queryURL : String = "\(webURL.rawValue)\(QueryParameters.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)"
        print(queryURL)
        let url = URL(string: queryURL)!

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

enum queryDefaults : String {
    case google = "https://www.google.com/search?q="
    case youtube = "https://www.youtube.com/results?search_query="
//    case wiki = "https://en.m.wikipedia.org/"
}

// "https://www.youtube.com/results?search_query=\(query)"
// "https://www.google.com/search?q=\(query)"


// How do you pop the current view controller off of the navigation stack?
