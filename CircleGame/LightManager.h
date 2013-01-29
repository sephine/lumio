//
//  LightManager.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Light.h"

@interface LightManager : CCNode {
}

- (id)initWithLightArray:(NSMutableArray *)lightArray;
- (void)update:(ccTime)dt;

- (void)chooseNewValueLight;
- (Light *)findSelectedLightFromLocation:(CGPoint)location;

@end
