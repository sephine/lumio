//
//  PowerUpManager.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/28/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface PowerUpManager : CCNode {
}

@property (nonatomic) BOOL hasCharge;

- (id)initWithPlayer:(Player *)player;

@end
