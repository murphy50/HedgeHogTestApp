//
//  WebViewController.swift
//  HedgehogTestApp
//
//  Created by murphy on 13.02.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    
    var link: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRequest()
    }
    
    private func loadRequest() {
        guard let url = URL(string: link) else { return }
        let urlRequest = URLRequest(url: url)
        DispatchQueue.main.async {
            self.webView.load(urlRequest)
        }
    }
}
