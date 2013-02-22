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
//@synthesize containerScene = _containerScene;

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
    if (self = [self init]) {
        
        //authenticate the player when the menu screen is created.
        [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
        
        // ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background;
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            background = [CCSprite spriteWithFile:@"MenuBackground.png"];
            //background.rotation = 90;
        } else {
            background = [CCSprite spriteWithFile:@"MenuBackground.png"];
        }
        background.position = ccp(size.width/2, size.height/2);
        
        // add the background as a child to this Layer
        [self addChild: background z:0];
        
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
        
        //play background music. TODO
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3"];
        //[CDAudioManager sharedManager].backgroundMusic.volume = 0.2f;
        
        self.isTouchEnabled = YES;
        
        [self schedule:@selector(update:)];
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
