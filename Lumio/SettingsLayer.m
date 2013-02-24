//
//  SettingsLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SettingsLayer.h"
#import "MainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"

@interface SettingsLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

@end

@implementation SettingsLayer

@synthesize baseMenuLayer = _baseMenuLayer;
@synthesize showContinue = _showContinue;

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue
{
    if (self = [super init]) {
        self.baseMenuLayer = baseLayer;
        self.showContinue = showContinue;
        
        //TODO for now show the selected button image for settings as the tile of the page.
        CCSprite *settingsTitle = [CCSprite spriteWithFile:@"SettingsButtonSelected.png"];
        settingsTitle.position = ccp(160, 330);
        [self addChild:settingsTitle];
        
        //Add the Sound Effects Title.
        CCSprite *soundEffectsTitle = [CCSprite spriteWithFile:@"SoundEffects.png"];
        soundEffectsTitle.position = ccp(160, 275);
        [self addChild:soundEffectsTitle];
        
        //Create the Sound Effects Setting Toggle Menu Items.
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
        soundEffectsToggleItem.position = ccp(160, 240);
        
        //Add the Music Title.
        CCSprite *musicTitle = [CCSprite spriteWithFile:@"Music.png"];
        musicTitle.position = ccp(160, 195);
        [self addChild:musicTitle];
        
        //Create the Music Setting Menu Item.
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
        musicToggleItem.position = ccp(160, 160);
        
        //create the menu.
        CCMenu *menu = [CCMenu menuWithItems:soundEffectsToggleItem, musicToggleItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
        //Create the Backwards Menu Item and put it in its own menu.
        CCMenuItemImage *backwardsMenuItem = [CCMenuItemImage itemWithNormalImage:@"BackwardsButton.png"
                                                                    selectedImage:@"BackwardsButtonSelected.png"
                                                                           target:self
                                                                         selector:@selector(backwardsButtonTapped:)];
        
        CCMenu *backwardsMenu = [CCMenu menuWithItems:backwardsMenuItem, nil];
        backwardsMenu.position = ccp(40, 40);
        [self addChild:backwardsMenu];
    }
    return self;
}

- (void)soundEffectsSettingButtonTapped:(id)sender
{
    BOOL newSetting = !self.baseMenuLayer.soundEffectsOn;
    self.baseMenuLayer.soundEffectsOn = newSetting;
    [SimpleAudioEngine sharedEngine].effectsVolume = newSetting ? SOUND_EFFECTS_VOLUME : 0;
}

- (void)musicSettingButtonTapped:(id)sender
{
    BOOL newSetting = !self.baseMenuLayer.musicOn;
    self.baseMenuLayer.musicOn = newSetting;
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = newSetting ? MUSIC_VOLUME : 0;
    
    //restart the music if it is turned back on.
    if (newSetting) [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3"];
}

- (void)backwardsButtonTapped:(id)sender
{
    MainMenuLayer *mainMenuLayer = [[MainMenuLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    [[[CCDirector sharedDirector] runningScene] addChild:mainMenuLayer z:2];
    
    [CCSequence actionOne:[self runAction:[CCFadeOut actionWithDuration:0.3]] two:[mainMenuLayer runAction:[CCFadeIn actionWithDuration:0.3]]];
    [self removeFromParentAndCleanup:YES];
}

@end
