//
//  MainMenuLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/21/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameLayer.h"
#import "ReadyLayer.h"
#import "AboutLayer.h"
#import "SettingsLayer.h"
#import "HowToPlayAimLayer.h"
#import "GameConfig.h"
#import "CCButton.h"

//first menu layer that is shown on entering.
@interface MainMenuLayer ()

@property (nonatomic, strong) BaseMenuLayer *baseLayer;
@property (nonatomic) BOOL showContinue;

@end

@implementation MainMenuLayer

//base layer and show continue are passed to all menu layers created so that the game layer can be restored when needed (and shared data there can be accessed).

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue
{
    if (self = [super init]) {
        self.baseLayer = baseLayer;
        self.showContinue = showContinue;
        
        CGSize size = [CCDirector sharedDirector].viewSize;
        
        //add the logo to the top of the page.
        CCSprite *logo = [CCSprite spriteWithImageNamed:@"logo.png"];
        logo.position = ccp(LOGO_X_COORD, size.height == 568 ? LOGO_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : LOGO_Y_COORD);
        [self addChild:logo];
        
        CCButton *continueButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"ContinueButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"ContinueButtonSelected.png"] disabledSpriteFrame:nil];
        [continueButton setTarget:self selector:@selector(continueButtonTapped:)];
        
        CCButton *newGameButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"NewGameButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"NewGameButtonSelected.png"] disabledSpriteFrame:nil];
        [continueButton setTarget:self selector:@selector(newGameButtonTapped:)];

        CCButton *aboutButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"AboutButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"AboutButtonSelected.png"] disabledSpriteFrame:nil];
        [continueButton setTarget:self selector:@selector(aboutButtonTapped:)];

        CCButton *settingsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"SettingsButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"SettingsButtonSelected.png"] disabledSpriteFrame:nil];
        [continueButton setTarget:self selector:@selector(settingsButtonTapped:)];
        
        //create the menu and show the continue button if necessary.
        CCLayoutBox *layout = [[CCLayoutBox alloc] init];
        if (showContinue) {
            [layout addChild:continueButton];
        }
        [layout addChild:newGameButton];
        [layout addChild:aboutButton];
        [layout addChild:settingsButton];
        
        layout.spacing = MENU_PADDING;
        layout.direction = CCLayoutBoxDirectionVertical;
        [layout layout];
        layout.position = ccp(MAIN_MENU_MENU_X_COORD, size.height == 568 ? MAIN_MENU_MENU_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : MAIN_MENU_MENU_Y_COORD);
        [self addChild:layout];
    }
    return self;
}

- (void)newGameButtonTapped:(id)sender
{
    if (self.baseLayer.firstPlay) {
        //if it's the first time the game is played transition layers to the how to play aim layer.
        HowToPlayAimLayer *howToPlayLayer = [[HowToPlayAimLayer alloc] initWithBaseLayer:self.baseLayer showContinue:self.showContinue goToGame:YES];
        [[[CCDirector sharedDirector] runningScene] addChild:howToPlayLayer z:1];
        
        [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[howToPlayLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
        [self removeFromParentAndCleanup:YES];
    } else {
        //else create a new GameLayer scene.
        [[CCDirector sharedDirector] presentScene:[GameLayer scene] withTransition:[CCTransition transitionFadeWithDuration:MENU_TRANSITION_TIME]];
    }
}

- (void)continueButtonTapped:(id)sender
{
    //go back to previous game scene and add the ready layer.
    CCScene *gameScene = self.baseLayer.gameScene;
    ReadyLayer *readyLayer = [[ReadyLayer alloc] init];
    [gameScene addChild:readyLayer z:2];
    [[CCDirector sharedDirector] presentScene:gameScene withTransition:[CCTransition transitionFadeWithDuration:MENU_TRANSITION_TIME]];
}

- (void)aboutButtonTapped:(id)sender
{
    //transition layers to the about layer.
    AboutLayer *aboutLayer = [[AboutLayer alloc] initWithBaseLayer:self.baseLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:aboutLayer z:1];
    
    [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[aboutLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)settingsButtonTapped:(id)sender
{
    //transition layers to the settings layer.
    SettingsLayer *settingsLayer = [[SettingsLayer alloc] initWithBaseLayer:self.baseLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:settingsLayer z:1];
    
    [CCActionSequence actionOne:(CCActionFiniteTime *)[self runAction:[CCActionFadeOut actionWithDuration:MENU_TRANSITION_TIME/2]] two:(CCActionFiniteTime *)[settingsLayer runAction:[CCActionFadeIn actionWithDuration:MENU_TRANSITION_TIME/2]]];
    [self removeFromParentAndCleanup:YES];
}

@end
