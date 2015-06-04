//
//  IntroLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright JoanneDyer 2013. All rights reserved.
//

#import "IntroLayer.h"
#import "BaseMenuLayer.h"
#import "GameLayer.h"
#import "GameConfig.h"

#pragma mark - IntroLayer

//The IntroLayer exists to give a delay before the menu screens appear so everything is loaded before you see the menu.
@implementation IntroLayer

// Helper class method that creates a Scene with the IntroLayer as the only child.
+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    IntroLayer *layer = [IntroLayer node];
    
    [scene addChild: layer];
    return scene;
}

-(void) onEnter
{
    [super onEnter];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    //add the launch screen as the background so that when this scene is entered it is seamless from the launch screen.
    CCSprite *background = [CCSprite spriteWithFile:@"Default.png"];
    background.position = ccp(size.width/2, size.height/2);

    [self addChild: background];
    
    // In one second transition to the new scene
    [self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void) makeTransition:(ccTime)dt
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:INTRO_TRANSITION_TIME scene:[BaseMenuLayer scene] withColor:ccBLACK]];
}
@end
