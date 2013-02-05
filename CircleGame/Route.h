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
#import "LightManager.h"

typedef enum {
    Up,
    Down,
    Left,
    Right,
    None
} Direction;

@class Light;
@class LightManager;

@interface Route : CCNode {
}

- (id)initWithGameLayer:(GameLayer *)gameLayer lightManager:(LightManager *)lightManager;

//used by gameLayer in setup and upon light selection
- (void)setInitialLight:(Light *)light;
- (void)lightSelected:(Light *)light;

//used by player for movement.
- (Light *)getNextLightFromRoute;
- (void)removeFirstLightFromRoute;

//used by the light manager when a light enters cooldown.
- (void)removeLightFromRoute:(Light *)light;

@end
