//
//  Credits Layer.h
//  Lumio
//
//  Created by Joanne Dyer on 2/27/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseMenuLayer.h"
#import "CCLayerWithTransparency.h"

@interface CreditsLayer : CCLayerWithTransparency {
}

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue;

@end
