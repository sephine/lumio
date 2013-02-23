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
#import "Player.h"

@class Light;
@class LightManager;
@class Player;

@interface Route : CCNode {
}

@property (nonatomic, strong) Player *player;

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
