//
//  CommonWebViewController.swift
//  MiniEye
//
//  Created by user_ on 2019/6/26.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit
import WebKit

class CommonWebViewController: BasicViewController {
    
    let progressViewHeight:CGFloat = 1
    let webViewProgressObserverKey = "estimatedProgress"
    var customTitle:String? = nil {
        didSet {
            self.title = self.customTitle
        }
    }
    
    lazy var placeholderView: PlaceholderView = {
        let view = PlaceholderView.init()
        view.isHidden = true
        view.type = .reload
        view.button.addTarget(self, action:  #selector(reloadButtonAction(sender:)), for: .touchUpInside)
        return view
    }()

    @objc func reloadButtonAction(sender:UIButton) {
        placeholderView.isHidden = true
        self.webView.isHidden = false
        self.webView.load(originalRequest!)
//        self.webView.reloadFromOrigin()
    }
    
    var isShowProgressView:Bool {
        set {
            self.progressView.isHidden = !newValue
        }
        get {
            return !self.progressView.isHidden
        }
    }
    
    var url: URL? = nil {
        didSet {
            let request = URLRequest.init(url: self.url!,cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            originalRequest = request
            self.webView.load(request)
        }
    }
    
    private var originalRequest:URLRequest? = nil
    
    lazy var webView: WKWebView = {
        let info = Bundle.main.infoDictionary
        let appVersion = info!["CFBundleShortVersionString"] as! String
        let config = WKWebViewConfiguration.init()
        config.allowsInlineMediaPlayback = true
        config.applicationNameForUserAgent = "MINIEYE/\(appVersion)"
        
        let webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        
        webView.evaluateJavaScript("navigator.userAgent") { (agent, error) in
            print("user agent \(agent as? String)")
        }
        
        return webView
    }()

    lazy var progressView: BasicView = {
        let view = BasicView()
        view.backgroundColor = .clear
        view.layer.addSublayer(self.progressLayer)
        return view
    }()
    
    lazy var progressLayer:CALayer = {
        let layer = CALayer()
        layer.opacity = 0
        layer.backgroundColor = UIColor.blue.cgColor
        return layer
    }()
    
    override func configureSubviews() {
        super.configureSubviews()
        
        view.addSubview(placeholderView)
        view.addSubview(progressView)
        view.addSubview(webView)
        
        progressView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.mas_topLayoutGuideBottom)
            make?.height.equalTo()(self.progressViewHeight)
            make?.left.equalTo()(self.view)
            make?.right.equalTo()(self.view)
        }

        webView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.progressView.mas_bottom)
            make?.left.equalTo()(self.view)
            make?.right.equalTo()(self.view)
            make?.bottom.equalTo()(self.mas_bottomLayoutGuideBottom)
        }
        
        placeholderView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.view)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.isShowProgressView = false
        self.webView.addObserver(self, forKeyPath: webViewProgressObserverKey, options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftBarButton()
        addRightBarBurron()
    }
    
    func addRightBarBurron() {
        let button = UIButton.init(type: .custom)
        button.setTitle(.localized_Close, for: .normal)
        button.setTitleColor(CommonColor.subTitleColor, for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 55, height: NavigationBarH)
        button.addTarget(self, action: #selector(close(sender:)), for: .touchUpInside)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: webViewProgressObserverKey)
    }
    
    override func back(sender: UIButton) {
        if self.webView.canGoBack {
            let script = "history.go(-1)"
            self.webView.evaluateJavaScript(script) { (data, error) in
                print("back script \(script) data \(String(describing: data)) error \(String(describing: error))")
            }

        } else {
            super.back(sender: sender)
        }
    }
    
    @objc func close(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath != nil && keyPath == webViewProgressObserverKey else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard self != nil else {
                return
            }
            
            let progress = self!.webView.estimatedProgress
            self?.progressLayer.opacity = 1
            var frame:CGRect = self!.progressView.bounds
            frame.size.width = frame.width * CGFloat(progress)
            self?.progressLayer.frame = frame
            if progress >= 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self?.progressLayer.opacity = 0
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                    self?.progressLayer.frame = CGRect(x: 0, y: 0, width: 0, height: self!.progressViewHeight)
                })
            }
        }
    }
    
    
}

extension CommonWebViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print_Debug(message: "\(error)")
        self.placeholderView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print_Debug(message: "\(error)")
        self.placeholderView.isHidden = false
        self.webView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title?.isEmpty ?? true ? self.customTitle : webView.title
    }
        
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("decidePolicyFor navigationAction \(navigationAction)")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("navigationResponse \(navigationResponse)")
        decisionHandler(.allow)
    }
    
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        
        print("ios 13 decidePolicyFor navigationAction \n\(navigationAction) \npre \(preferences)")
        
        if let request = navigationAction.request as? NSMutableURLRequest {
            request.setValue("c1app.iOS", forHTTPHeaderField: "MINIEYE-UA")
            let url = request.url
            print("url \(url?.scheme) \(url?.host) \(url?.path) \(url?.query)")
        }
        
        print(navigationAction.request)

        decisionHandler(.allow, preferences)
    }
    
    func allowNavigationAction(_ navigationAction: WKNavigationAction) -> Bool {
        
        if let request = navigationAction.request as? NSMutableURLRequest {
            request.setValue("c1app.iOS", forHTTPHeaderField: "MINIEYE-UA")
            let url = request.url
            
            print("schme \(url?.scheme) \(url?.path) \(url?.query)")
        }
        
        return true
    }

    
}

extension CommonWebViewController:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    
}

extension CommonWebViewController:WKUIDelegate {
    
    //打开新窗口
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if !(navigationAction.targetFrame?.isMainFrame ?? false) {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        CommonAlertController.common_presentAlertSingularConfirmOnScreen(animated: true, title: message, message: nil, confirmTitle: .localized_Confirm, confirmHandler: { (action) in
            completionHandler()
        }, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let cancelActionInfo:CommonAlertController.actionInfo = CommonAlertController.actionInfo.init(title:.localized_Cancel,style:UIAlertAction.Style.cancel,handler: {(_ action:UIAlertAction)in
            completionHandler(false)
        })
        let confirmActionInfo:CommonAlertController.actionInfo = CommonAlertController.actionInfo.init(title:.localized_Confirm,style:UIAlertAction.Style.default,handler: {(_ action:UIAlertAction)in
            completionHandler(true)
        })
        
        CommonAlertController.common_presentAlertOnScreen(animated: true, title: message, message: nil, actionInfos: [cancelActionInfo,confirmActionInfo],completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
                
        let alert = CommonAlertController.init(title: prompt, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alert.addAction(UIAlertAction.init(title: .localized_Cancel, style: UIAlertAction.Style.cancel, handler:nil))

        alert.addAction(UIAlertAction.init(title: .localized_Confirm, style: UIAlertAction.Style.default, handler: { (action) in
            completionHandler(alert.textFields?.last?.text)
        }))
        
        lastPresentedViewController().present(alert, animated: true, completion: nil)
    }
    
}
