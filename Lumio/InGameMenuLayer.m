//
//  InGameMenuLayer.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "InGameMenuLayer.h"
#import "BaseMenuLayer.h"
#import "GameLayer.h"
#import "GameConfig.h"
#import "GameKitHelper.h"

@interface InGameMenuLayer ()

@property (nonatomic) BOOL gameOver;

@end

@implementation InGameMenuLayer

@synthesize gameOver = _gameOver;

- (id)init
{
    if( (self=[super init]) ) {
        
        // ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background;
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            background = [CCSprite spriteWithFile:@"InGameMenu.png"];
            //background.rotation = 90;
        } else {
            background = [CCSprite spriteWithFile:@"InGameMenu.png"];
        }
        background.position = ccp(size.width/2, size.height/2);
        
        // add the background as a child to this Layer
        [self addChild: background z:0];
        
        self.isTouchEnabled = YES;
	}
	return self;
}

- (id)initForPauseMenu
{
    if (self = [self init]) {
        [self setUpMenuWithGameOver:NO score:0];
    }
    return self;
}

- (id)initForGameOverMenuWithScore:(int)score
{
    if (self = [self init]) {
        [self setUpMenuWithGameOver:YES score:score];
    }
    return self;
}

//TODO NEED TO FIX THIS SO IT WORKS OUT IF THE HIGH SCORE WAS LOADED CORRECTLY AND IF IT IS A NEW HIGH SCORE.
- (void)setUpMenuWithGameOver:(BOOL)gameOver score:(int)score
{
    self.gameOver = gameOver;
    
    if (!self.gameOver) {
        NSString *pausedString = @"Paused";
        CCLabelTTF *pausedLabel = [CCLabelTTF labelWithString:pausedString
                                                 dimensions:CGSizeMake(140, 45)
                                                  alignment:UITextAlignmentCenter
                                                   fontName:@"Helvetica"
                                                   fontSize:19];
        pausedLabel.color = ccc3(160, 48, 252);
        pausedLabel.position = ccp(90, 285);
        pausedLabel.anchorPoint = ccp(0, 0);
        [self addChild:pausedLabel];
    } else {
        //get the old high score if possible and see if this score beats it.
        GameKitHelper *helper = [GameKitHelper sharedGameKitHelper];
        int64_t highScore = 3000; // TEMP helper.highScore;
        helper.highScoreFetchedOK = YES; // TEMP remove entirely!
        BOOL isNewHighScore = NO;
        if (helper.highScoreFetchedOK && (int64_t)score > highScore) {
            //store the new high score. The high score will only be loaded from game center the first time.
            isNewHighScore = YES;
            highScore = (int64_t)score;
            helper.highScore = highScore;
        }
        
        NSString *scoreString = [NSString stringWithFormat:@"Score:\n%d", score];
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:scoreString
                                                   dimensions:CGSizeMake(140, 45)
                                                    alignment:UITextAlignmentCenter
                                                     fontName:@"Helvetica"
                                                     fontSize:19];
        scoreLabel.color = ccc3(160, 48, 252);
        scoreLabel.position = ccp(90, 285);
        scoreLabel.anchorPoint = ccp(0, 0);
        [self addChild:scoreLabel];
        
        if (helper.highScoreFetchedOK) {
            NSString *highScoreString;
            if (isNewHighScore) {
                highScoreString = @"New High\nScore!";
            } else {
                highScoreString = [NSString stringWithFormat:@"High Score:\n%lld", highScore];
            }
            CCLabelTTF *highScoreLabel = [CCLabelTTF labelWithString:highScoreString
                                                      dimensions:CGSizeMake(140, 45)
                                                       alignment:UITextAlignmentCenter
                                                        fontName:@"Helvetica"
                                                        fontSize:19];
            highScoreLabel.color = ccc3(184, 108, 252);
            highScoreLabel.position = ccp(90, 235);
            highScoreLabel.anchorPoint = ccp(0, 0);
            [self addChild:highScoreLabel];
        }
    }
    
    //Create the Resume Menu Item.
    CCMenuItemImage *resumeMenuItem = [CCMenuItemImage
                                itemWithNormalImage:@"NewResumeButton.png" selectedImage:@"NewResumeButtonSelected.png"
                                target:self selector:@selector(resumeButtonTapped:)];
    resumeMenuItem.anchorPoint = ccp(0, 1);
    resumeMenuItem.position = ccp(100, 255);
    
    //Create the Restart Menu Item.
    CCMenuItemImage *restartMenuItem = [CCMenuItemImage
                                  itemWithNormalImage:@"NewRestartButton.png" selectedImage:@"NewRestartButtonSelected.png"
                                  target:self selector:@selector(restartButtonTapped:)];
    restartMenuItem.anchorPoint = ccp(0, 1);
    
    //Change the position based on whether it is a game over screen.
    if (self.gameOver) {
        restartMenuItem.position = ccp(100, 215);
    } else {
        restartMenuItem.position = ccp(100, 215);
    }
    
    //Create the 'Main Menu' Menu Item.
    CCMenuItem *mainMenuMenuItem = [CCMenuItemImage
                                   itemWithNormalImage:@"NewMainMenuButton.png" selectedImage:@"NewMainMenuButtonSelected.png"
                                   target:self selector:@selector(mainMenuButtonTapped:)];
    mainMenuMenuItem.anchorPoint = ccp(0, 1);
    
    //Change the position based on whether it is a game over screen.
    if (self.gameOver) {
        mainMenuMenuItem.position = ccp(100, 175);
    } else {
        mainMenuMenuItem.position = ccp(100, 175);
    }

    //Only add resumeMenuItem it is not a game over screen.
    CCMenu *inGameMenu;
    if (self.gameOver) {
        inGameMenu = [CCMenu menuWithItems:restartMenuItem, mainMenuMenuItem, nil];
    } else {
        inGameMenu = [CCMenu menuWithItems:resumeMenuItem, restartMenuItem, mainMenuMenuItem, nil];
    }
    inGameMenu.position = CGPointZero;
    [self addChild:inGameMenu];
}

//prevent touches going to over layers.
- (void)registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)resumeButtonTapped:(id)sender
{
    GameLayer *gameLayer = (GameLayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:GAME_LAYER_TAG];
    [gameLayer unPauseGame];
    [self removeFromParentAndCleanup:YES];
}

- (void)restartButtonTapped:(id)sender
{
    GameLayer *gameLayer = (GameLayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:GAME_LAYER_TAG];
    [gameLayer restartGame];
    [self removeFromParentAndCleanup:YES];
}

- (void)mainMenuButtonTapped:(id)sender
{
    //remove the pause layer but do not unpause the game and push the menu scene. The new scene should only be provided the current scene if continue should be displayed (because it is not game over).
    [self removeFromParentAndCleanup:YES];
    CCScene *currentScene = [[CCDirector sharedDirector] runningScene];
    if (self.gameOver) {
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.6 scene:[BaseMenuLayer scene] withColor:ccBLACK]];
    } else {
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.6 scene:[BaseMenuLayer sceneWithPreviousScene:currentScene] withColor:ccBLACK]];
    }
}

//TODO saving game and opening on main menu i guess (not pause screen).

@end
