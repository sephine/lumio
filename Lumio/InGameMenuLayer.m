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
                                                 dimensions:CGSizeMake(PAUSED_LABEL_WIDTH, PAUSED_LABEL_HEIGHT)
                                                  alignment:UITextAlignmentCenter
                                                   fontName:FONT_NAME
                                                   fontSize:FONT_SIZE];
        pausedLabel.color = STANDARD_PURPLE;
        pausedLabel.position = ccp(PAUSED_LABEL_X_COORD, PAUSED_LABEL_Y_COORD);
        pausedLabel.anchorPoint = ccp(PAUSED_LABEL_ANCHOR_X_COORD, PAUSED_LABEL_ANCHOR_Y_COORD);
        [self addChild:pausedLabel];
    } else {
        //get the old high score if possible and see if this score beats it.
        GameKitHelper *helper = [GameKitHelper sharedGameKitHelper];
        int64_t highScore = helper.highScore;
        BOOL isNewHighScore = NO;
        if (helper.highScoreFetchedOK && (int64_t)score > highScore) {
            //store the new high score. The high score will only be loaded from game center the first time.
            isNewHighScore = YES;
            highScore = (int64_t)score;
            helper.highScore = highScore;
        }
        
        NSString *scoreString = [NSString stringWithFormat:@"Score:\n%d", score];
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:scoreString
                                                   dimensions:CGSizeMake(SCORE_LABEL_WIDTH, SCORE_LABEL_HEIGHT)
                                                    alignment:UITextAlignmentCenter
                                                     fontName:FONT_NAME
                                                     fontSize:FONT_SIZE];
        scoreLabel.color = STANDARD_PURPLE;
        scoreLabel.position = ccp(SCORE_LABEL_X_COORD, SCORE_LABEL_Y_COORD);
        scoreLabel.anchorPoint = ccp(SCORE_LABEL_ANCHOR_X_COORD, SCORE_LABEL_ANCHOR_Y_COORD);
        [self addChild:scoreLabel];
        
        if (helper.highScoreFetchedOK) {
            NSString *highScoreString;
            if (isNewHighScore) {
                highScoreString = @"New High\nScore!";
            } else {
                highScoreString = [NSString stringWithFormat:@"High Score:\n%lld", highScore];
            }
            CCLabelTTF *highScoreLabel = [CCLabelTTF labelWithString:highScoreString
                                                      dimensions:CGSizeMake(HIGH_SCORE_LABEL_WIDTH, HIGH_SCORE_LABEL_HEIGHT)
                                                       alignment:UITextAlignmentCenter
                                                        fontName:FONT_NAME
                                                        fontSize:FONT_SIZE];
            highScoreLabel.color = STANDARD_PINK;
            highScoreLabel.position = ccp(HIGH_SCORE_LABEL_X_COORD, HIGH_SCORE_LABEL_Y_COORD);
            highScoreLabel.anchorPoint = ccp(HIGH_SCORE_LABEL_ANCHOR_X_COORD, HIGH_SCORE_LABEL_ANCHOR_Y_COORD);
            [self addChild:highScoreLabel];
        }
    }
    
    //Create the Resume Menu Item.
    CCMenuItemImage *resumeMenuItem = [CCMenuItemImage
                                itemWithNormalImage:@"NewResumeButton.png" selectedImage:@"NewResumeButtonSelected.png"
                                target:self selector:@selector(resumeButtonTapped:)];
    resumeMenuItem.position = ccp(RESUME_BUTTON_X_COORD, RESUME_BUTTON_Y_COORD);
    
    //Create the Restart Menu Item.
    CCMenuItemImage *restartMenuItem = [CCMenuItemImage
                                  itemWithNormalImage:@"NewRestartButton.png" selectedImage:@"NewRestartButtonSelected.png"
                                  target:self selector:@selector(restartButtonTapped:)];
    restartMenuItem.position = ccp(RESTART_BUTTON_X_COORD, RESTART_BUTTON_Y_COORD);

    
    //Create the 'Main Menu' Menu Item.
    CCMenuItem *mainMenuMenuItem = [CCMenuItemImage
                                   itemWithNormalImage:@"NewMainMenuButton.png" selectedImage:@"NewMainMenuButtonSelected.png"
                                   target:self selector:@selector(mainMenuButtonTapped:)];
    mainMenuMenuItem.position = ccp(MENU_BUTTON_X_COORD, MENU_BUTTON_Y_COORD);

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
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:MENU_TRANSITION_TIME scene:[BaseMenuLayer scene] withColor:ccBLACK]];
    } else {
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:MENU_TRANSITION_TIME scene:[BaseMenuLayer sceneWithPreviousScene:currentScene] withColor:ccBLACK]];
    }
}

@end
