//
//  LightManager.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Light.h"
#import "Route.h"

@class Light;
@class Route;

@interface LightManager : CCNode {
}

@property (nonatomic, strong) Route *route;

- (id)initWithLightArray:(NSMutableArray *)lightArray;
- (void)update:(ccTime)dt;

- (void)chooseNewValueLight;
- (void)lightNowActive:(Light *)light;
- (void)lightNowOnCooldown:(Light *)light;

- (Light *)getSelectedLightFromLocation:(CGPoint)location;
- (Light *)getLightAtRow:(int)row column:(int)column;

@end
