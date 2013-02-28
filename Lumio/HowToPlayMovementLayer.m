//
//  HowToPlayMovementLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HowToPlayMovementLayer.h"
#import "HowToPlayAimLayer.h"
#import "HowToPlayPowerupLayer.h"
#import "GameConfig.h"

@interface HowToPlayMovementLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

//used to show whether at the end of the how to play it should go to the game or the menu.
@property (nonatomic) BOOL goToGame;

@end

@implementation HowToPlayMovementLayer

@synthesize baseMenuLayer = _baseMenuLayer;
@synthesize showContinue = _showContinue;
@synthesize goToGame = _goToGame;

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue goToGame:(BOOL)goToGame;
{
    if (self = [super init]) {
        self.baseMenuLayer = baseLayer;
        self.showContinue = showContinue;
        self.goToGame = goToGame;
        
        // ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //add the background image describing how to play 'aim'.
        CCSprite *background = [CCSprite spriteWithFile:@"HowToPlayMovement.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        //Create the Backwards Menu Item and put it in its own menu.
        CCMenuItemImage *backwardsMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"BackButton.png" selectedImage:@"BackButtonSelected.png"
                                              target:self selector:@selector(backwardsButtonTapped:)];
        backwardsMenuItem.position = ccp(BACK_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_BACK_Y_COORD : BACK_Y_COORD);
        
        CCMenuItemImage *forwardsMenuItem = [CCMenuItemImage
                                             itemWithNormalImage:@"NextButton.png" selectedImage:@"NextButtonSelected.png"
                                             target:self selector:@selector(forwardsButtonTapped:)];
        forwardsMenuItem.position = ccp(NEXT_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_NEXT_Y_COORD : NEXT_Y_COORD);
        
        CCMenu *menu = [CCMenu menuWithItems:backwardsMenuItem, forwardsMenuItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    return self;
}

- (void)backwardsButtonTapped:(id)sender
{
    HowToPlayAimLayer *aimLayer = [[HowToPlayAimLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue goToGame:self.goToGame];
    [[[CCDirector sharedDirector] runningScene] addChild:aimLayer z:2];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[aimLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)forwardsButtonTapped:(id)sender
{
    HowToPlayPowerupLayer *powerupLayer = [[HowToPlayPowerupLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue goToGame:self.goToGame];
    [[[CCDirector sharedDirector] runningScene] addChild:powerupLayer z:2];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[powerupLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

@end
