//
//  DNDBeyondDataSource.swift
//  Slaad
//
//  Created by PJ Gray on 5/1/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DNDBeyondDataSource : WebViewDelegate {

    var url : URL?
    var successBlock : ((_ character:PlayerCharacter) -> Void)?
    var failureBlack : ((_ error: Error?) -> Void)?
    var webViewController : WebViewController?

    func getCharacter(with url:URL, success: ((_ character:PlayerCharacter) -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
        self.url = url
        self.successBlock = success
        self.failureBlack = failure
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 403 {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
                            self.webViewController = vc
                            vc.delegate = self
                            vc.modalPresentationStyle = .formSheet
                            (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.visibleViewController?.present(vc, animated: true)
                        }
                    }
                } else {
                    do {
                        if let data = data {
                            let decoder = JSONDecoder()
                            struct DNDBeyondResponse: Decodable {
                                var character: PlayerCharacter
                            }
                            let dndBeyondResponse = try decoder.decode(DNDBeyondResponse.self, from: data)
                            dndBeyondResponse.character.externalLink = url
                            success?(dndBeyondResponse.character)
                        } else {
                            failure?(NSError(domain: "Error decoding PC", code: -999, userInfo: nil))
                        }
                    } catch let error {
                        failure?(error)
                    }
                }
            }
        })
        task.resume()
    }
    
    // MARK: WebViewDelegate
    
    func loggedInWebView() {
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
            HTTPCookieStorage.shared.setCookies(cookies, for: self.url, mainDocumentURL: nil)
            UserDefaults.standard.set(true, forKey: "DNDBeyondLogin")
            UserDefaults.standard.synchronize()
            self.getCharacter(with: self.url!, success: self.successBlock, failure: self.failureBlack)
        }
    }
}
