//
//  HowToPlayPowerupLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HowToPlayPowerupLayer.h"
#import "HowToPlayMovementLayer.h"
#import "AboutLayer.h"
#import "GameLayer.h"

@interface HowToPlayPowerupLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

//used to show whether at the end of the how to play it should go to the game or the menu.
@property (nonatomic) BOOL goToGame;

@end

@implementation HowToPlayPowerupLayer

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
        CCSprite *background = [CCSprite spriteWithFile:@"HowToPlayPowerup.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        //Create the Backwards Menu Item and put it in its own menu.
        CCMenuItemImage *backwardsMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"BackButton.png" selectedImage:@"BackButtonSelected.png"
                                              target:self selector:@selector(backwardsButtonTapped:)];
        backwardsMenuItem.position = ccp(76, 51);
        
        CCMenuItemImage *forwardsMenuItem = [CCMenuItemImage
                                             itemWithNormalImage:@"DoneButton.png" selectedImage:@"DoneButtonSelected.png"
                                             target:self selector:@selector(forwardsButtonTapped:)];
        forwardsMenuItem.position = ccp(250, 51);
        
        CCMenu *menu = [CCMenu menuWithItems:backwardsMenuItem, forwardsMenuItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    return self;
}

- (void)backwardsButtonTapped:(id)sender
{
    HowToPlayMovementLayer *movementLayer = [[HowToPlayMovementLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue goToGame:self.goToGame];
    [[[CCDirector sharedDirector] runningScene] addChild:movementLayer z:2];
    
    [CCSequence actionOne:[self runAction:[CCFadeOut actionWithDuration:0.3]] two:[movementLayer runAction:[CCFadeIn actionWithDuration:0.3]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)forwardsButtonTapped:(id)sender
{
    //not the how to play has been read. set first game to no so it is not shown again on startup.
    self.baseMenuLayer.firstPlay = NO;
    
    //if goToGame is yes start a new game otherwise return to the About screen.
    if (self.goToGame) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.6 scene:[GameLayer scene] withColor:ccBLACK]];
    } else {
        AboutLayer *aboutLayer = [[AboutLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
        [[[CCDirector sharedDirector] runningScene] addChild:aboutLayer z:2];
        
        [CCSequence actionOne:[self runAction:[CCFadeOut actionWithDuration:0.3]] two:[aboutLayer runAction:[CCFadeIn actionWithDuration:0.3]]];
        [self removeFromParentAndCleanup:YES];
    }
}


@end
