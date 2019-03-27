//
//  LoginViewController.swift
//  BeaconDetectorAPP
//
//  Created by Maria Laura Bisogno.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class LoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate{
    let baseurl = "http://ingegneria.tirocini.unisa.it/"
    var webView: WKWebView!
    var infos = [String:String]()
    @IBOutlet weak var wView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = baseurl+"secure/test.php"
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: wView.bounds, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.wView.addSubview(webView)
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    //Delegate per gestire la risposta
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let control = baseurl+"secure/test.php"
        if(webView.url?.absoluteString == control){
            webView.isHidden = true
            webView.evaluateJavaScript("document.getElementsByTagName('body')[0].innerHTML") { innerHTML, error in
                self.manageInfo(info: innerHTML as! String)
            }
        }
    }
    
    //Funzione per gestire la risposta del server. Si è scelto di catturare soltanto le informazioni riguardanti l'utente.
    func manageInfo(info: String){
        var count = 13
        var rows = info.split(separator: "\n")
        while count < 27{
            rows[count] = rows[count].split(separator: "\"")[1].split(separator: "\"")[0]
            count += 1
        }
        
        count = 13
        while count < 27{
            infos[rows[count].description] = rows[count+1].description
            count += 2
        }
        print("\n-------INFO-------")
        print(infos)
        //self.performSegue(withIdentifier: "showFirstProfile", sender: nil)
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            viewController.info = infos
            viewController.firstTime = true
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.destination is ProfileViewController
        {
            let vc = segue.destination as? ProfileViewController
            vc?.info = infos
        }
    }*/
    
}
