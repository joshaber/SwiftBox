//
//  Node.m
//  layout
//
//  Created by Josh Abernathy on 1/30/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

#import "Node.h"

static bool alwaysDirty(void *context) {
	return true;
}

static css_node_t * getChild(void *context, int i) {
	Node *self = (__bridge Node *)context;
	Node *child = self.children[i];
	return child.node;
}

@implementation Node

- (void)dealloc {
	free_css_node(_node);
}

- (id)init {
	self = [super init];
	if (self == nil) return nil;

	_node = new_css_node();
	_node->context = (__bridge void *)self;
	_node->is_dirty = alwaysDirty;
	_node->get_child = getChild;

	return self;
}

- (void)setChildren:(NSArray *)children {
	_children = [children copy];

	_node->children_count = (int)children.count;
}

- (void)prepareForLayout {
	for (Node *child in self.children) {
		[child prepareForLayout];
	}

	self.node->layout.position[CSS_LEFT] = 0;
	self.node->layout.position[CSS_TOP] = 0;
	self.node->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
	self.node->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
}

- (void)layout {
	[self prepareForLayout];

	layoutNode(self.node, CSS_UNDEFINED);
}

- (CGRect)frameFromNode {
	return CGRectMake(self.node->layout.position[CSS_LEFT], self.node->layout.position[CSS_TOP], self.node->layout.dimensions[CSS_WIDTH], self.node->layout.dimensions[CSS_HEIGHT]);
}

@end
