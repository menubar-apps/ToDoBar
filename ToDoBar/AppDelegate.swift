//
//  AppDelegate.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import Cocoa
import SwiftUI
import HotKey

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    let hotKey = HotKey(key: .x, modifiers: [.control, .shift])  // Global hotke
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView()

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(systemSymbolName: "checklist", accessibilityDescription: nil)
            button.action = #selector(togglePopover(_:))
        }
        
        hotKey.keyUpHandler = { self.togglePopover(nil) }
        
        NSApp.setActivationPolicy(.accessory)
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    @objc
    func quit() {
        NSLog("User click Quit")
        NSApplication.shared.terminate(self)
    }
}
