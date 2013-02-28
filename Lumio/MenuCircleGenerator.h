//
//  MenuCircleGenerator.h
//  Lumio
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseMenuLayer.h"

//class handles the creation and animation of the background circles for the menu screens.
@interface MenuCircleGenerator : CCNode {
}

- (id)initWithMenuLayer:(BaseMenuLayer *)menuLayer;
- (void)update:(ccTime)dt;

@end
