//
//  AppDelegate.swift
//  SwiftBoxDemo
//
//  Created by Josh Abernathy on 2/1/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

import Cocoa
import SwiftBox

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet weak var window: NSWindow!

	func applicationDidFinishLaunching(notification: NSNotification) {
		let contentView = window.contentView as NSView
		let parent = Layout(size: contentView.frame.size,
                            childAlignment: .Center,
                            children: [
			Layout(flex: 75,
                   margin: Edges(left: 10, right: 10),
                   size: CGSize(width: 0, height: 100)),
			Layout(flex: 25,
                   margin: Edges(right: 10),
                   size: CGSize(width: 0, height: 50)),
		])

		parent.layout()
		println(parent)

		parent.apply(contentView)
	}
}
