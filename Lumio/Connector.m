//
//  Connector.m
//  Lumio
//
//  Created by Joanne Dyer on 1/20/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "Connector.h"
#import "GameConfig.h"

//class contains all the functionality for the coloured bars that connect the lights.
@interface Connector ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic) ConnectorOrientation orientation;
@property (nonatomic, strong) CCSprite *sprite;

@end

@implementation Connector

@synthesize position = _position;

//when the connector position is set also need to set the position of it's sprite.
- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.sprite.position = position;
}

//show or hide the connectors based on the state.
- (void)setState:(ConnectorState)state
{
    _state = state;
    switch (_state) {
        case Routed:
            self.sprite = [CCSprite spriteWithFile:@"connectorrouted.png"];
            self.sprite.opacity = OPAQUE;
            break;
        case Enabled:
        case Disabled:
            self.sprite.opacity = TRANSPARENT;
            break;
        default:
            break;
    }
}

//when you change the file for a sprite you need to remove the sprite and add it again.
- (void)setSprite:(CCSprite *)sprite
{
    [_sprite removeFromParentAndCleanup:YES];
    _sprite = sprite;
    _sprite.position = self.position;
    if (self.orientation == Vertical) {
        _sprite.rotation = 90;
    }
    [self addChild:_sprite];
}

- (id)initWithGameLayer:(GameLayer *)gameLayer orientation:(ConnectorOrientation)orientation
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.orientation = orientation;
        
        //set the state to Enabled, this will set the sprite to the correct image and add it to the layer.
        self.state = Enabled;
        [self.gameLayer addChild:self];
    }
    return self;
}

@end
