//
//  HowToPlayLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/25/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "HowToPlayAimLayer.h"
#import "MainMenuLayer.h"
#import "AboutLayer.h"
#import "HowToPlayMovementLayer.h"
#import "GameConfig.h"
#import "CCButton.h"

//layer for the How To Play Aim menu (the first how to play screen).
@interface HowToPlayAimLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

//used to show whether at the end of the how to play it should go to the game or the menu.
@property (nonatomic) BOOL goToGame;

@end

@implementation HowToPlayAimLayer

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue goToGame:(BOOL)goToGame;
{
    if (self = [super init]) {
        self.baseMenuLayer = baseLayer;
        self.showContinue = showContinue;
        self.goToGame = goToGame;
        
        CGSize size = [CCDirector sharedDirector].viewSize;
        
        CCSprite *background = [CCSprite spriteWithImageNamed:@"HowToPlayAim.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        CCButton *backwardsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackButtonSelected.png"] disabledSpriteFrame:nil];
        [backwardsButton setTarget:self selector:@selector(backwardsButtonTapped:)];
        backwardsButton.position = ccp(BACK_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_BACK_Y_COORD : BACK_Y_COORD);
        [self addChild:backwardsButton];
        
        CCButton *forwardsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"NextButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"NextButtonSelected.png"] disabledSpriteFrame:nil];
        [forwardsButton setTarget:self selector:@selector(forwardsButtonTapped:)];
        forwardsButton.position = ccp(NEXT_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_NEXT_Y_COORD : NEXT_Y_COORD);
        [self addChild:forwardsButton];
    }
    return self;
}

- (void)backwardsButtonTapped:(id)sender
{
    CCNode *newLayer;
    //if the how to play is preceding the start of a new game it will have opened from the main menu, otherwise it will be from the about screen.
    if (self.goToGame) {
        newLayer = [[MainMenuLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    } else {
        newLayer = [[AboutLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    }
    [[[CCDirector sharedDirector] runningScene] addChild:newLayer z:2];
    
    //transition to the main menu or about layer as applicable.
    [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[newLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)forwardsButtonTapped:(id)sender
{
    //transition layers to the how to play movement layer (the second how to play layer).
    HowToPlayMovementLayer *movementLayer = [[HowToPlayMovementLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue goToGame:self.goToGame];
    [[[CCDirector sharedDirector] runningScene] addChild:movementLayer z:2];
    
    [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[movementLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

@end
