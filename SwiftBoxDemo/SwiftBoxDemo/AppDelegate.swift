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

	func applicationDidFinishLaunching(_ notification: Notification) {
		let contentView = window.contentView!
		let parent = Node(size: contentView.frame.size,
		                  children: [
                        Node(size: CGSize(width: 0, height: 100),
                             margin: Edges(left: 10, right: 10),
                             flex: 75),
                        Node(size: CGSize(width: 0, height: 50),
                             margin: Edges(right: 10),
                             flex: 15),
                        Node(size: CGSize(width: 0, height: 180),
                             margin: Edges(right: 10),
                             flex: 10),
                        ],
		                  direction: .row,
                      childAlignment: .center)

		let layout = parent.layout()
		print(layout)

		layout.apply(contentView)
	}
}
