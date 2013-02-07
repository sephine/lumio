//
//  PowerUpManager.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/28/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PowerUpManager.h"

@interface PowerUpManager ()

@property (nonatomic, strong) Player *player;

@end

@implementation PowerUpManager

@synthesize player = _player;

- (id)initWithPlayer:(Player *)player
{
    if (self = [super init]) {
        self.hasCharge = NO;
        self.player = player;
    }
    return self;
}

@end
