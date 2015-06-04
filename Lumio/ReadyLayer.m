//
//  ReadyLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/27/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "ReadyLayer.h"
#import "GameLayer.h"
#import "GameConfig.h"

//simple layer that covers up the game layer when it starts and is removed when you tap it.
@interface ReadyLayer ()

@end

@implementation ReadyLayer

- (id)init
{
    if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"ReadyLayer.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild: background z:0];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

- (void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

//when the layer is touched anywhere, remove it and unpause game layer.
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    GameLayer *gameLayer = (GameLayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:GAME_LAYER_TAG];
    [gameLayer unPauseGame];
    [self removeFromParentAndCleanup:YES];
}

@end
