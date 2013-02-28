//
//  MenuLayer.h
//  Lumio
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//layer that acts as a base to all the menu layers. Creates a containing scene.
@interface BaseMenuLayer : CCLayerColor {
}

//gameScene will contain a link to the main game scene if the main menu has been reopened after a game has been started.
@property (nonatomic, strong) CCScene *gameScene;

//these proporties access NSUserDefaults.
@property (nonatomic) BOOL soundEffectsOn;
@property (nonatomic) BOOL musicOn;
@property (nonatomic) BOOL firstPlay;

// returns a CCScene that contains the MenuLayer as the only child
+(CCScene *) scene;
+ (CCScene *)sceneWithPreviousScene:(CCScene *)previousScene;

@end
