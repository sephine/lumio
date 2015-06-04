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
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //add the background image showing the credits
        CCSprite *background = [CCSprite spriteWithFile:@"CreditsBackground.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        CCMenuItemImage *licenseMenuItem = [CCMenuItemImage
                                            itemWithNormalImage:@"LicenseButton.png"
                                            selectedImage:@"LicenseButtonSelected.png"
                                            target:self
                                            selector:@selector(licenseButtonTapped:)];
        licenseMenuItem.position = ccp(LICENSE_X_COORD, size.height == 568 ? LICENSE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : LICENSE_Y_COORD);
        
        CCMenuItemImage *backwardsMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"BackButton.png" selectedImage:@"BackButtonSelected.png"
                                              target:self selector:@selector(backwardsButtonTapped:)];
        backwardsMenuItem.position = ccp(BACK_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_BACK_Y_COORD : BACK_Y_COORD);
        
        CCMenu *menu = [CCMenu menuWithItems:licenseMenuItem, backwardsMenuItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    return self;
}

- (void)backwardsButtonTapped:(id)sender
{
    //transition layers back to the about layer.
    AboutLayer *aboutLayer = [[AboutLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:aboutLayer z:2];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[aboutLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)licenseButtonTapped:(id)sender
{
    //open up the webpage showing the license information.
    NSString *urlstring = @"http://creativecommons.org/licenses/by-nc-sa/3.0/";
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlstring]];
}

@end
