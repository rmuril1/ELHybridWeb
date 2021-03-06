//
//  NavigationBar.swift
//  ELHybridWeb
//
//  Created by Angelo Di Paolo on 6/3/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import JavaScriptCore

@objc protocol NavigationBarJSExport: JSExport {
    func setTitle(title: JSValue, _ callback: JSValue?)
    func setButtons(buttonsToSet: JSValue?, _ callback: JSValue?, _ testingCallback: JSValue?)
}

@objc public class NavigationBar: ViewControllerChild {
    
    public var title: String? {
        didSet {
            parentViewController?.navigationItem.title = title
        }
    }
    private var buttons: [Int: BarButton]? {
        didSet {
            if let buttons = buttons {
                if let leftButton = buttons[0]?.barButtonItem {
                    parentViewController?.navigationItem.leftBarButtonItem = leftButton
                }
                else {
                    parentViewController?.navigationItem.leftBarButtonItem = nil
                }
                
                if let rightButton = buttons[1]?.barButtonItem {
                    parentViewController?.navigationItem.rightBarButtonItem = rightButton
                }
                else {
                    parentViewController?.navigationItem.rightBarButtonItem = nil
                }
            } else {
                parentViewController?.navigationItem.hidesBackButton = true
                parentViewController?.navigationItem.leftBarButtonItem = nil
                parentViewController?.navigationItem.rightBarButtonItem = nil
            }
        }
    }
}

extension NavigationBar: NavigationBarJSExport {
    
    func setTitle(title: JSValue, _ callback: JSValue? = nil) {
        log(.Debug, "title:\(title), callback\(callback)") // provide breadcrumbs
        dispatch_async(dispatch_get_main_queue()) {
            self.title = title.asString
            callback?.safelyCallWithArguments(nil)
        }
    }
    
    func setButtons(buttonsToSet: JSValue?, _ callback: JSValue? = nil, _ testingCallback: JSValue? = nil) {
        log(.Debug, "buttonsToSet\(buttonsToSet), callback:\(callback)") // provide breadcrumbs
        dispatch_async(dispatch_get_main_queue()) {
            self.configureButtons(buttonsToSet, callback: callback)
            testingCallback?.safelyCallWithArguments(nil) // only for testing purposes
        }
    }
    
    func configureButtons(buttonsToSet: JSValue?, callback: JSValue?) {
        log(.Debug, "buttonsToSet\(buttonsToSet), callback:\(callback)") // provide breadcrumbs
        if let buttonOptions = buttonsToSet?.toObject() as? [AnyObject] {
            buttons = BarButton.dictionaryFromJSONArray(buttonOptions, callback: callback) // must set buttons on main thread
        } else {
            buttons = nil
        }
    }
}
