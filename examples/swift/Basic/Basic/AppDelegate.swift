//
//  AppDelegate.swift
//  Basic
//
//  Created by Lionel Rossignol on 22/03/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, INSPushDelegate {
    
    var window: UIWindow?
    var basicWebView: UIWebView?
    var basicSession: NSURLSession?
    
    //
    // MARK: Insiteo SDK
    //
    
    func startInsiteoSDK() {
        do {
            try Insiteo.start()
            // Success: register for Push delegation if I can use this service
            if INSPush.isModuleAvailable() {
                INSPush.registerPushDelegate(self)
            }
        } catch let error as NSError {
            print("Insiteo SDK start error: \(error.localizedDescription)");
        }
    }
    
    //
    // MARK: UIApplicationDelegate
    //
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Background fetch
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        // Insiteo logging
        INSLogger.setLogLevel(.Info)
        
        // Analytics debug mode
        // INSAnalytics.setDebugMode(true)
        
        do {
            // Init Insiteo SDK
            try Insiteo.initializeWithAPIKey("API-KEY")
            
            // Check if SDK has already be synchronized at least once (or you can imagine to force a synchronization
            // if the time interval since the last date is > 1 week for example)
            if Insiteo.lastSynchronizationDate() == nil {
                // Never synchronized
                Insiteo.synchronize({ (success, error) -> Void in
                    if success {
                        // Start
                        self.startInsiteoSDK()
                    } else if (error != nil) {
                        print("Insiteo SDK synchronization error: \(error.localizedDescription)");
                    }
                })
                
            } else {
                // Start
                self.startInsiteoSDK()
            }
            
        } catch let error as NSError {
            print("Insiteo SDK init error: \(error.localizedDescription)");
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //
    // MARK: Background Fetch
    //
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Note Insiteo SDK MUST be initialized first, here, +initializeWithAPIKey: is called in
        // application:didFinishLaunchingWithOptions which is called before this method.
        
        // Synchronize SDK
        Insiteo.synchronize { (success, error) -> Void in
            if success {
                completionHandler(.NewData)
            } else {
                completionHandler(.Failed)
            }
        }
    }
    
    //
    // MARK: Notifications Acknowledgements
    //
    
    // iOS 8+ only (otherwise use application:didReceiveLocalNotification: and check the application state)
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        // Let Insiteo SDK handle the notification
        INSPush.executeActionFromLocalNotification(notification)
    }
    
    //
    // MARK: INSPushDelegate
    //
    
    func shouldExecuteAction(action: INSPushAction!, triggeredBy triggerSource: INSTriggerSource) -> Bool {
        let type: INSActionType = action.type
        
        switch type {
        case .Notification:
            // Notification
            break
        case .WebView:
            // Web View with an URL as a NSString as action.content
            if let content = action.content {
                if let url = NSURL(string: content) {
                    // Create a UIWebView, always on main thread ;-)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if (self.basicWebView == nil) {
                            self.basicWebView = UIWebView(frame: UIScreen.mainScreen().bounds)
                            // Customize your webview...
                        } else {
                            self.basicWebView!.removeFromSuperview()
                        }
                        
                        // Create a Request
                        let request = NSURLRequest(URL: url)
                        self.basicWebView!.loadRequest(request)
                        self.window!.addSubview(self.basicWebView!)
                    })
                }
            }
            break
        case .Custom:
            // Example call a webservices with configuration as a JSON string in action.content
            // My action.content is a valid JSON string that looks like:
            /*
            {
            "url": "https://httpbin.org/post",
            "method": "POST",
            "content-type": "application/json",
            "body": "{ \"foo\": \"bar\" }"
            }
            */
            if let content = action.content {
                if let data = content.dataUsingEncoding(NSUTF8StringEncoding) {
                    do {
                        let resultJSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                        if let resultDictionary = resultJSON as? NSDictionary {
                            let urlString = resultDictionary["url"] as? String
                            let methodString = resultDictionary["method"] as? String
                            let contentType = resultDictionary["content-type"] as? String
                            let body = resultDictionary["body"] as? String
                            
                            if (urlString != nil && methodString != nil) {
                                if let url = NSURL(string: urlString!) {
                                    let request = NSMutableURLRequest(URL: url)
                                    request.HTTPMethod = methodString!
                                    
                                    if (contentType != nil && body != nil) {
                                        if let bodyData = body!.dataUsingEncoding(NSUTF8StringEncoding) {
                                            request.HTTPBody = bodyData
                                            request.setValue(contentType!, forHTTPHeaderField:"Content-Type")
                                        }
                                    }
                                    
                                    if self.basicSession == nil {
                                        self.basicSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                                    }
                                    let task = self.basicSession!.dataTaskWithRequest(request) { (data, response, error) in
                                        if (error == nil) {
                                            print("Custom request succeed !")
                                        } else {
                                            // Handle error
                                        }
                                    }
                                    task.resume()
                                }
                            }
                        }
                        
                        
                    } catch _ as NSError {
                        print("Custom JSON seems invalid")
                    }
                }
            }
            break
        }
        
        // Do stuff according to trigger source
        switch (triggerSource) {
        case .IBeacon:
            // iBeacon proximity
            break;
        case .IBeaconRegion:
            // iBeacon region enter / exit
            break;
        default:
            break;
        }
        
        // Specific each time
        print("Action triggered: %@", action.label);
        
        // Do stuff according to your action filters
        if let filters = action.filters {
            if (filters == "My-Filter") {
                // I don't whant to execute this really specific one
                return false;
            }
        }
        
        // Never present notification when application is active
        if action.notification != nil {
            // Check if application is active or not
            if UIApplication.sharedApplication().applicationState == .Active {
                // Disable default behavior
                return false;
            }
        }
        
        // Return true if you let the SDK executes its default behavior
        return true
    }
}

