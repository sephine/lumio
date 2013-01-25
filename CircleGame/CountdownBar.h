//
//  CountdownBar.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "Light.h"
#import "Lives.h"

@interface CountdownBar : CCNode {
}

@property (nonatomic) CGPoint position;

- (id)initWithGameLayer:(GameLayer *)gameLayer lives:(Lives *)lives;
- (void)update:(ccTime)dt;

- (void)addValue:(LightValue)value;
- (void)increaseCountdownSpeed:(float)speedIncrease;
- (void)refillBar;

@end
