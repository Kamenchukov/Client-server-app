//
//  WKViewController.swift
//  VkApp
//
//  Created by Константин Каменчуков on 16.07.2021.
//

import UIKit
import WebKit

class WkWebView: UIViewController {
    
    @IBOutlet weak var wkWebView: WKWebView! {
                didSet {
                    wkWebView.navigationDelegate = self
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorize()
        
    }
    
    func authorize() {
        var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "oauth.vk.com"
                urlComponents.path = "/authorize"
                urlComponents.queryItems = [
                    URLQueryItem(name: "client_id", value: "7904602"),
                    URLQueryItem(name: "display", value: "mobile"),
                    URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                    URLQueryItem(name: "scope", value: "262150"),
                    URLQueryItem(name: "response_type", value: "token"),
                    URLQueryItem(name: "v", value: "5.68")
                ]
                
                let request = URLRequest(url: urlComponents.url!)
                
                wkWebView.load(request)
    }
    

}
extension WkWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
       guard let token = params["access_token"], let userId = params["user_id"] else { return }
        
        print(token)
        MySession.shared.token = token
        MySession.shared.userId = Int(userId)
        
        showFriendsVC()
        
        decisionHandler(.cancel)
    }
    func showFriendsVC() {
        
        performSegue(withIdentifier: "showFriendsSegue", sender: nil)
    }
}
