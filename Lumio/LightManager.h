//
//  LightManager.h
//  Lumio
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Light.h"
#import "Route.h"
#import "Common.h"

@class Light;
@class Route;

//used to handle interactions which involve the group of lights as a whole, or the position of the light in the group.
@interface LightManager : CCNode {
}

@property (nonatomic, strong) Route *route;
@property (nonatomic) int maxCooldown;
@property (nonatomic) float countdownReduction;

- (id)initWithLightArray:(NSMutableArray *)lightArray;
- (void)update:(ccTime)dt;

- (void)chooseFirstLightWithValue:(LightValue)value;
- (void)chooseNewLightWithValue:(LightValue)value;
- (void)lightNowActive:(Light *)light;
- (void)lightNowOnCooldown:(Light *)light;

- (Light *)getSelectedLightFromLocation:(CGPoint)location;
- (Light *)getLightAtRow:(int)row column:(int)column;

@end
