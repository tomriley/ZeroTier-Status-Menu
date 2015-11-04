//
//  ZeroTier.swift
//  ZerotierMenuStatus
//
//  Created by Tom on 11/3/15.
//  Copyright © 2015 smallroomsoftware. All rights reserved.
//

import Foundation

struct ZeroTier {
    static func getNetworks() -> JSON {
        return runCliCommand(["listnetworks", "-j"])
    }
    
    static func getInfo() -> JSON {
        return runCliCommand(["info", "-j"])
    }
    
    static func runCliCommand(args: [String]) -> JSON {
        let task = NSTask()
        task.launchPath = "/Library/Application Support/ZeroTier/One/zerotier-cli"
        task.arguments = args
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let json = JSON(data: data)
        return json
    }
}