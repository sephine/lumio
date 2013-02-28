//
//  Credits Layer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/27/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CreditsLayer.h"
#import "AboutLayer.h"

@interface CreditsLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

@end

@implementation CreditsLayer

@synthesize baseMenuLayer = _baseMenuLayer;
@synthesize showContinue = _showContinue;

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue
{
    if (self = [super init]) {
        self.baseMenuLayer = baseLayer;
        self.showContinue = showContinue;
        
        // ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //add the background image showing the credits
        CCSprite *background = [CCSprite spriteWithFile:@"CreditsBackground.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        //Create the license menu item.
        CCMenuItemImage *licenseMenuItem = [CCMenuItemImage
                                            itemWithNormalImage:@"LicenseButton.png"
                                            selectedImage:@"LicenseButtonSelected.png"
                                            target:self
                                            selector:@selector(licenseButtonTapped:)];
        licenseMenuItem.position = ccp(158, 182);
        
        //Create the Backwards Menu Item and add to menu
        CCMenuItemImage *backwardsMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"BackButton.png" selectedImage:@"BackButtonSelected.png"
                                              target:self selector:@selector(backwardsButtonTapped:)];
        backwardsMenuItem.position = ccp(76, 51);
        
        CCMenu *menu = [CCMenu menuWithItems:licenseMenuItem, backwardsMenuItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    return self;
}

- (void)backwardsButtonTapped:(id)sender
{
    AboutLayer *aboutLayer = [[AboutLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:aboutLayer z:2];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:0.3]] two:(CCFiniteTimeAction *)[aboutLayer runAction:[CCFadeIn actionWithDuration:0.3]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)licenseButtonTapped:(id)sender
{
    NSString *urlstring = @"http://creativecommons.org/licenses/by-nc-sa/3.0/";
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlstring]];
}

@end
