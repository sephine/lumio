//
//  MenuLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "BaseMenuLayer.h"
#import "GameLayer.h"
#import "MenuCircleGenerator.h"
#import "MainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"
#import "GameKitHelper.h"

//layer that acts as a base to all the menu layers. Creates a containing scene.
@interface BaseMenuLayer ()

//the menu circle generator creates the animated circles in the background of the menus.
@property (nonatomic, strong) MenuCircleGenerator *circles;

@end

@implementation BaseMenuLayer

//gets and sets information to NSUserDefaults to save whether the sound effects should be turned on.
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

//gets and sets information to NSUserDefaults to save whether the music should be turned on.
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

//gets and sets information to NSUserDefaults to ensure that the how to play screens are only shown the first time a game is played.
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

// Helper class method that creates a Scene with the BaseMenuLayer as the only child.
//Called when the main menu is being created the first time or from the game layer on game over.
+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    BaseMenuLayer *layer = [[BaseMenuLayer alloc] initWithPreviousScene:nil];
	
    [scene addChild: layer z:0];
    return scene;
}

//Called when a game in in progress and the menu is re-opened.
+ (CCScene *)sceneWithPreviousScene:(CCScene *)previousScene
{
    CCScene *scene = [CCScene node];
    BaseMenuLayer *layer = [[BaseMenuLayer alloc] initWithPreviousScene:previousScene];
	
    [scene addChild: layer z:0];
    return scene;
}

- (id)initWithPreviousScene:(CCScene *)previousScene
{
    if( (self=[super initWithColor:STANDARD_BACKGROUND]) ) {
        
        //authenticate the player and preload the sound and music when the menu screen is shown for the first time.
        GameKitHelper *helper = [GameKitHelper sharedGameKitHelper];
        if (!helper.authenticationAttempted) {
            //delay authenticating the player until the transition has finished so that the banner appearing doesn't make it stutter.
            [[GameKitHelper sharedGameKitHelper] performSelector:@selector(authenticateLocalPlayer) withObject:nil afterDelay:INTRO_TRANSITION_TIME];
            
            SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
            [sae preloadEffect:@"levelUpSoundEfect.wav"];
            [sae preloadEffect:@"purpleSoundEfect.wav"];
            [sae preloadEffect:@"warningSoundEfect.wav"];
            [sae preloadBackgroundMusic:@"music.mp3"];
            
            sae.effectsVolume = self.soundEffectsOn ? SOUND_EFFECTS_VOLUME : 0;
            sae.backgroundMusicVolume = self.musicOn ? MUSIC_VOLUME : 0;
            
            //play the background music, it will automatically loop.
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3"];
        }
        
        //create the menu circle generator.
        self.circles = [[MenuCircleGenerator alloc] initWithMenuLayer:self];
        
        //if a previous scene is provided it will always be the game scene. Create the main menu layer scene with continue or not as appropriate.
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
    }
    return self;
}

//this is used to animate the circles each frame.
- (void)update:(ccTime)dt {
    [self.circles update:dt];
}

//prevent touches going to over layers. No touches need actually be handled as UIMenus handle their own touches.
- (void)registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

@end
