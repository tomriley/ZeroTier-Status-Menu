//
//  AppDelegate.swift
//  ZerotierMenuStatus
//
//  Created by Tom on 11/3/15.
//  Copyright © 2015 smallroomsoftware. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
    let menu = NSMenu()
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.menu = menu
        menu.autoenablesItems = false
        updateStatus()
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateStatus", userInfo: nil, repeats: true)
    }
    
    func updateStatus() {
        let info = ZeroTier.getInfo()
        let networks = ZeroTier.getNetworks()

        menu.removeAllItems()
        
        // Add item for online/offline status
        let address = info["address"].stringValue
        let online = info["online"].boolValue
        let mitem = NSMenuItem(title: "\(address) \(online ? "ONLINE" : "OFFLINE")", action: Selector(), keyEquivalent: "")
        mitem.enabled = false
        menu.addItem(mitem)
        menu.addItem(NSMenuItem.separatorItem())
        
        var aNetworkIsOkay = false
        
        for (_, network) in networks {
            var name = network["name"].stringValue
            if name.isEmpty { name = network["nwid"].stringValue }
            
            var label = "\(name) : \(network["status"].stringValue)"
            var mitem = NSMenuItem(title: label, action: Selector(), keyEquivalent: "")
            mitem.enabled = false
            menu.addItem(mitem)
            
            let ips = network["assignedAddresses"].map { $0.1.stringValue }.joinWithSeparator(", ")
            
            label = "\(ips) (\(network["type"].stringValue))"
            mitem = NSMenuItem(title: label, action: Selector(), keyEquivalent: "")
            mitem.enabled = false
            menu.addItem(mitem)
            
            menu.addItem(NSMenuItem.separatorItem())
            
            if network["status"] == "OK" {
                aNetworkIsOkay = true
            }
        }
        
        if networks.count == 0 {
            let mitem = NSMenuItem(title: "No Networks Joined", action: Selector(), keyEquivalent: "")
            mitem.enabled = false
            menu.addItem(mitem)
            menu.addItem(NSMenuItem.separatorItem())
        }
        
        // Insert code here to initialize your application
        if let button = statusItem.button {
            if online && aNetworkIsOkay {
                button.image = NSImage(named: "StatusBarButtonImage")
            } else {
                button.image = NSImage(named: "StatusBarButtonImageDisabled")
            }
        }
        
        menu.addItem(NSMenuItem(title: "Quit ZeroTier Status Menu", action: Selector("terminate:"), keyEquivalent: "q"))
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

