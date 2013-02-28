//
//  Light.h
//  Lumio
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "Connector.h"
#import "LightManager.h"
#import "Common.h"

@class LightManager;

//class contains all the functionality for the game light objects.
@interface Light : CCNode {
}

@property (nonatomic) CGPoint position;
@property (nonatomic, strong) LightManager *lightManager;
@property (nonatomic) LightState lightState;
@property (nonatomic) int row;
@property (nonatomic) int column;
@property (nonatomic) BOOL isPartOfRoute;
@property (nonatomic, strong) Connector *topConnector;
@property (nonatomic, strong) Connector *rightConnector;

- (id)initWithGameLayer:(GameLayer *)gameLayer row:(int)row column:(int)column;
- (void)update:(ccTime)dt;
- (CGRect)getBounds;
- (void)setAsInitialLight;

//used by route.
- (BOOL)canAddLightToRoute;

//used by player.
- (void)chargeLight;
- (void)almostOccupyLight;
- (LightValue)occupyLightAndGetValue;
- (void)leaveLight;

//used by the light manager.
- (BOOL)canBeValueLight;
- (void)setUpLightWithValue:(LightValue)value;


@end
