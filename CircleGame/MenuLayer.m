//
//  MenuLayer.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "GameLayer.h"
#import "MenuCircleGenerator.h"
#import "GameConfig.h"

@interface MenuLayer ()

@property (nonatomic, strong) MenuCircleGenerator *circles;
@property (nonatomic, strong) CCMenu *menu;
@property (nonatomic, strong) CCScene *gameScene;

@end

@implementation MenuLayer

@synthesize circles = _circles;
@synthesize menu = _menu;

// Helper class method that creates a Scene with the MenuLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
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
	MenuLayer *layer = [[MenuLayer alloc] initWithPreviousScene:previousScene];
	
	// add layer as a child to scene
	[scene addChild: layer z:0];
	
	// return the scene
	return scene;
}

- (id)init
{
	if( (self=[super init]) ) {
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
        
        //create the background circles.
        self.circles = [[MenuCircleGenerator alloc] initWithMenuLayer:self];
        
        //Create the New Game Menu Item.
        CCMenuItemImage *newGameMenuItem = [CCMenuItemImage
                                           itemWithNormalImage:@"NewGameButton.png" selectedImage:@"NewGameButtonSelected.png"
                                           target:self selector:@selector(newGameButtonTapped:)];
        newGameMenuItem.anchorPoint = ccp(0.5, 0.5);
        newGameMenuItem.position = ccp(160, 240);
        
        self.menu = [CCMenu menuWithItems:newGameMenuItem, nil];
        self.menu.position = CGPointZero;
        [self addChild:self.menu];
        
        self.isTouchEnabled = YES;
        
        [self schedule:@selector(update:)];
    }
    return self;
}

- (id)initWithPreviousScene:(CCScene *)previousScene
{
    if (self = [self init]) {
        //currently the previous scene will always be the game scene.
        self.gameScene = previousScene;
        
        //Create the Continue Menu Item. TODO change image.
        CCMenuItemImage *continueMenuItem = [CCMenuItemImage
                                             itemWithNormalImage:@"NewGameButton.png" selectedImage:@"NewGameButtonSelected.png"
                                             target:self selector:@selector(continueButtonTapped:)];
        continueMenuItem.anchorPoint = ccp(0.5, 0.5);
        continueMenuItem.position = ccp(160, 150);
        
        [self.menu addChild:continueMenuItem];
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

- (void)newGameButtonTapped:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[GameLayer scene] withColor:ccBLACK]];
}

- (void)continueButtonTapped:(id)sender
{
    //go back to previous game scene and unpause the game layer.
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:self.gameScene withColor:ccBLACK]];
    GameLayer *gameLayer = (GameLayer *)[self.gameScene getChildByTag:GAME_LAYER_TAG];
    
    //[self scheduleOnce:@selector(unPauseGameLayer:) delay:0.7];
    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(unPauseGame) forTarget:gameLayer interval:0 paused:YES repeat:0 delay:0.7];
    //TODO game is unpaused before the transition is finished and you can see it.
}

@end
