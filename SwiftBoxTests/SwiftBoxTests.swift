//
//  SwiftBoxTests.swift
//  SwiftBoxTests
//
//  Created by Josh Abernathy on 2/1/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftBox

class SwiftBoxTests: XCTestCase {
    func testDescription() {
		let parent = Node(size: CGSize(width: 300, height: 300),
                    childAlignment: .Center,
					direction: .Row,
                    children: [
			Node(flex: 75,
                 margin: Edges(left: 10, right: 10),
                 size: CGSize(width: 0, height: 100)),
			Node(flex: 15,
				 margin: Edges(right: 10),
                 size: CGSize(width: 0, height: 50)),
			Node(flex: 10,
				 margin: Edges(right: 10),
				 size: CGSize(width: 0, height: 180)),
		])

		let layout = parent.layout()
		XCTAssert(count("\(layout)".utf16) > 0, "Has a description.")
    }

	func testSizeParentBasedOnChildren() {
		let parent = Node(children: [
			Node(size: CGSize(width: 100, height: 200)),
			Node(size: CGSize(width: 300, height: 150)),
		])

		let layout = parent.layout()
		XCTAssertEqual(layout.frame.size, CGSize(width: 300, height: 350));
	}

	func testMeasureIsUsed() {
		let measuredSize = CGSize(width: 123, height: 456)
		let node = Node(measure: { w in
			return measuredSize
		})

		let layout = node.layout()
		XCTAssertEqual(layout.frame.size, measuredSize)
	}

	func testMaxWidthIsUsed() {
		let maxWidth: CGFloat = 345
		var maxWidthGiven: CGFloat = 0
		let node = Node(measure: { w in
			maxWidthGiven = w
			return CGSize(width: 1, height: 1)
		})

		let layout = node.layout(maxWidth: maxWidth)
		XCTAssertEqual(maxWidthGiven, maxWidth)
	}
}
