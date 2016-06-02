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
#import "CCButton.h"

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
        
        CGSize size = [CCDirector sharedDirector].viewSize;
        
        //show the selected button image for about as the tile of the page.
        CCSprite *aboutTitle = [CCSprite spriteWithImageNamed:@"AboutButtonSelected.png"];
        aboutTitle.position = ccp(ABOUT_TITLE_X_COORD, size.height == 568 ? ABOUT_TITLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : ABOUT_TITLE_Y_COORD);
        [self addChild:aboutTitle];
        
        CCButton *howToPlayButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"HowToPlayButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"HowToPlayButtonSelected.png"] disabledSpriteFrame:nil];
        [howToPlayButton setTarget:self selector:@selector(howToPlayButtonTapped:)];
        
        CCButton *leaderboardButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"LeaderboardButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"LeaderboardButtonSelected.png"] disabledSpriteFrame:nil];
        [leaderboardButton setTarget:self selector:@selector(leaderboardButtonTapped:)];
        
        CCButton *reviewAppButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"LeaveARatingButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"LeaveARatingButtonSelected.png"] disabledSpriteFrame:nil];
        [reviewAppButton setTarget:self selector:@selector(reviewAppButtonTapped:)];
        
        CCButton *creditsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"CreditsButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"CreditsButtonSelected.png"] disabledSpriteFrame:nil];
        [creditsButton setTarget:self selector:@selector(creditsButtonTapped:)];
        
        //create the menu and show the continue button if necessary.
        CCLayoutBox *layout = [[CCLayoutBox alloc] init];
        [layout addChild:howToPlayButton];
        [layout addChild:leaderboardButton];
        [layout addChild:reviewAppButton];
        [layout addChild:creditsButton];
        
        layout.spacing = MENU_PADDING;
        layout.direction = CCLayoutBoxDirectionVertical;
        [layout layout];
        layout.position = ccp(ABOUT_MENU_X_COORD, size.height == 568 ? ABOUT_MENU_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : ABOUT_MENU_Y_COORD); //230
        [self addChild:layout];
        
        //Create the Backwards Menu Item and put it in its own menu.
        CCButton *backwardsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackButtonSelected.png"] disabledSpriteFrame:nil];
        [backwardsButton setTarget:self selector:@selector(backwardsButtonTapped:)];
        backwardsButton.position = ccp(BACK_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_BACK_Y_COORD : BACK_Y_COORD);
        [self addChild:backwardsButton];
    }
    return self;
}

- (void)howToPlayButtonTapped:(id)sender
{
    //transition layers to the how to play layer.
    HowToPlayAimLayer *howToPlayLayer = [[HowToPlayAimLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue goToGame:NO];
    [[[CCDirector sharedDirector] runningScene] addChild:howToPlayLayer z:1];
    
    [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[howToPlayLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
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
    
    [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[creditsLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)backwardsButtonTapped:(id)sender
{
    //transition layers back to the main menu layer.
    MainMenuLayer *mainMenuLayer = [[MainMenuLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:mainMenuLayer z:2];
    
    [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[mainMenuLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

@end

