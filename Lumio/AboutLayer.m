//
//  AboutLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/21/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "AboutLayer.h"
#import "MainMenuLayer.h"
#import "HowToPlayAimLayer.h"
#import "CreditsLayer.h"
#import "GameConfig.h"
#import "GameKitHelper.h"

//layer for the About menu.
@interface AboutLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

@end

@implementation AboutLayer

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue
{
    if (self = [super init]) {
        self.baseMenuLayer = baseLayer;
        self.showContinue = showContinue;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //show the selected button image for about as the tile of the page.
        CCSprite *aboutTitle = [CCSprite spriteWithFile:@"AboutButtonSelected.png"];
        aboutTitle.position = ccp(ABOUT_TITLE_X_COORD, size.height == 568 ? ABOUT_TITLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : ABOUT_TITLE_Y_COORD);
        [self addChild:aboutTitle];
        
        CCMenuItemImage *howToPlayMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"HowToPlayButton.png"
                                              selectedImage:@"HowToPlayButtonSelected.png"
                                              target:self
                                              selector:@selector(howToPlayButtonTapped:)];
        
        CCMenuItemImage *leaderboardMenuItem = [CCMenuItemImage
                                                itemWithNormalImage:@"LeaderboardButton.png"
                                                selectedImage:@"LeaderboardButtonSelected.png"
                                                target:self
                                                selector:@selector(leaderboardButtonTapped:)];
        
        CCMenuItemImage *reviewAppMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"LeaveARatingButton.png"
                                              selectedImage:@"LeaveARatingButtonSelected.png"
                                              target:self
                                              selector:@selector(reviewAppButtonTapped:)];
        
        CCMenuItemImage *creditsMenuItem = [CCMenuItemImage
                                            itemWithNormalImage:@"CreditsButton.png"
                                            selectedImage:@"CreditsButtonSelected.png"
                                            target:self
                                            selector:@selector(creditsButtonTapped:)];
        
        CCMenu *menu = [CCMenu menuWithItems:howToPlayMenuItem, leaderboardMenuItem, reviewAppMenuItem, creditsMenuItem, nil];
        menu.position = ccp(ABOUT_MENU_X_COORD, size.height == 568 ? ABOUT_MENU_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : ABOUT_MENU_Y_COORD); //230
        [menu alignItemsVerticallyWithPadding:MENU_PADDING];
        [self addChild:menu];
        
        //Create the Backwards Menu Item and put it in its own menu.
        CCMenuItemImage *backwardsMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"BackButton.png" selectedImage:@"BackButtonSelected.png"
                                              target:self selector:@selector(backwardsButtonTapped:)];
        
        CCMenu *backwardsMenu = [CCMenu menuWithItems:backwardsMenuItem, nil];
        backwardsMenu.position = ccp(BACK_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_BACK_Y_COORD : BACK_Y_COORD);
        [self addChild:backwardsMenu];
    }
    return self;
}

- (void)howToPlayButtonTapped:(id)sender
{
    //transition layers to the how to play layer.
    HowToPlayAimLayer *howToPlayLayer = [[HowToPlayAimLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue goToGame:NO];
    [[[CCDirector sharedDirector] runningScene] addChild:howToPlayLayer z:1];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[howToPlayLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)leaderboardButtonTapped:(id)sender
{
    //show the game center leaderboard
    GameKitHelper *helper = [GameKitHelper sharedGameKitHelper];
    [helper showLeaderboard];
}

- (void)reviewAppButtonTapped:(id)sender
{
    //open up the review page of the app in the app store.
    NSString *appID = APPLE_ID;
    NSString *urlstring = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlstring]];
}

- (void)creditsButtonTapped:(id)sender
{
    //transition layers to the credits layer.
    CreditsLayer *creditsLayer = [[CreditsLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:creditsLayer z:1];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[creditsLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)backwardsButtonTapped:(id)sender
{
    //transition layers back to the main menu layer.
    MainMenuLayer *mainMenuLayer = [[MainMenuLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:mainMenuLayer z:2];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[mainMenuLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

@end

