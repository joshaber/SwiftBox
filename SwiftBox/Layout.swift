//
//  Layout.swift
//  SwiftBox
//
//  Created by Josh Abernathy on 1/30/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

import Foundation

struct Edges {
	let left: CGFloat
	let right: CGFloat
	let bottom: CGFloat
	let top: CGFloat

	private var asTuple: (Float, Float, Float, Float) {
		return (Float(left), Float(top), Float(right), Float(bottom))
	}

	init(left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, top: CGFloat = 0) {
		self.left = left
		self.right = right
		self.bottom = bottom
		self.top = top
	}
}

enum Direction: UInt32 {
	case Column = 0
	case Row = 1
}

enum Justification: UInt32 {
	case FlexStart = 0
	case Center = 1
	case FlexEnd = 2
	case SpaceBetween = 3
	case SpaceAround = 4
}

enum ChildAlignment: UInt32 {
	case FlexStart = 1
	case Center = 2
	case FlexEnd = 3
	case Stretch = 4
}

enum SelfAlignment: UInt32 {
	case Auto = 0
	case FlexStart = 1
	case Center = 2
	case FlexEnd = 3
	case Stretch = 4
}

struct Layout {
	private let node: Node

	init(size: CGSize = CGSizeZero, children: [Layout] = [], direction: Direction = .Row, margin: Edges = Edges(), padding: Edges = Edges(), wrap: Bool = false, justification: Justification = .FlexStart, selfAlignment: SelfAlignment = .Auto, childAlignment: ChildAlignment = .Stretch, flex: CGFloat = 0) {

		node = Node()
		node.node.memory.style.dimensions = (Float(size.width), Float(size.height))
		node.node.memory.style.margin = margin.asTuple
		node.node.memory.style.padding = padding.asTuple
		node.node.memory.style.flex = Float(flex)
		node.node.memory.style.flex_direction = css_flex_direction_t(direction.rawValue)
		node.node.memory.style.flex_wrap = css_wrap_type_t(wrap ? 1 : 0)
		node.node.memory.style.justify_content = css_justify_t(justification.rawValue)
		node.node.memory.style.align_self = css_align_t(selfAlignment.rawValue)
		node.node.memory.style.align_items = css_align_t(childAlignment.rawValue)
		node.children = children.map { $0.node }
	}

	func apply(view: NSView) {
		node.layout()
		applyRecursively(view, node: node)
	}

	private func applyRecursively(view: NSView, node: Node) {
		view.frame = node.frameFromNode()

		for (s, n) in Zip2(view.subviews, node.children) {
			let subview = s as NSView
			let childNode = n as Node
			applyRecursively(subview, node: childNode)
		}
	}
}
