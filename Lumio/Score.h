//
//  Score.h
//  CircleGame
//
//  Created by Joanne Dyer on 2/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "Level.h"
#import "Common.h"

@class Level;

@interface Score : CCNode {
}

@property (nonatomic) CGPoint position;
@property (nonatomic) int scoreValue;

- (id)initWithGameLayer:(GameLayer *)gameLayer level:(Level *)level;
- (void)increaseScoreByValue:(LightValue)lightValue;

@end
