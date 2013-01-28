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
@property (nonatomic) Orientation orientation;
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
            self.sprite.color = ccc3(255, 255, 0);
            self.sprite.opacity = OPAQUE;
            break;
        case Enabled:
            self.sprite.color = ccc3(0, 0, 0);
            self.sprite.opacity = OPAQUE;
            break;
        case Disabled:
            self.sprite.opacity = TRANSPARENT;
            break;
        default:
            break;
    }
}

- (id)initWithGameLayer:(GameLayer *)gameLayer orientation:(Orientation)orientation
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.orientation = orientation;
        
        //Create sprite and add to layer.
        [self.gameLayer addChild:self];
        if (self.orientation == Vertical) {
            self.sprite = [CCSprite spriteWithFile:@"VConnector.png"];
        } else {
            self.sprite = [CCSprite spriteWithFile:@"HConnector.png"];
        }
        self.sprite.anchorPoint = ccp(0.5, 0.5);
        
        //set the state to Enabled, this will set the sprite to the correct opacity and colour.
        self.state = Enabled;
        [self addChild:self.sprite z:100];
    }
    return self;
}

@end
