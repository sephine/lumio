//
//  GameLayer.h
//  Lumio
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright Joanne Dyer 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"

//Game Layer controls all the game objects and handles pausing and game over.
@interface GameLayer : CCLayerColor {
}

@property (nonatomic) BOOL gameIsPaused;

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

- (void)gameOver;
- (void)unPauseGame;
- (void)restartGame;

@end
