//
//  AppDelegate.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import Cocoa
import SwiftUI
import KeyboardShortcuts
import Defaults

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover!
    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var aboutWindow: NSWindow?
    var shortcutWindow: NSWindow?
    private var observation: Defaults.Observation?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView()
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.image = NSImage(systemSymbolName: "checklist", accessibilityDescription: "ToDoBar")
        statusButton.imagePosition = .imageLeft
        statusButton.action = #selector(togglePopover(_:))

        KeyboardShortcuts.onKeyUp(for: .toggleTodoList) { [weak self] in
            self?.togglePopover(nil)
        }

        // Keep the menu bar count in sync with the saved list, whoever changes it.
        observation = Defaults.observe(keys: .todos, .showTaskCount) { [weak self] in
            self?.updateStatusBarButton()
        }
        updateStatusBarButton()

        NSApp.setActivationPolicy(.accessory)
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                // Needed when opened with the keyboard shortcut, so the text field can take typing.
                bringToFront()
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }

    private func bringToFront() {
        if #available(macOS 14.0, *) {
            NSApp.activate()
        } else {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    @objc
    func openAboutWindow(_: NSStatusBarButton?) {
        aboutWindow?.close()
        aboutWindow = makeWindow(title: String(localized: "About"), content: AboutView())
    }

    func openShortcutWindow() {
        shortcutWindow?.close()
        shortcutWindow = makeWindow(title: String(localized: "Keyboard Shortcut"), content: ShortcutView())
    }

    private func makeWindow<Content: View>(title: String, content: Content) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 240, height: 100),
            styleMask: [.closable, .titled],
            backing: .buffered,
            defer: false
        )
        window.title = title
        let hostingView = NSHostingView(rootView: content)
        window.contentView = hostingView
        window.setContentSize(hostingView.fittingSize)
        window.isReleasedWhenClosed = false
        bringToFront()
        window.center()
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        return window
    }

    @objc
    func quit() {
        NSApplication.shared.terminate(self)
    }
}

extension AppDelegate {
    func updateStatusBarButton() {
        let unfinishedCount = Defaults[.todos].unfinishedCount
        if Defaults[.showTaskCount] && unfinishedCount > 0 {
            statusBarItem.button?.title = String(unfinishedCount)
        } else {
            statusBarItem.button?.title = ""
        }
    }
}
