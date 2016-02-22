//
//  Youtube.swift
//  SurvataDemo
//
//  Created by Rex Sheng on 2/22/16.
//  Copyright © 2016 InteractiveLabs. All rights reserved.
//

import UIKit
import WebKit

class TestViewController: UIViewController {

	override func viewDidLoad() {
		let configuration = WKWebViewConfiguration()
		configuration.allowsInlineMediaPlayback = true
		let webView = WKWebView(frame: view.bounds, configuration: configuration)
		view.addSubview(webView)
		webView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
		webView.loadHTMLString("<html><body>Youtube video .. <br> <iframe webkit-playsinline width='320' height='315' src='https://www.youtube.com/embed/lY2H2ZP56K4?playsinline=1' frameborder='0'></iframe></body></html>", baseURL: NSURL(string: "https://www.survata.com"))
	}
}
