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

@interface Player : CCNode {
}

@property (nonatomic) CGPoint position;

- (id)initWithGameLayer:(GameLayer *)gameLayer route:(Route *)route currentLight:(Light *)currentLight;
- (void)update:(ccTime)dt;

@end
