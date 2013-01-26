//
//  GameLayer.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface GameLayer : CCLayer
{
}
//<GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

- (void)gameOver;
- (void)unPauseGame;
- (void)restartGame;

@end
