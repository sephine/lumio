//
//  Connector.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Connector.h"
#import "GameConfig.h"

@interface Connector ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic) ConnectorOrientation orientation;
@property (nonatomic, strong) CCSprite *sprite;

@end

@implementation Connector

@synthesize position = _position;
@synthesize state = _state;
@synthesize gameLayer = _gameLayer;
@synthesize orientation = _orientation;
@synthesize sprite = _sprite;

- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.sprite.position = position;
}

- (void)setState:(ConnectorState)state
{
    _state = state;
    switch (_state) {
        case Routed:
            self.sprite = [CCSprite spriteWithFile:@"connectorrouted.png"];
            self.sprite.opacity = OPAQUE;
            break;
        case Enabled:
            //self.sprite = [CCSprite spriteWithFile:@"Connector.png"];
            //self.sprite.opacity = TRANSPARENT;
            //break;
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
