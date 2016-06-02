//
//  HowToPlayPowerupLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/25/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "HowToPlayPowerupLayer.h"
#import "HowToPlayMovementLayer.h"
#import "AboutLayer.h"
#import "GameLayer.h"
#import "GameConfig.h"
#import "CCButton.h"

//layer for the How To Play Powerup menu (the third how to play screen).
@interface HowToPlayPowerupLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

//used to show whether at the end of the how to play it should go to the game or the menu.
@property (nonatomic) BOOL goToGame;

@end

@implementation HowToPlayPowerupLayer

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue goToGame:(BOOL)goToGame;
{
    if (self = [super init]) {
        self.baseMenuLayer = baseLayer;
        self.showContinue = showContinue;
        self.goToGame = goToGame;
        
        CGSize size = [CCDirector sharedDirector].viewSize;
        
        CCSprite *background = [CCSprite spriteWithImageNamed:@"HowToPlayPowerup.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        CCButton *backwardsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackButtonSelected.png"] disabledSpriteFrame:nil];
        [backwardsButton setTarget:self selector:@selector(backwardsButtonTapped:)];
        backwardsButton.position = ccp(BACK_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_BACK_Y_COORD : BACK_Y_COORD);
        [self addChild:backwardsButton];
        
        CCButton *forwardsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"DoneButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"DoneButtonSelected.png"] disabledSpriteFrame:nil];
        [forwardsButton setTarget:self selector:@selector(forwardsButtonTapped:)];
        forwardsButton.position = ccp(NEXT_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_NEXT_Y_COORD : NEXT_Y_COORD);
        [self addChild:forwardsButton];
    }
    return self;
}

- (void)backwardsButtonTapped:(id)sender
{
    //transition layers back to the how to play movement layer (the second how to play layer).
    HowToPlayMovementLayer *movementLayer = [[HowToPlayMovementLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue goToGame:self.goToGame];
    [[[CCDirector sharedDirector] runningScene] addChild:movementLayer z:2];
    
    [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[movementLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)forwardsButtonTapped:(id)sender
{
    //now the how to play has been read. set first game to no so it is not shown again on startup.
    self.baseMenuLayer.firstPlay = NO;
    
    //if goToGame is yes start a new game otherwise return to the About screen.
    if (self.goToGame) {
        [[CCDirector sharedDirector] presentScene:[GameLayer scene] withTransition:[CCTransition transitionFadeWithDuration:MENU_TRANSITION_TIME]];
    } else {
        AboutLayer *aboutLayer = [[AboutLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
        [[[CCDirector sharedDirector] runningScene] addChild:aboutLayer z:2];
        
        [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[aboutLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
        [self removeFromParentAndCleanup:YES];
    }
}


@end
