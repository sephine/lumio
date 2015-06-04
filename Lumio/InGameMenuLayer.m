//
//  InGameMenuLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "InGameMenuLayer.h"
#import "BaseMenuLayer.h"
#import "GameLayer.h"
#import "GameConfig.h"
#import "GameKitHelper.h"

//layer covers the game layer when the game is paused or on game over.
@interface InGameMenuLayer ()

@property (nonatomic) BOOL gameOver;

@end

@implementation InGameMenuLayer

- (id)init
{
    if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"InGameMenu.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild: background z:0];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

//init the scene for the pause menu. Will display a pause title and show the resume button.
- (id)initForPauseMenu
{
    if (self = [self init]) {
        [self setUpMenuWithGameOver:NO score:0];
    }
    return self;
}

//init the scene for the game over menu. Will display the score and high score and hide the resume button.
- (id)initForGameOverMenuWithScore:(int)score
{
    if (self = [self init]) {
        [self setUpMenuWithGameOver:YES score:score];
    }
    return self;
}

//adds all the appropriate labels and menu items to the screen.
- (void)setUpMenuWithGameOver:(BOOL)gameOver score:(int)score
{
    self.gameOver = gameOver;
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    //if it is not game over, show the paused title.
    if (!self.gameOver) {
        NSString *pausedString = @"Paused";
        CCLabelTTF *pausedLabel = [CCLabelTTF labelWithString:pausedString
                                                 dimensions:CGSizeMake(PAUSED_LABEL_WIDTH, PAUSED_LABEL_HEIGHT)
                                                  alignment:UITextAlignmentCenter
                                                   fontName:FONT_NAME
                                                   fontSize:FONT_SIZE];
        pausedLabel.color = STANDARD_PURPLE;
        pausedLabel.position = ccp(PAUSED_LABEL_X_COORD, size.height == 568 ? PAUSED_LABEL_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : PAUSED_LABEL_Y_COORD);
        pausedLabel.anchorPoint = ccp(PAUSED_LABEL_ANCHOR_X_COORD, PAUSED_LABEL_ANCHOR_Y_COORD);
        [self addChild:pausedLabel];
    } else {
        //get the old high score (initially it will be taken from game center then replaced with any new high scores you get as you play) if possible and see if this score beats it. Display the high score if it exists or a message saying you have a new high score or nothing as appropriate.
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
        scoreLabel.position = ccp(SCORE_LABEL_X_COORD, size.height == 568 ? SCORE_LABEL_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : SCORE_LABEL_Y_COORD);
        scoreLabel.anchorPoint = ccp(SCORE_LABEL_ANCHOR_X_COORD, SCORE_LABEL_ANCHOR_Y_COORD);
        [self addChild:scoreLabel];
        
        //show the high score or new high score label or nothing if no stored high score exists.
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
            highScoreLabel.position = ccp(HIGH_SCORE_LABEL_X_COORD, size.height == 568 ? HIGH_SCORE_LABEL_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : HIGH_SCORE_LABEL_Y_COORD);
            highScoreLabel.anchorPoint = ccp(HIGH_SCORE_LABEL_ANCHOR_X_COORD, HIGH_SCORE_LABEL_ANCHOR_Y_COORD);
            [self addChild:highScoreLabel];
        }
    }
    
    CCMenuItemImage *resumeMenuItem = [CCMenuItemImage
                                       itemWithNormalImage:@"NewResumeButton.png"
                                       selectedImage:@"NewResumeButtonSelected.png"
                                       target:self
                                       selector:@selector(resumeButtonTapped:)];
    resumeMenuItem.position = ccp(RESUME_BUTTON_X_COORD, size.height == 568 ? RESUME_BUTTON_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : RESUME_BUTTON_Y_COORD);
    
    CCMenuItemImage *restartMenuItem = [CCMenuItemImage
                                        itemWithNormalImage:@"NewRestartButton.png"
                                        selectedImage:@"NewRestartButtonSelected.png"
                                        target:self
                                        selector:@selector(restartButtonTapped:)];
    restartMenuItem.position = ccp(RESTART_BUTTON_X_COORD, size.height == 568 ? RESTART_BUTTON_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : RESTART_BUTTON_Y_COORD);

    
    CCMenuItem *mainMenuMenuItem = [CCMenuItemImage
                                    itemWithNormalImage:@"NewMainMenuButton.png"
                                    selectedImage:@"NewMainMenuButtonSelected.png"
                                    target:self
                                    selector:@selector(mainMenuButtonTapped:)];
    mainMenuMenuItem.position = ccp(MENU_BUTTON_X_COORD, size.height == 568 ? MENU_BUTTON_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : MENU_BUTTON_Y_COORD);

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

//prevent touches going to over layers. No touches need actually be handled as UIMenus handle their own touches.
- (void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

//will remove the in game menu and unpause the game (only available when it is not game over)
- (void)resumeButtonTapped:(id)sender
{
    GameLayer *gameLayer = (GameLayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:GAME_LAYER_TAG];
    [gameLayer unPauseGame];
    [self removeFromParentAndCleanup:YES];
}

//will remove the in game menu and restart the game.
- (void)restartButtonTapped:(id)sender
{
    GameLayer *gameLayer = (GameLayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:GAME_LAYER_TAG];
    [gameLayer restartGame];
    [self removeFromParentAndCleanup:YES];
}

//transition the menu scene and pass the current scene (so the game can be resumed) if it isn't game over.
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
