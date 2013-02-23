//
//  CCLayerWithTransparency.m
//  CircleGame
//
//  Created by Joanne Dyer on 2/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CCLayerWithTransparency.h"

@implementation CCLayerWithTransparency

@synthesize opacity = _opacity;

// Set the opacity of all of our children that support it
- (void)setOpacity: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            [(id<CCRGBAProtocol>) node setOpacity: opacity];
        }
    }
}

- (GLubyte)opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            return [(id<CCRGBAProtocol>) node opacity];
        }
    }
    return 0;
}

@end
