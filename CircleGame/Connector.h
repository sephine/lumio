//
//  Connector.h
//  CircleGame
//
//  Created by Joanne Dyer on 1/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

typedef enum {
    Horizontal,
    Vertical
} Orientation;

typedef enum {
    Routed,
    Enabled,
    Disabled
} ConnectorState;

@interface Connector : CCNode {
}

@property (nonatomic) CGPoint position;
@property (nonatomic) ConnectorState state;

- (id)initWithGameLayer:(GameLayer *)gameLayer orientation:(Orientation)orientation;

@end
