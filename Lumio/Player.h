//
//  Player.h
//  Lumio
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
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

//class contains all the functionality for the player object whose movement is controlled by the user.
@interface Player : CCNode {
}

@property (nonatomic) CGPoint position;
@property (nonatomic) BOOL hasCharge;

- (id)initWithGameLayer:(GameLayer *)gameLayer route:(Route *)route currentLight:(Light *)currentLight countdownBar:(CountdownBar *)countdownBar  score:(Score *)score;
- (void)update:(ccTime)dt;

@end
