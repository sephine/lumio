//
//  Lives.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

@interface Lives : CCNode {
}

@property (nonatomic) CGPoint position;

- (id)initWithGameLayer:(GameLayer *)gameLayer;

- (void)removeLife;

@end
