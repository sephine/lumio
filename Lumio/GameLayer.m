//
//  GameLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright Joanne Dyer 2013. All rights reserved.
//

#import "GameLayer.h"
#import "InGameMenuLayer.h"
#import "ReadyLayer.h"
#import "LightManager.h"
#import "Light.h"
#import "Route.h"
#import "Player.h"
#import "CountdownBar.h"
#import "Level.h"
#import "Score.h"
#import "GameKitHelper.h"
#import "GameConfig.h"
#import "CCButton.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - GameLayer

//Game Layer controls all the game objects and handles pausing and game over.
@interface GameLayer ()

@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Route *route;
@property (nonatomic, strong) LightManager *lightManager;
@property (nonatomic, strong) CountdownBar * countdownBar;
@property (nonatomic, strong) Level *level;
@property (nonatomic, strong) Score *score;

@end

@implementation GameLayer

- (void)setGameIsPaused:(BOOL)gameIsPaused {
    _gameIsPaused = gameIsPaused;
    self.paused = gameIsPaused;
}

// Helper class method that creates a Scene with the GameLayer as the only child.
+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    GameLayer *gameLayer = [GameLayer node];
    
    //readylayer will initially cover the paused game layer.
    ReadyLayer *readyLayer = [ReadyLayer node];
	
    [scene addChild:gameLayer z:0 name:GAME_LAYER_TAG];
    [scene addChild:readyLayer z:1];
	
    return scene;
}

-(id) init
{
    if( (self=[super initWithColor:STANDARD_BACKGROUND]) ) {
        
        //gamelayer starts paused and covered by the ready layer.
        self.gameIsPaused = YES;
        
        CGSize size = [CCDirector sharedDirector].viewSize;
        self.contentSize = size;
        
        //add the header which will include the countdown bar and the pause button.
        CCSprite *header = [CCSprite spriteWithImageNamed:@"topmenu.png"];
        header.position = ccp(HEADER_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_HEADER_Y_COORD : HEADER_Y_COORD);
        [self addChild:header z:0];
        
        //create the countdown bar and set its position. It adds itself to the layer.
        self.countdownBar = [[CountdownBar alloc] initWithGameLayer:self];
        self.countdownBar.position = ccp(COUNTDOWN_BAR_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_COUNTDOWN_BAR_Y_COORD : COUNTDOWN_BAR_Y_COORD);
        
        CCButton *pauseButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"pause.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"pause.png"] disabledSpriteFrame:nil];
        [pauseButton setTarget:self selector:@selector(pauseButtonTapped:)];
        pauseButton.position = ccp(PAUSE_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_PAUSE_Y_COORD : PAUSE_Y_COORD);
        [self addChild:pauseButton];
        
        CCSprite *footer = [CCSprite spriteWithImageNamed:@"footer.png"];
        footer.position = ccp(FOOTER_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_FOOTER_Y_COORD : FOOTER_Y_COORD);
        [self addChild:footer z:0];
        
        self.player = [[Player alloc] init];
        
        // create and initialize all the lights.
        NSMutableArray *twoDimensionallightArray = [NSMutableArray array];
        for (int row = 0; row < NUMBER_OF_ROWS; row++) {
            NSMutableArray *innerArray = [NSMutableArray array];
            for (int column = 0; column < NUMBER_OF_COLUMNS; column++) {
                Light *light = [[Light alloc] initWithGameLayer:self row:row column:column];
                CGFloat x = GAME_AREA_X_COORD + SQUARE_SIDE_LENGTH * (column + 0.5f);
                CGFloat y = GAME_AREA_Y_COORD + SQUARE_SIDE_LENGTH * (row + 0.5f);
                light.position = ccp(x, size.height == 568 ? y + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : y);
                [innerArray addObject:light];
            }
            [twoDimensionallightArray addObject:innerArray];
        }
        
        //set the middle light to the initial light.
        Light *firstLight = [[twoDimensionallightArray objectAtIndex:MIDDLE_ROW_INDEX] objectAtIndex:MIDDLE_COLUMN_INDEX];
        [firstLight setAsInitialLight];
        
        self.lightManager = [[LightManager alloc] initWithGameLayer:self lightArray:twoDimensionallightArray];
        
        //choose a high, medium, low and two charge new value lights from all the added lights.
        [self.lightManager chooseFirstLightWithValue:High];
        [self.lightManager chooseFirstLightWithValue:Medium];
        [self.lightManager chooseFirstLightWithValue:Low];
        [self.lightManager chooseFirstLightWithValue:Charge];
        [self.lightManager chooseFirstLightWithValue:Charge];
        
        self.level = [[Level alloc] initWithGameLayer:self countdownBar:self.countdownBar lightManager:self.lightManager];
        self.level.position = ccp(LEVEL_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_LEVEL_Y_COORD : LEVEL_Y_COORD);
        
        self.score = [[Score alloc] initWithGameLayer:self level:self.level];
        self.score.position = ccp(SCORE_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_SCORE_Y_COORD : SCORE_Y_COORD);
        
        self.route = [[Route alloc] initWithGameLayer:self lightManager:self.lightManager];
        
        //add the player starting position to the route.
        [self.route setInitialLight:firstLight];
        
        self.player = [[Player alloc] initWithGameLayer:self route:self.route currentLight:firstLight countdownBar:self.countdownBar score:self.score];
    
        self.userInteractionEnabled = YES;
    }
    return self;
}

//- (void)registerWithTouchDispatcher
//{
//    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
//}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

//handles when the user taps the lights.
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertToNodeSpace:touch.locationInWorld];
    //find if any of the lights were touched and then call selected light on it.
    Light *selectedLight = [self.lightManager getSelectedLightFromLocation:location];
    if (selectedLight) {
        [self.route lightSelected:selectedLight];
    }
}

- (void)pauseButtonTapped:(id)sender
{
    //make sure the button does nothing if the game is already paused.
    if (!self.gameIsPaused) {
        self.gameIsPaused = YES;
        InGameMenuLayer *menuLayer = [[InGameMenuLayer alloc] initForPauseMenu];
        [[[CCDirector sharedDirector] runningScene] addChild:menuLayer z:1];
    }
}

//called by the countdown bar when it empties
- (void)gameOver
{
    self.gameIsPaused = YES;
    
    //submit score to game center.
    int score = self.score.scoreValue;
    
    GameKitHelper *helper = [GameKitHelper sharedGameKitHelper];
    [helper submitScore:score];
    
    //pass score to ingame menu layer for display
    InGameMenuLayer *menuLayer = [[InGameMenuLayer alloc] initForGameOverMenuWithScore:score];
    [[[CCDirector sharedDirector] runningScene] addChild:menuLayer z:1];
}

- (void)unPauseGame
{
    self.gameIsPaused = NO;
}

//restarts game by creating a new copy of the game scene to replace the current one. 
- (void)restartGame
{
    //remove layer and then add it again.
    [self removeFromParentAndCleanup:YES];
    GameLayer *layer = [GameLayer node];
    [layer unPauseGame];
    [[[CCDirector sharedDirector] runningScene] addChild:layer z:0 name:GAME_LAYER_TAG];
}

@end
