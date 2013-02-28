//
//  MainMenuLayer.h
//  Lumio
//
//  Created by Joanne Dyer on 2/21/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLayerWithTransparency.h"

//first menu layer that is shown on entering.
@interface MainMenuLayer : CCLayerWithTransparency {
}

//base layer is provided so that the data there can be accessed and passed on to new layers. Show continue says whether the continue menu item should be shown.
- (id)initWithBaseLayer:(CCLayer *)baseLayer showContinue:(BOOL)showContinue;

@end
