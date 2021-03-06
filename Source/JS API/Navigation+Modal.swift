//
//  Navigation+Modal.swift
//  ELHybridWeb
//
//  Created by Angelo Di Paolo on 6/15/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import JavaScriptCore

@objc protocol ModalNavigationJSExport: JSExport {
    func presentModal(options: JSValue)
    func dismissModal()
}

extension Navigation: ModalNavigationJSExport {
    
    func presentModal(options: JSValue) {
        log(.Debug, "\(self) options:\(options)")
        dispatch_async(dispatch_get_main_queue()) {
            let vcOptions = WebViewControllerOptions(javaScriptValue: options)
            self.webViewController?.presentModalWebViewController(vcOptions)
        }
    }
    
    func dismissModal() {
        log(.Debug, "\(self)") // provide breadcrumbs
        dispatch_async(dispatch_get_main_queue()) {
            self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
