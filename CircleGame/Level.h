//
//  Level.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "CountdownBar.h"

@interface Level : CCNode {
}

@property (nonatomic) CGPoint position;

- (id)initWithGameLayer:(GameLayer *)gameLayer countdownBar:(CountdownBar *)countdownBar;
- (void)update:(ccTime)dt;

@end
