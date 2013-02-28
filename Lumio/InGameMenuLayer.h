//
//  InGameMenuLayer.h
//  Lumio
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//layer covers the game layer when the game is paused or on game over.
@interface InGameMenuLayer : CCLayer {
}

- (id)initForPauseMenu;
- (id)initForGameOverMenuWithScore:(int)score;

@end
