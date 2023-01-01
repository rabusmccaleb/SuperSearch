//
//  ViewController.swift
//  SuperSearch
//
//  Created by Clarke Kent on 12/31/22.
//

import UIKit
import OpenAISwift


class ViewController: UIViewController, UITextFieldDelegate {
    let appTitle : UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.numberOfLines = 5
        return label
    }()
    
    let textFeild : UITextField = {
        var textFeild = UITextField()
        return textFeild
    }()
    
    let superSearch : UIButton = {
        var button = UIButton()
        button.setTitle("Search", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        let safeArea = self.view.safeAreaLayoutGuide
        appTitle.text = AppConstants.s.appName
        appTitle.font = StyleSingleton.s.fontType(fonts: .AvenirNextBold, fontSize: 17)
        appTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(appTitle)
        appTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        appTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20).isActive = true
        
        //textFeild
        textFeild.font = StyleSingleton.s.fontType(fonts: .AvenirNextBold, fontSize: 17)
        textFeild.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textFeild)
        textFeild.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        textFeild.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: 40).isActive = true
        textFeild.placeholder = "Search..."
        
        superSearch.titleLabel?.font = StyleSingleton.s.fontType(fonts: .AvenirNextBold, fontSize: 20)
        superSearch.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(superSearch)
        superSearch.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        superSearch.topAnchor.constraint(equalTo: textFeild.bottomAnchor, constant: 20).isActive = true
        superSearch.setTitleColor(.white, for: .normal)
        
        //Adding Cards
        setUpImageCards()
        
        // List of all the static fonts
        StyleSingleton.s.getListOfAllAvailbleFonts()
        // Google, YouTube, Wiki,Chat GTP,
        SetUpButtons(
            button: Google,
            title: "Google",
            color: UIColor(red: 0.30, green: 0.55, blue: 0.96, alpha: 1.00), nil)
        Google.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 80).isActive = true
        
        SetUpButtons(
            button: YouTube,
            title: "YouTube",
            color: UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00), nil)
        YouTube.topAnchor.constraint(equalTo: Google.bottomAnchor, constant: 20).isActive = true
        //
        SetUpButtons(
            button: Wiki,
            title: "Wikipedia",
            color: .white, .black)
        //
        Wiki.topAnchor.constraint(equalTo: YouTube.bottomAnchor, constant: 20).isActive = true
        SetUpButtons(button: ChatGTP,
                     title: "Chat GTP3",
                     color: UIColor(red: 0.05, green: 0.64, blue: 0.50, alpha: 1.00), nil)
        ChatGTP.topAnchor.constraint(equalTo: Wiki.bottomAnchor, constant: 20).isActive = true
        
        //
        AddTargets()
        superSearch.addTarget(self, action: #selector(search), for: .touchUpInside)
    }
    
    // Query Buttons :
    var searchQuery : String = ""
    var chatGTPContentText : String = ""
    let googleImageCard : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "google")
        return image
    }()
    
    let youtubeImageCard : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "youtube")
        return image
    }()
    
    let ChatBotGTPImageCard : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "chat")
        return image
    }()
    
    func setUpImageCards() {
        // Adding the image cards
        let cardSpacing : CGFloat = 12
        styleCards(imageCard: googleImageCard, cardSpacing : cardSpacing)
        styleCards(imageCard: youtubeImageCard, cardSpacing : cardSpacing)
        styleCards(imageCard: ChatBotGTPImageCard, cardSpacing : cardSpacing)
        // Positioning the Image Cards Horizontally
        youtubeImageCard.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleImageCard.trailingAnchor.constraint(equalTo: youtubeImageCard.leadingAnchor, constant: -cardSpacing).isActive = true
        ChatBotGTPImageCard.leadingAnchor.constraint(equalTo: youtubeImageCard.trailingAnchor, constant: cardSpacing).isActive = true
        // Adding the needed targets to allow the image cards to be clicked
        addSuperQueryTargets()
        
    }
    
    func styleCards(imageCard : UIImageView, cardSpacing : CGFloat) {
        let padding : CGFloat = cardSpacing * 6
        let dimensions = ( ( UIScreen.main.bounds.width - 100 - padding ) * 0.333 )
        let mobileButtonSize : CGFloat = 67.0
        let widthHeight : CGFloat = CGFloat(abs(mobileButtonSize))
        print("card height : \(dimensions)")
        //
        imageCard.layer.cornerRadius = 20
        imageCard.clipsToBounds = true
        imageCard.backgroundColor = .white
        imageCard.contentMode = .scaleAspectFill
        //
        imageCard.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageCard)
        imageCard.topAnchor.constraint(equalTo: superSearch.bottomAnchor, constant: 20).isActive = true
        imageCard.heightAnchor.constraint(equalToConstant: widthHeight).isActive = true
        imageCard.widthAnchor.constraint(equalToConstant: widthHeight).isActive = true
        //
        imageCard.isHidden = true
        imageCard.layer.opacity = 0.0
    }
    
    func addSuperQueryTargets() {
        // Google
        let googleGesture = UITapGestureRecognizer(target: self, action: #selector(googleSuperQuery))
        googleImageCard.isUserInteractionEnabled = true
        googleImageCard.addGestureRecognizer(googleGesture)
        // Youtube
        let youtubeGesture = UITapGestureRecognizer(target: self, action: #selector(youtubeSuperQuery))
        youtubeImageCard.isUserInteractionEnabled = true
        youtubeImageCard.addGestureRecognizer(youtubeGesture)
        // Chat
        let chatGesture = UITapGestureRecognizer(target: self, action: #selector(chatSuperQuery))
        ChatBotGTPImageCard.isUserInteractionEnabled = true
        ChatBotGTPImageCard.addGestureRecognizer(chatGesture)
    }
    
    @objc func googleSuperQuery() {
        let webView = WebQueryView()
        webView.webURL = .google
        webView.QueryParameters = searchQuery
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    @objc func youtubeSuperQuery() {
        let webView = WebQueryView()
        webView.webURL = .youtube
        webView.QueryParameters = searchQuery
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    @objc func chatSuperQuery() {
        let chatView = ChatGTPTextView()
        chatView.questionText = searchQuery
        chatView.contentText = chatGTPContentText
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    
    func animateViewsOnSearch(chatGTPAvailble : Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.googleImageCard.layer.opacity = 0.0
            self.youtubeImageCard.layer.opacity = 0.0
            self.ChatBotGTPImageCard.layer.opacity = 0.0
        }, completion: {
            complete in
            // Setting these to hidden
            self.googleImageCard.isHidden = true
            self.youtubeImageCard.isHidden = true
            self.ChatBotGTPImageCard.isHidden = true
            self.showAnimations(chatGTPAvailble : chatGTPAvailble)
        })
    }
    
    func showAnimations(chatGTPAvailble : Bool) {
        // Is a chained animation that will show the cards in order from left to right
        // -> google -> youtube -> chat gtp
        self.googleImageCard.isHidden = false
        UIView.animate(withDuration: 0.15, animations: {
            self.googleImageCard.layer.opacity = 1.0
        }, completion: { complete in
            self.youtubeImageCard.isHidden = false
            UIView.animate(withDuration: 0.15, animations: {
                self.youtubeImageCard.layer.opacity = 1.0
            }, completion: { complete in
                self.ChatBotGTPImageCard.isHidden = !chatGTPAvailble
                UIView.animate(withDuration: 0.15, animations: {
                    self.ChatBotGTPImageCard.layer.opacity = 1.0
                }, completion: nil)
            })
        })
    }
    
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }
    
    @objc func search() {
        if textFeild.text != nil {
            performOpenAiSearchRequest(query: textFeild.text!)
            searchQuery = textFeild.text!
        }
    }
    
    func performOpenAiSearchRequest(query: String) {
        let openAI = OpenAISwift(authToken: AppConstants.s.OPEN_AI_API_KEY)
        openAI.sendCompletion(with: query, model: .gpt3(.davinci), maxTokens: 3999)  { result in
            //https://beta.openai.com/docs/models/gpt-3
            switch result {
            case .success(let success):
                print(success.choices)
                var chatText = success.choices.first?.text ?? ""
                self.chatGTPContentText = chatText
                DispatchQueue.main.sync {
                    self.animateViewsOnSearch(chatGTPAvailble : true)
                }
            case .failure(let failure):
                self.animateViewsOnSearch(chatGTPAvailble : false)
                print(failure.localizedDescription)
            }
        }
    }
    
    let Google : UIButton = {
        var button = UIButton()
        return button
    }()
    
    let YouTube : UIButton = {
        var button = UIButton()
        return button
    }()
    
    let Wiki : UIButton = {
        var button = UIButton()
        return button
    }()
    
    let ChatGTP : UIButton = {
        var button = UIButton()
        return button
    }()
    
    func SetUpButtons(button : UIButton, title : String, color : UIColor, _  titleColor : UIColor?) {
        let safeArea = self.view.safeAreaLayoutGuide
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(titleColor ?? .white, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = StyleSingleton.s.fontType(fonts: .AvenirNextDemiBold, fontSize: 17)!
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        //
        button.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func AddTargets() {
        Google.addTarget(self, action: #selector(googlePress), for: .touchUpInside)
        YouTube.addTarget(self, action: #selector(youtubePress), for: .touchUpInside)
        Wiki.addTarget(self, action: #selector(wikiPress), for: .touchUpInside)
        ChatGTP.addTarget(self, action: #selector(chatBotGTP_webPress), for: .touchUpInside)
    }
    
    @objc func googlePress() {
        var webView = WebView()
        webView.webURL = .google
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    @objc func youtubePress() {
        var webView = WebView()
        webView.webURL = .youtube
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    @objc func wikiPress() {
        var webView = WebView()
        webView.webURL = .wiki
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    @objc func chatBotGTP_webPress() {
        var webView = WebView()
        webView.webURL = .chatBotGTP_web
        self.navigationController?.pushViewController(webView, animated: true)
    }
}



