//
//  Route.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "Light.h"

typedef enum {
    Up,
    Down,
    Left,
    Right,
    None
} Direction;

@interface Route : CCNode {
}

- (id)initWithGameLayer:(GameLayer *)gameLayer lightArray:(NSMutableArray *)lightArray;

//used by gameLayer in setup and upon light selection
- (void)setInitialLight:(Light *)light;
- (void)lightSelected:(Light *)light;

//used by player for movement.
- (Light *)getNextLightFromRoute;
- (void)removeFirstLightFromRoute;

@end
