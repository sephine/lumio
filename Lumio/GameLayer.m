//
//  GameLayer.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
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

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - GameLayer

@interface GameLayer ()

@property (nonatomic, strong) CCMenu *menuItems;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Route *route;
@property (nonatomic, strong) LightManager *lightManager;
@property (nonatomic, strong) CountdownBar * countdownBar;
@property (nonatomic, strong) Level *level;
@property (nonatomic, strong) Score *score;

@end

// HelloWorldLayer implementation
@implementation GameLayer

@synthesize menuItems = _menuItems;
@synthesize gameIsPaused = _gameIsPaused;
@synthesize player = _player;
@synthesize route = _route;
@synthesize lightManager = _lightManager;
@synthesize countdownBar = _countdownBar;
@synthesize level = _level;
@synthesize score = _score;

// Helper class method that creates a Scene with the GameLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'gameLayer' is an autorelease object.
	GameLayer *gameLayer = [GameLayer node];
    
    //readylayer will initially cover the paused game layer.
    ReadyLayer *readyLayer = [ReadyLayer node];
	
	// add gameLayer as a child to scene
	[scene addChild:gameLayer z:0 tag:GAME_LAYER_TAG];
    [scene addChild:readyLayer z:1];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:STANDARD_BACKGROUND]) ) {
        
        //gamelayer starts paused and covered by the ready layer.
        self.gameIsPaused = YES;
        
        // ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //add the header which will include the countdown bar and the pause button.
        CCSprite *header = [CCSprite spriteWithFile:@"topmenu.png"];
        header.position = ccp(HEADER_X_COORD, size.height == 568 ? HEADER_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : HEADER_Y_COORD);
        [self addChild:header z:0];
        
        //create the countdown bar and set its position. It adds itself to the layer.
        self.countdownBar = [[CountdownBar alloc] initWithGameLayer:self];
        self.countdownBar.position = ccp(COUNTDOWN_BAR_X_COORD, size.height == 568 ? COUNTDOWN_BAR_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : COUNTDOWN_BAR_Y_COORD);
        
        //add the pause button.
        CCMenuItem *pauseMenuItem = [CCMenuItemImage
                                        itemWithNormalImage:@"pause.png" selectedImage:@"pause.png"
                                        target:self selector:@selector(pauseButtonTapped:)];
        pauseMenuItem.position = ccp(PAUSE_X_COORD, size.height == 568 ? PAUSE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : PAUSE_Y_COORD);
        
        self.menuItems = [CCMenu menuWithItems:pauseMenuItem, nil];
        self.menuItems.position = CGPointZero;
        [self addChild:self.menuItems];
        
        //add the footer TODO add level and score.
        CCSprite *footer = [CCSprite spriteWithFile:@"footer.png"];
        footer.position = ccp(FOOTER_X_COORD, size.height == 568 ? FOOTER_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : FOOTER_Y_COORD);
        [self addChild:footer z:0];
        
        //create the player object and add it to layer.
        self.player = [[Player alloc] init];
        //TODO set position and add to layer.
        
        // create and initialize our light effects.
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
        
        //create the light manager and pass it the light array.
        self.lightManager = [[LightManager alloc] initWithLightArray:twoDimensionallightArray];
        
        //choose a high, medium, low and charge new value light from all the added lights.
        [self.lightManager chooseFirstLightWithValue:High];
        [self.lightManager chooseFirstLightWithValue:Medium];
        [self.lightManager chooseFirstLightWithValue:Low];
        [self.lightManager chooseFirstLightWithValue:Charge];
        
        //TODO remove second charge possibly.
        [self.lightManager chooseFirstLightWithValue:Charge];
        
        //create the level object and set its position.
        self.level = [[Level alloc] initWithGameLayer:self countdownBar:self.countdownBar lightManager:self.lightManager];
        self.level.position = ccp(LEVEL_X_COORD, size.height == 568 ? LEVEL_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : LEVEL_Y_COORD);
        
        //create the score object and set its position.
        self.score = [[Score alloc] initWithGameLayer:self level:self.level];
        self.score.position = ccp(SCORE_X_COORD, size.height == 568 ? SCORE_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : SCORE_Y_COORD);
        
        //create the route object.
        self.route = [[Route alloc] initWithGameLayer:self lightManager:self.lightManager];
        
        //add the player starting position to the route.
        [self.route setInitialLight:firstLight];
        
        //add the player and set it to the first light position.
        self.player = [[Player alloc] initWithGameLayer:self route:self.route currentLight:firstLight countdownBar:self.countdownBar score:self.score];
    
        self.isTouchEnabled = YES;
    
        [self schedule:@selector(update:)];
	}
	return self;
}

//update method calls similar methods on Light and player to manage transition of lights and movement of player.
- (void)update:(ccTime)dt {
    //only update if game is not paused.
    if (!self.gameIsPaused) {
        [self.lightManager update:dt];
        [self.player update:dt];
        [self.countdownBar update:dt];
    }
}

- (void)registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
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

- (void)gameOver
{
    self.gameIsPaused = YES;
    
    //submit score to game center.
    int score = self.score.scoreValue;
    
    GameKitHelper *helper = [GameKitHelper sharedGameKitHelper];
    [helper submitScore:score];
    
    //TODO pass score to layer for display?
    InGameMenuLayer *menuLayer = [[InGameMenuLayer alloc] initForGameOverMenuWithScore:score];
    [[[CCDirector sharedDirector] runningScene] addChild:menuLayer z:1];
}

- (void)unPauseGame
{
    self.gameIsPaused = NO;
}

- (void)restartGame
{
    //remove layer and then add it again.
    [self removeFromParentAndCleanup:YES];
    GameLayer *layer = [GameLayer node];
    [layer unPauseGame];
    [[[CCDirector sharedDirector] runningScene] addChild:layer z:0 tag:GAME_LAYER_TAG];
}

@end
