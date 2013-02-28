//
//  Level.h
//  Lumio
//
//  Created by Joanne Dyer on 1/25/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "CountdownBar.h"
#import "LightManager.h"

@class LightManager;

//class controls the levelling up process and the labels showing current level.
@interface Level : CCNode {
}

@property (nonatomic) CGPoint position;

- (id)initWithGameLayer:(GameLayer *)gameLayer countdownBar:(CountdownBar *)countdownBar lightManager:(LightManager *)lightManager;
- (void)increaseLevel;

@end
