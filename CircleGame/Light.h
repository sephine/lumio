//
//  Light.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "Connector.h"
#import "Route.h"

typedef enum {
    Active,
    Cooldown,
    AlmostOccupied,
    Occupied
} LightState;

typedef enum {
    Low,
    Medium,
    High,
    NoValue
} LightValue;

struct GridLocation {
    int row;
    int column;
};

@class Route;

@interface Light : CCNode {
}

@property (nonatomic) CGPoint position;
@property (nonatomic, strong) Route *route;
@property (nonatomic) struct GridLocation gridLocation;
@property (nonatomic) BOOL isPartOfRoute;
@property (nonatomic, strong) Connector *topConnector;
@property (nonatomic, strong) Connector *rightConnector;

- (id)initWithGameLayer:(GameLayer *)gameLayer gridLocation:(struct GridLocation)gridLocation;
- (void)update:(ccTime)dt;
- (CGRect)getBounds;

//used by route.
- (BOOL)canAddLightToRoute;

//used by player.
- (void)almostOccupyLight;
- (LightValue)occupyLightAndGetValue;
- (void)leaveLight;

//used by the light manager.
- (BOOL)canBeValueLight;
- (void)setUpLightWithValue;


@end
