//
//  OrarioAulaViewController.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 19/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import UIKit

class OrarioAulaViewController: UIViewController,UIWebViewDelegate {

    var url:String?
    
    @IBOutlet weak var orarioAulaWebView: UIWebView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orarioAulaWebView.delegate = self

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        indicator.startAnimating()
        orarioAulaWebView.loadRequest(URLRequest(url: URL(string: url!)!))
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
