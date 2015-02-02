//
//  NodeImpl.m
//  layout
//
//  Created by Josh Abernathy on 1/30/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

#import "NodeImpl.h"

static bool alwaysDirty(void *context) {
	return true;
}

static css_node_t * getChild(void *context, int i) {
	NodeImpl *self = (__bridge NodeImpl *)context;
	NodeImpl *child = self.children[i];
	return child.node;
}

@implementation NodeImpl

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
	for (NodeImpl *child in self.children) {
		[child prepareForLayout];
	}

	// Apparently we need to reset these before laying out, otherwise the layout
	// has some weird additive effect.
	self.node->layout.position[CSS_LEFT] = 0;
	self.node->layout.position[CSS_TOP] = 0;
	self.node->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
	self.node->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
}

- (void)layout {
	[self prepareForLayout];

	layoutNode(self.node, CSS_UNDEFINED);
}

- (CGRect)frame {
	return CGRectMake(self.node->layout.position[CSS_LEFT], self.node->layout.position[CSS_TOP], self.node->layout.dimensions[CSS_WIDTH], self.node->layout.dimensions[CSS_HEIGHT]);
}

@end
