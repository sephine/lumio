//
//  InGameMenuLayer.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

@interface InGameMenuLayer : CCLayer {
}

- (id)initWithGameLayer:(GameLayer *)gameLayer resumeAvailable:(BOOL)resumeAvailable;

@end
