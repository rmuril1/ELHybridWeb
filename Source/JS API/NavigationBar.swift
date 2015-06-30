//
//  NavigationBar.swift
//  THGHybridWeb
//
//  Created by Angelo Di Paolo on 6/3/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import JavaScriptCore

@objc protocol NavigationBarJSExport: JSExport {
    func setTitle(title: String)
    func setButtons(buttonsToSet: AnyObject?, _ callback: JSValue?)
}

@objc public class NavigationBar: ViewControllerChild {
    
    private var callback: JSValue?
    private var buttons: [Int: BarButton]? {
        didSet {
            if let buttons = buttons {
                if let leftButton = buttons[0]?.barButtonItem {
                    parentViewController?.navigationItem.leftBarButtonItem = leftButton
                }
                
                if let rightButton = buttons[1]?.barButtonItem {
                    parentViewController?.navigationItem.rightBarButtonItem = rightButton
                }
            } else {
                parentViewController?.navigationItem.leftBarButtonItem = nil
                parentViewController?.navigationItem.rightBarButtonItem = nil
            }
        }
    }
}

extension NavigationBar: NavigationBarJSExport {
    
    func setTitle(title: String) {
        dispatch_async(dispatch_get_main_queue()) {
            parentViewController?.navigationItem.title = title
        }
    }
    
    func setButtons(options: AnyObject?, _ callback: JSValue? = nil) {
        self.callback = callback

        dispatch_async(dispatch_get_main_queue()) {
            
            if let buttonsToSet = options as? [[String: AnyObject]],
                let callback = callback
                where buttonsToSet.count > 0 {
                    self.buttons = BarButton.dictionaryFromJSONArray(buttonsToSet, callback: callback) // must set buttons on main thread
            } else {
                self.buttons = nil
            }
        }
    }
}