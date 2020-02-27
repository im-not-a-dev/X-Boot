//
//  AppDelegate.swift
//  Xiaomi Boot
//
//  Created by J P on 26/02/2020.
//  Copyright © 2020 J P. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("StatusBarImage"))
        }
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func shell(_ command: String) {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
    }
    
    @objc func win() {
        let w = "do shell script \"x=$(sudo diskutil mount $(diskutil list $(diskutil list $(df | grep -w / | awk '{split($1,z,'/'); print z[3]}') | grep 'Physical Store' | awk '{print substr($3, 1, length($3)-2)}') | grep 'EFI' | awk '{print $6}') | awk '{print substr($0, length($1)+length($2)-1, length($0))}' | sed 's|\\\\(.*\\\\) .*\\\\(.*\\\\) .*\\\\(.*\\\\) .*|\\\\1|'); mv /Volumes/${x}/EFI/MICROSOFT/BOOT/bootmgfw-orig.efi /Volumes/${x}/EFI/MICROSOFT/BOOT/bootmgfw.efi\" with administrator privileges"
        
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: w) {
            if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
                print(output.stringValue)
            } else if (error != nil) {
                print("error: \(error)")
            }
        }
    }
    
    @objc func mac() {
        let p = "do shell script \"x=$(sudo diskutil mount $(diskutil list $(diskutil list $(df | grep -w / | awk '{split($1,z,'/'); print z[3]}') | grep 'Physical Store' | awk '{print substr($3, 1, length($3)-2)}') | grep 'EFI' | awk '{print $6}') | awk '{print substr($0, length($1)+length($2)-1, length($0))}' | sed 's|\\\\(.*\\\\) .*\\\\(.*\\\\) .*\\\\(.*\\\\) .*|\\\\1|'); mv /Volumes/${x}/EFI/MICROSOFT/BOOT/bootmgfw.efi /Volumes/${x}/EFI/MICROSOFT/BOOT/bootmgfw-orig.efi\" with administrator privileges"
        
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: p) {
            if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
                print(output.stringValue)
            } else if (error != nil) {
                print("error: \(error)")
            }
        }
    }
    
    @objc func reboot() {
        let p = "tell application \"Finder\"\nshut down\nend tell"
        
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: p) {
            if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
                print(output.stringValue)
            } else if (error != nil) {
                print("error: \(error)")
            }
        }
    }
    
    func constructMenu() {
      let menu = NSMenu()

      menu.addItem(NSMenuItem(title: "Boot Windows", action: #selector(AppDelegate.win), keyEquivalent: "w"))
      menu.addItem(NSMenuItem(title: "Boot macOS", action: #selector(AppDelegate.mac), keyEquivalent: "m"))
      menu.addItem(NSMenuItem.separator())
      menu.addItem(NSMenuItem(title: "Reboot", action: #selector(AppDelegate.reboot), keyEquivalent: "R"))
      menu.addItem(NSMenuItem.separator())
      menu.addItem(NSMenuItem(title: "Quit XB", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

      statusItem.menu = menu
    }


}

