//
//  CCLayerWithTransparency.m
//  Lumio
//
//  Created by Joanne Dyer on 2/21/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "CCLayerWithTransparency.h"

//Created in order to give a fade transition between layers (only normally available for scenes.)
@implementation CCLayerWithTransparency

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
