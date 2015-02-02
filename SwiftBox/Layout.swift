//
//  Layout.swift
//  SwiftBox
//
//  Created by Josh Abernathy on 1/30/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

import Foundation

public struct Edges {
	public let left: CGFloat
	public let right: CGFloat
	public let bottom: CGFloat
	public let top: CGFloat

	private var asTuple: (Float, Float, Float, Float) {
		return (Float(left), Float(top), Float(right), Float(bottom))
	}

	public init(left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, top: CGFloat = 0) {
		self.left = left
		self.right = right
		self.bottom = bottom
		self.top = top
	}
}

public enum Direction: UInt32 {
	case Column = 0
	case Row = 1
}

public enum Justification: UInt32 {
	case FlexStart = 0
	case Center = 1
	case FlexEnd = 2
	case SpaceBetween = 3
	case SpaceAround = 4
}

public enum ChildAlignment: UInt32 {
	case FlexStart = 1
	case Center = 2
	case FlexEnd = 3
	case Stretch = 4
}

public enum SelfAlignment: UInt32 {
	case Auto = 0
	case FlexStart = 1
	case Center = 2
	case FlexEnd = 3
	case Stretch = 4
}

public struct Layout {
	private let node: Node

	public let children: [Layout]

	public init(size: CGSize = CGSizeZero, children: [Layout] = [], direction: Direction = .Row, margin: Edges = Edges(), padding: Edges = Edges(), wrap: Bool = false, justification: Justification = .FlexStart, selfAlignment: SelfAlignment = .Auto, childAlignment: ChildAlignment = .Stretch, flex: CGFloat = 0) {

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

		self.children = children
	}

	/// Lay out the receiver and all its children.
	public func layout() -> CGRect {
		node.layout()
		return frame
	}

	/// Get the frame without laying out.
	public var frame: CGRect {
		return node.frame
	}
}

extension Layout: Printable {
	public var description: String {
		let me = NSStringFromRect(frame)
		let them = (children.count > 0 ? children.description : "")
		return "\(me)\n\t\(them)"
	}
}
