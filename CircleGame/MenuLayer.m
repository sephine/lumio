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

@interface MenuLayer ()

@property (nonatomic, strong) MenuCircleGenerator *circles;

@end

@implementation MenuLayer

@synthesize circles = _circles;

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
        
        CCMenu *menu = [CCMenu menuWithItems:newGameMenuItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
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

- (void)newGameButtonTapped:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[GameLayer scene] withColor:ccBLACK]];
}

@end
