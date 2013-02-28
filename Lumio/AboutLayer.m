//
//  AboutLayer.m
//  CircleGame
//
//  Created by Joanne Dyer on 2/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "AboutLayer.h"
#import "MainMenuLayer.h"
#import "HowToPlayAimLayer.h"
#import "CreditsLayer.h"
#import "GameConfig.h"
#import "GameKitHelper.h"

@interface AboutLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

@end

@implementation AboutLayer

@synthesize baseMenuLayer = _baseMenuLayer;
@synthesize showContinue = _showContinue;

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue
{
    if (self = [super init]) {
        self.baseMenuLayer = baseLayer;
        self.showContinue = showContinue;
        
        //TODO for now show the selected button image for about as the tile of the page.
        CCSprite *aboutTitle = [CCSprite spriteWithFile:@"AboutButtonSelected.png"];
        aboutTitle.position = ccp(ABOUT_TITLE_X_COORD, ABOUT_TITLE_Y_COORD);
        [self addChild:aboutTitle];
        
        //Create the How To Play Menu Item.
        CCMenuItemImage *howToPlayMenuItem = [CCMenuItemImage
                                             itemWithNormalImage:@"HowToPlayButton.png" selectedImage:@"HowToPlayButtonSelected.png"
                                             target:self selector:@selector(howToPlayButtonTapped:)];
        
        //Create the Leaderboard Menu Item.
        CCMenuItemImage *leaderboardMenuItem = [CCMenuItemImage
                                            itemWithNormalImage:@"LeaderboardButton.png" selectedImage:@"LeaderboardButtonSelected.png"
                                            target:self selector:@selector(leaderboardButtonTapped:)];
        
        //Create the Review App Menu Item.
        CCMenuItemImage *reviewAppMenuItem = [CCMenuItemImage
                                          itemWithNormalImage:@"ReviewAppButton.png" selectedImage:@"ReviewAppButtonSelected.png"
                                          target:self selector:@selector(reviewAppButtonTapped:)];
        
        //Create the Credits Menu Item.
        CCMenuItemImage *creditsMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"CreditsButton.png" selectedImage:@"CreditsButtonSelected.png"
                                              target:self selector:@selector(creditsButtonTapped:)];
        
        CCMenu *menu = [CCMenu menuWithItems:howToPlayMenuItem, leaderboardMenuItem, reviewAppMenuItem, creditsMenuItem, nil];
        menu.position = ccp(ABOUT_MENU_X_COORD, ABOUT_MENU_Y_COORD); //230
        [menu alignItemsVerticallyWithPadding:MENU_PADDING];
        [self addChild:menu];
        
        //Create the Backwards Menu Item and put it in its own menu.
        CCMenuItemImage *backwardsMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"BackButton.png" selectedImage:@"BackButtonSelected.png"
                                              target:self selector:@selector(backwardsButtonTapped:)];
        
        CCMenu *backwardsMenu = [CCMenu menuWithItems:backwardsMenuItem, nil];
        backwardsMenu.position = ccp(BACK_X_COORD, BACK_Y_COORD);
        [self addChild:backwardsMenu];
    }
    return self;
}

- (void)howToPlayButtonTapped:(id)sender
{
    HowToPlayAimLayer *howToPlayLayer = [[HowToPlayAimLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue goToGame:NO];
    [[[CCDirector sharedDirector] runningScene] addChild:howToPlayLayer z:1];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[howToPlayLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)leaderboardButtonTapped:(id)sender
{
    GameKitHelper *helper = [GameKitHelper sharedGameKitHelper];
    [helper showLeaderboard];
}

- (void)reviewAppButtonTapped:(id)sender
{
    //TODO change the appID!
    NSString *appID = APPLE_ID;
    NSString *urlstring = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlstring]];
}

- (void)creditsButtonTapped:(id)sender
{
    CreditsLayer *creditsLayer = [[CreditsLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:creditsLayer z:1];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[creditsLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)backwardsButtonTapped:(id)sender
{
    MainMenuLayer *mainMenuLayer = [[MainMenuLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:mainMenuLayer z:2];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[mainMenuLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

@end

