//
//  InGameMenuLayer.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InGameMenuLayer : CCLayer {
}

- (id)initForPauseMenu;
- (id)initForGameOverMenuWithScore:(int)score;

@end
