//
//  MenuLayer.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BaseMenuLayer.h"
#import "GameLayer.h"
#import "MenuCircleGenerator.h"
#import "MainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"
#import "GameKitHelper.h"

@interface BaseMenuLayer ()

@property (nonatomic, strong) MenuCircleGenerator *circles;
//@property (nonatomic, strong) CCScene *containerScene;

@end

@implementation BaseMenuLayer

@synthesize gameScene = _gameScene;
@synthesize circles = _circles;

- (BOOL)soundEffectsOn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL soundEffectsOn;
    if ([defaults objectForKey:SOUND_EFFECTS_ON_KEY]) {
        soundEffectsOn = [defaults boolForKey:SOUND_EFFECTS_ON_KEY];
    } else {
        soundEffectsOn = YES;
        [defaults setBool:soundEffectsOn forKey:SOUND_EFFECTS_ON_KEY];
    }
    return soundEffectsOn;
}

- (void)setSoundEffectsOn:(BOOL)soundEffectsOn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:soundEffectsOn forKey:SOUND_EFFECTS_ON_KEY];
}

- (BOOL)musicOn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL musicOn;
    if ([defaults objectForKey:MUSIC_ON_KEY]) {
        musicOn = [defaults boolForKey:MUSIC_ON_KEY];
    } else {
        musicOn = YES;
        [defaults setBool:musicOn forKey:MUSIC_ON_KEY];
    }
    return musicOn;
}

- (void)setMusicOn:(BOOL)musicOn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:musicOn forKey:MUSIC_ON_KEY];
}

- (BOOL)firstPlay
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL firstPlay;
    if ([defaults objectForKey:FIRST_PLAY_KEY]) {
        firstPlay = [defaults boolForKey:FIRST_PLAY_KEY];
    } else {
        firstPlay = YES;
        [defaults setBool:firstPlay forKey:FIRST_PLAY_KEY];
    }
    return firstPlay;
}

- (void)setFirstPlay:(BOOL)firstPlay
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:firstPlay forKey:FIRST_PLAY_KEY];
}

// Helper class method that creates a Scene with the MenuLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BaseMenuLayer *layer = [[BaseMenuLayer alloc] initWithPreviousScene:nil];
	
	// add layer as a child to scene
	[scene addChild: layer z:0];
	
	// return the scene
	return scene;
}

+ (CCScene *)sceneWithPreviousScene:(CCScene *)previousScene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BaseMenuLayer *layer = [[BaseMenuLayer alloc] initWithPreviousScene:previousScene];
	
	// add layer as a child to scene
	[scene addChild: layer z:0];
	
	// return the scene
	return scene;
}

- (id)initWithPreviousScene:(CCScene *)previousScene
{
    if( (self=[super initWithColor:ccc4(15, 15, 15, 255)]) ) {
        
        //authenticate the player and preload the sound and music when the menu screen is shown for the first time.
        GameKitHelper *helper = [GameKitHelper sharedGameKitHelper];
        if (!helper.authenticationAttempted) {
            [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
            
            //preload sound and music.
            SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
            [sae preloadEffect:@"levelUpSoundEfect.wav"];
            [sae preloadEffect:@"purpleSoundEfect.wav"];
            [sae preloadEffect:@"warningSoundEfect.wav"];
            [sae preloadBackgroundMusic:@"music.mp3"];
            //TODO add all the other sounds and music.
            
            //load sound and music settings and set the volumes accordingly.
            sae.effectsVolume = self.soundEffectsOn ? SOUND_EFFECTS_VOLUME : 0;
            sae.backgroundMusicVolume = self.musicOn ? MUSIC_VOLUME : 0;
            
            //play background music. TODO
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3"];
        }
        
        //create the menu circle generator.
        self.circles = [[MenuCircleGenerator alloc] initWithMenuLayer:self];
        
        //currently if a previous scene is provided it will always be the game scene. Create the main menu layer scene with continue or not as appropriate.
        MainMenuLayer *menuLayer;
        if (previousScene) {
            self.gameScene = previousScene;
            menuLayer = [[MainMenuLayer alloc] initWithBaseLayer:self showContinue:YES];
        } else {
            menuLayer = [[MainMenuLayer alloc] initWithBaseLayer:self showContinue:NO];
        }
        [self addChild:menuLayer z:1];
        
        self.isTouchEnabled = YES;
        
        [self schedule:@selector(update:)];
        
        //TODO add button press sound.
    }
    return self;
}

- (void)update:(ccTime)dt {
    [self.circles update:dt];
}

//prevent touches going to over layers.
- (void)registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

@end
