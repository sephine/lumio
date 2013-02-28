//
//  MainMenuLayer.m
//  CircleGame
//
//  Created by Joanne Dyer on 2/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "BaseMenuLayer.h"
#import "GameLayer.h"
#import "ReadyLayer.h"
#import "AboutLayer.h"
#import "SettingsLayer.h"
#import "HowToPlayAimLayer.h"
#import "GameConfig.h"

@interface MainMenuLayer ()

@property (nonatomic, strong) BaseMenuLayer *baseLayer;
@property (nonatomic) BOOL showContinue;

@end

@implementation MainMenuLayer

@synthesize baseLayer = _baseLayer;
@synthesize showContinue = _showContinue;

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue
{
    if (self = [super init]) {
        self.baseLayer = baseLayer;
        self.showContinue = showContinue;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //add the logo to the top of the page.
        CCSprite *logo = [CCSprite spriteWithFile:@"logo.png"];
        logo.position = ccp(LOGO_X_COORD, size.height == 568 ? LOGO_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : LOGO_Y_COORD);
        [self addChild:logo];
        
        //Create the Continue Menu Item.
        CCMenuItemImage *continueMenuItem = [CCMenuItemImage
                                             itemWithNormalImage:@"ContinueButton.png" selectedImage:@"ContinueButtonSelected.png"
                                             target:self selector:@selector(continueButtonTapped:)];
        
        //Create the New Game Menu Item.
        CCMenuItemImage *newGameMenuItem = [CCMenuItemImage
                                            itemWithNormalImage:@"NewGameButton.png" selectedImage:@"NewGameButtonSelected.png"
                                            target:self selector:@selector(newGameButtonTapped:)];
        
        //Create the About Menu Item.
        CCMenuItemImage *aboutMenuItem = [CCMenuItemImage
                                          itemWithNormalImage:@"AboutButton.png" selectedImage:@"AboutButtonSelected.png"
                                          target:self selector:@selector(aboutButtonTapped:)];
        
        //Create the Setting Menu Item.
        CCMenuItemImage *settingsMenuItem = [CCMenuItemImage
                                             itemWithNormalImage:@"SettingsButton.png" selectedImage:@"SettingsButtonSelected.png"
                                             target:self selector:@selector(settingsButtonTapped:)];
        
        CCMenu *menu;
        if (showContinue) {
            menu = [CCMenu menuWithItems:continueMenuItem, newGameMenuItem, aboutMenuItem, settingsMenuItem, nil];
        } else {
            menu = [CCMenu menuWithItems:newGameMenuItem, aboutMenuItem, settingsMenuItem, nil];
        }
        
        menu.position = ccp(MAIN_MENU_MENU_X_COORD, size.height == 568 ? MAIN_MENU_MENU_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : MAIN_MENU_MENU_Y_COORD);
        [menu alignItemsVerticallyWithPadding:MENU_PADDING];
        [self addChild:menu];
    }
    return self;
}

- (void)newGameButtonTapped:(id)sender
{
    if (self.baseLayer.firstPlay) {
        HowToPlayAimLayer *howToPlayLayer = [[HowToPlayAimLayer alloc] initWithBaseLayer:self.baseLayer showContinue:self.showContinue goToGame:YES];
        [[[CCDirector sharedDirector] runningScene] addChild:howToPlayLayer z:1];
        
        [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[howToPlayLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
        [self removeFromParentAndCleanup:YES];
    } else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:MENU_TRANSITION_TIME scene:[GameLayer scene] withColor:ccBLACK]];
    }
}

- (void)continueButtonTapped:(id)sender
{
    //go back to previous game scene and add the ready layer.
    CCScene *gameScene = self.baseLayer.gameScene;
    ReadyLayer *readyLayer = [[ReadyLayer alloc] init];
    [gameScene addChild:readyLayer z:2];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:MENU_TRANSITION_TIME scene:gameScene withColor:ccBLACK]];
    //GameLayer *gameLayer = (GameLayer *)[gameScene getChildByTag:GAME_LAYER_TAG];
    
    //[self scheduleOnce:@selector(unPauseGameLayer:) delay:0.7];
    //[[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(unPauseGame) forTarget:gameLayer interval:0 paused:YES repeat:0 delay:0.6];
    
}

- (void)aboutButtonTapped:(id)sender
{
    AboutLayer *aboutLayer = [[AboutLayer alloc] initWithBaseLayer:self.baseLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:aboutLayer z:1];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[aboutLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)settingsButtonTapped:(id)sender
{
    SettingsLayer *settingsLayer = [[SettingsLayer alloc] initWithBaseLayer:self.baseLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:settingsLayer z:1];
    
    [CCSequence actionOne:(CCFiniteTimeAction *)[self runAction:[CCFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCFiniteTimeAction *)[settingsLayer runAction:[CCFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

@end
