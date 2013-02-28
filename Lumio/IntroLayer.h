//
//  IntroLayer.h
//  Lumio
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright Joanne Dyer 2013. All rights reserved.
//

#import "cocos2d.h"

//The IntroLayer exists to give a delay before the menu screens appear so everything is loaded before you see the menu.
@interface IntroLayer : CCLayer {
}

// returns a CCScene that contains the IntroLayer as the only child
+(CCScene *) scene;

@end
