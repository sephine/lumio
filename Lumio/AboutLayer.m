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
        aboutTitle.position = ccp(160, 340);
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
        menu.position = ccp(160, 218); //230
        [menu alignItemsVerticallyWithPadding:10.0];
        [self addChild:menu];
        
        //Create the Backwards Menu Item and put it in its own menu.
        CCMenuItemImage *backwardsMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"BackButton.png" selectedImage:@"BackButtonSelected.png"
                                              target:self selector:@selector(backwardsButtonTapped:)];
        
        CCMenu *backwardsMenu = [CCMenu menuWithItems:backwardsMenuItem, nil];
        backwardsMenu.position = ccp(76, 51);
        [self addChild:backwardsMenu];
    }
    return self;
}

- (void)howToPlayButtonTapped:(id)sender
{
    HowToPlayAimLayer *howToPlayLayer = [[HowToPlayAimLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue goToGame:NO];
    [[[CCDirector sharedDirector] runningScene] addChild:howToPlayLayer z:1];
    
    [CCSequence actionOne:[self runAction:[CCFadeOut actionWithDuration:0.3]] two:[howToPlayLayer runAction:[CCFadeIn actionWithDuration:0.3]]];
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
    NSString *appID = @"608072046";
    NSString *urlstring = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlstring]];
}

- (void)creditsButtonTapped:(id)sender
{
    CreditsLayer *creditsLayer = [[CreditsLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:creditsLayer z:1];
    
    [CCSequence actionOne:[self runAction:[CCFadeOut actionWithDuration:0.3]] two:[creditsLayer runAction:[CCFadeIn actionWithDuration:0.3]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)backwardsButtonTapped:(id)sender
{
    MainMenuLayer *mainMenuLayer = [[MainMenuLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:mainMenuLayer z:2];
    
    [CCSequence actionOne:[self runAction:[CCFadeOut actionWithDuration:0.3]] two:[mainMenuLayer runAction:[CCFadeIn actionWithDuration:0.3]]];
    [self removeFromParentAndCleanup:YES];
}

@end

