//
//  ReadyLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/27/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ReadyLayer.h"
#import "GameLayer.h"
#import "GameConfig.h"

@interface ReadyLayer ()

@end

@implementation ReadyLayer

- (id)init
{
    if( (self=[super init]) ) {
        
        // ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background;
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            background = [CCSprite spriteWithFile:@"ReadyLayer.png"];
            //background.rotation = 90;
        } else {
            background = [CCSprite spriteWithFile:@"ReadyLayer.png"];
        }
        background.position = ccp(size.width/2, size.height/2);
        
        // add the background as a child to this Layer
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
