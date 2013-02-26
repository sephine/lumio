//
//  MenuLayer.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BaseMenuLayer : CCLayerColor {
}

@property (nonatomic, strong) CCScene *gameScene;
@property (nonatomic) BOOL soundEffectsOn;
@property (nonatomic) BOOL musicOn;
@property (nonatomic) BOOL firstPlay;

// returns a CCScene that contains the MenuLayer as the only child
+(CCScene *) scene;
+ (CCScene *)sceneWithPreviousScene:(CCScene *)previousScene;

@end
