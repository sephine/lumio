//
//  Credits Layer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/27/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "CreditsLayer.h"
#import "AboutLayer.h"
#import "GameConfig.h"
#import "CCButton.h"

//layer for the Credits menu.
@interface CreditsLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

@end

@implementation CreditsLayer

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue
{
    if (self = [super init]) {
        self.baseMenuLayer = baseLayer;
        self.showContinue = showContinue;
        
        CGSize size = [CCDirector sharedDirector].viewSize;
        
        //add the background image showing the credits
        CCSprite *background = [CCSprite spriteWithImageNamed:@"CreditsBackground.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        CCButton *licenseButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"LicenseButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"LicenseButtonSelected.png"] disabledSpriteFrame:nil];
        [licenseButton setTarget:self selector:@selector(licenseButtonTapped:)];
        licenseButton.position = ccp(LICENSE_X_COORD, size.height == 568 ? LICENSE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : LICENSE_Y_COORD);
        [self addChild:licenseButton];
        
        CCButton *backwardsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackButtonSelected.png"] disabledSpriteFrame:nil];
        [licenseButton setTarget:self selector:@selector(backwardsButtonTapped:)];
        backwardsButton.position = ccp(BACK_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_BACK_Y_COORD : BACK_Y_COORD);
        [self addChild:backwardsButton];
    }
    return self;
}

- (void)backwardsButtonTapped:(id)sender
{
    //transition layers back to the about layer.
    AboutLayer *aboutLayer = [[AboutLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:aboutLayer z:2];
    
    [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[aboutLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)licenseButtonTapped:(id)sender
{
    //open up the webpage showing the license information.
    NSString *urlstring = @"http://creativecommons.org/licenses/by-nc-sa/3.0/";
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlstring]];
}

@end
