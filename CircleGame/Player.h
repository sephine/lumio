//
//  Player.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "Route.h"
#import "CountdownBar.h"
#import "Score.h"

@class Route;
@class Light;
@class Score;

@interface Player : CCNode {
}

@property (nonatomic) CGPoint position;
@property (nonatomic) BOOL hasCharge;

- (id)initWithGameLayer:(GameLayer *)gameLayer route:(Route *)route currentLight:(Light *)currentLight countdownBar:(CountdownBar *)countdownBar  score:(Score *)score;
- (void)update:(ccTime)dt;

@end
