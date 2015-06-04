//
//  SettingsLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/24/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "SettingsLayer.h"
#import "MainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"

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
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //show the selected button image for settings as the tile of the page.
        CCSprite *settingsTitle = [CCSprite spriteWithFile:@"SettingsButtonSelected.png"];
        settingsTitle.position = ccp(SETTINGS_TITLE_X_COORD, size.height == 568 ? SETTINGS_TITLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : SETTINGS_TITLE_Y_COORD);
        [self addChild:settingsTitle];
        
        //Add the Sound Effects Title.
        CCSprite *soundEffectsTitle = [CCSprite spriteWithFile:@"SoundEffects.png"];
        soundEffectsTitle.position = ccp(SOUND_EFFECTS_TITLE_X_COORD, size.height == 568 ? SOUND_EFFECTS_TITLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : SOUND_EFFECTS_TITLE_Y_COORD);
        [self addChild:soundEffectsTitle];
        
        CCMenuItem *soundEffectsOnMenuItem = [CCMenuItemImage itemWithNormalImage:@"OnButton.png"
                                                                    selectedImage:@"OnButtonSelected.png"
                                                                           target:nil
                                                                         selector:nil];

        CCMenuItem *soundEffectsOffMenuItem = [CCMenuItemImage itemWithNormalImage:@"OffButton.png"
                                                                     selectedImage:@"OffButtonSelected.png"
                                                                            target:nil
                                                                          selector:nil];

        //set the first and second item in the toggle according to the current state of the music setting.
        CCMenuItemToggle *soundEffectsToggleItem;
        if (self.baseMenuLayer.soundEffectsOn) {
            soundEffectsToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                             selector:@selector(soundEffectsSettingButtonTapped:)
                                                                items:soundEffectsOnMenuItem, soundEffectsOffMenuItem, nil];
        } else {
            soundEffectsToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                             selector:@selector(soundEffectsSettingButtonTapped:)
                                                                items:soundEffectsOffMenuItem, soundEffectsOnMenuItem, nil];
        }
        soundEffectsToggleItem.position = ccp(SOUND_EFFECTS_TOGGLE_X_COORD, size.height == 568 ? SOUND_EFFECTS_TOGGLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : SOUND_EFFECTS_TOGGLE_Y_COORD);
        
        //Add the Music Title.
        CCSprite *musicTitle = [CCSprite spriteWithFile:@"Music.png"];
        musicTitle.position = ccp(MUSIC_TITLE_X_COORD, size.height == 568 ? MUSIC_TITLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : MUSIC_TITLE_Y_COORD);
        [self addChild:musicTitle];
        
        CCMenuItem *musicOnMenuItem = [CCMenuItemImage itemWithNormalImage:@"OnButton.png"
                                                             selectedImage:@"OnButtonSelected.png"
                                                                    target:nil
                                                                  selector:nil];

        CCMenuItem *musicOffMenuItem = [CCMenuItemImage itemWithNormalImage:@"OffButton.png"
                                                              selectedImage:@"OffButtonSelected.png"
                                                                     target:nil
                                                                   selector:nil];
        
        //set the first and second item in the toggle according to the current state of the music setting.
        CCMenuItemToggle *musicToggleItem;
        if (self.baseMenuLayer.musicOn) {
            musicToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                      selector:@selector(musicSettingButtonTapped:)
                                                         items:musicOnMenuItem, musicOffMenuItem, nil];
        } else {
            musicToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                      selector:@selector(musicSettingButtonTapped:)
                                                         items:musicOffMenuItem, musicOnMenuItem, nil];
        }
        musicToggleItem.position = ccp(MUSIC_TOGGLE_X_COORD, size.height == 568 ? MUSIC_TOGGLE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : MUSIC_TOGGLE_Y_COORD);
        
        //create the menu.
        CCMenu *menu = [CCMenu menuWithItems:soundEffectsToggleItem, musicToggleItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
        //Create the Backwards Menu Item and put it in its own menu.
        CCMenuItemImage *backwardsMenuItem = [CCMenuItemImage itemWithNormalImage:@"BackButton.png"
                                                                    selectedImage:@"BackButtonSelected.png"
                                                                           target:self
                                                                         selector:@selector(backwardsButtonTapped:)];
        
        CCMenu *backwardsMenu = [CCMenu menuWithItems:backwardsMenuItem, nil];
        backwardsMenu.position = ccp(BACK_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_BACK_Y_COORD : BACK_Y_COORD);
        [self addChild:backwardsMenu];
    }
    return self;
}

- (void)soundEffectsSettingButtonTapped:(id)sender
{
    //toggle the stored setting for sound effects and set the effects volume.
    BOOL newSetting = !self.baseMenuLayer.soundEffectsOn;
    self.baseMenuLayer.soundEffectsOn = newSetting;
    [SimpleAudioEngine sharedEngine].effectsVolume = newSetting ? SOUND_EFFECTS_VOLUME : SILENT;
}

- (void)musicSettingButtonTapped:(id)sender
{
    //toggle the stored setting for music and set the music volume.
    BOOL newSetting = !self.baseMenuLayer.musicOn;
    self.baseMenuLayer.musicOn = newSetting;
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = newSetting ? MUSIC_VOLUME : SILENT;
    
    //restart the music if it is turned back on.
    if (newSetting) [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3"];
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
