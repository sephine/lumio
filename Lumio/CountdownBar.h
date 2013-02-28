//
//  CountdownBar.h
//  Lumio
//
//  Created by Joanne Dyer on 1/24/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "Common.h"

//represents the countdown bar object that counts down and when empty causes game over.
@interface CountdownBar : CCNode {
}

@property (nonatomic) CGPoint position;

- (id)initWithGameLayer:(GameLayer *)gameLayer;
- (void)update:(ccTime)dt;

- (void)addValue:(LightValue)value;
- (void)increaseCountdownSpeed:(float)speedIncrease;
- (void)refillBar;

@end
