//
//  SettingsLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/24/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "SettingsLayer.h"
#import "MainMenuLayer.h"
#import "GameConfig.h"
#import "CCButton.h"

//layer for the Settings menu.
@interface SettingsLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

@end

@implementation SettingsLayer

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue
{
    if (self = [super init]) {
        self.baseMenuLayer = baseLayer;
        self.showContinue = showContinue;
        
        CGSize size = [CCDirector sharedDirector].viewSize;
        
        //show the selected button image for settings as the tile of the page.
        CCSprite *settingsTitle = [CCSprite spriteWithImageNamed:@"SettingsButtonSelected.png"];
        settingsTitle.position = ccp(SETTINGS_TITLE_X_COORD, size.height == 568 ? SETTINGS_TITLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : SETTINGS_TITLE_Y_COORD);
        [self addChild:settingsTitle];
        
        //Add the Sound Effects Title.
        CCSprite *soundEffectsTitle = [CCSprite spriteWithImageNamed:@"SoundEffects.png"];
        soundEffectsTitle.position = ccp(SOUND_EFFECTS_TITLE_X_COORD, size.height == 568 ? SOUND_EFFECTS_TITLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : SOUND_EFFECTS_TITLE_Y_COORD);
        [self addChild:soundEffectsTitle];
        
        CCButton *soundEffectsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"OnButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"OffButton.png"] disabledSpriteFrame:nil];
        [soundEffectsButton setTarget:self selector:@selector(soundEffectsSettingButtonTapped:)];
        soundEffectsButton.togglesSelectedState = YES;
        soundEffectsButton.selected = !self.baseMenuLayer.soundEffectsOn;
        
        soundEffectsButton.position = ccp(SOUND_EFFECTS_TOGGLE_X_COORD, size.height == 568 ? SOUND_EFFECTS_TOGGLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : SOUND_EFFECTS_TOGGLE_Y_COORD);
        [self addChild:soundEffectsButton];
        
        //Add the Music Title.
        CCSprite *musicTitle = [CCSprite spriteWithImageNamed:@"Music.png"];
        musicTitle.position = ccp(MUSIC_TITLE_X_COORD, size.height == 568 ? MUSIC_TITLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : MUSIC_TITLE_Y_COORD);
        [self addChild:musicTitle];
        
        CCButton *musicButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"OnButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"OffButton.png"] disabledSpriteFrame:nil];
        [musicButton setTarget:self selector:@selector(musicSettingButtonTapped:)];
        musicButton.togglesSelectedState = YES;
        musicButton.selected = !self.baseMenuLayer.musicOn;
        musicButton.position = ccp(MUSIC_TOGGLE_X_COORD, size.height == 568 ? MUSIC_TOGGLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : MUSIC_TOGGLE_Y_COORD);
        [self addChild:musicButton];
        
        //Create the Backwards Menu Item and put it in its own menu.
        CCButton *backwardsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackButtonSelected.png"] disabledSpriteFrame:nil];
        [backwardsButton setTarget:self selector:@selector(backwardsButtonTapped:)];
        backwardsButton.position = ccp(BACK_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_BACK_Y_COORD : BACK_Y_COORD);
        [self addChild:backwardsButton];
    }
    return self;
}

- (void)soundEffectsSettingButtonTapped:(id)sender
{
    //toggle the stored setting for sound effects and set the effects volume.
    BOOL newSetting = !self.baseMenuLayer.soundEffectsOn;
    self.baseMenuLayer.soundEffectsOn = newSetting;
    [OALSimpleAudio sharedInstance].effectsVolume = newSetting ? SOUND_EFFECTS_VOLUME : SILENT;
}

- (void)musicSettingButtonTapped:(id)sender
{
    //toggle the stored setting for music and set the music volume.
    BOOL newSetting = !self.baseMenuLayer.musicOn;
    self.baseMenuLayer.musicOn = newSetting;
    [OALSimpleAudio sharedInstance].bgVolume = newSetting ? MUSIC_VOLUME : SILENT;
    
    //restart the music if it is turned back on.
    if (newSetting) [[OALSimpleAudio sharedInstance] playBgWithLoop:YES];
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
