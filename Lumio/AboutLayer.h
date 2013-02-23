//
//  AboutLayer.h
//  CircleGame
//
//  Created by Joanne Dyer on 2/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseMenuLayer.h"
#import "CCLayerWithTransparency.h"

@interface AboutLayer : CCLayerWithTransparency {
}

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue;

@end
