//
//  Node.h
//  layout
//
//  Created by Josh Abernathy on 1/30/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Layout.h"

@interface Node : NSObject

@property (nonatomic, readonly, assign) css_node_t *node;

@property (nonatomic, copy) NSArray *children;

- (void)layout;

- (CGRect)frameFromNode;

@end
