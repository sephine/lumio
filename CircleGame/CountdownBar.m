//
//  CountdownBar.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CountdownBar.h"
#import "GameConfig.h"

@interface CountdownBar ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic, strong) Lives *lives;
@property (nonatomic, strong) CCSprite *borderSprite;
@property (nonatomic, strong) CCSprite *centreSprite;
@property (nonatomic) float value;
@property (nonatomic) float countdownSpeed;

@end

@implementation CountdownBar

@synthesize position = _position;
@synthesize gameLayer = _gameLayer;
@synthesize lives = _lives;
@synthesize borderSprite = _borderSprite;
@synthesize centreSprite = _centreSprite;
@synthesize value = _value;
@synthesize countdownSpeed = _countdownSpeed;

- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.borderSprite.position = position;
    self.centreSprite.position = ccp(position.x + 4, position.y + 4);
}

- (void)setBorderSprite:(CCSprite *)borderSprite
{
    [_borderSprite removeFromParentAndCleanup:YES];
    _borderSprite = borderSprite;
    _borderSprite.position = self.position;
    _borderSprite.anchorPoint = ccp(0, 0);
    [self addChild:_borderSprite z:1];
}

- (void)setCentreSprite:(CCSprite *)centreSprite
{
    [_centreSprite removeFromParentAndCleanup:YES];
    _centreSprite = centreSprite;
    _centreSprite.position = self.position;
    _centreSprite.anchorPoint = ccp(0, 0);
    [self addChild:_centreSprite z:2];
}

- (id)initWithGameLayer:(GameLayer *)gameLayer lives:(Lives *)lives
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.lives = lives;
        self.value = 100;
        self.countdownSpeed = INITIAL_COUNTDOWN_SPEED_IN_PERCENTAGE_PER_SECOND;
        
        self.borderSprite = [CCSprite spriteWithFile:@"CountdownBorder.png"];
        self.centreSprite = [CCSprite spriteWithFile:@"CountdownCentre.png"];
        [self.gameLayer addChild:self];
    }
    return self;
}

- (void)update:(ccTime)dt
{
    self.countdownSpeed += COUNTDOWN_SPEED_RATE_OF_CHANGE * dt;
    
    float percentageDecrease = self.countdownSpeed * dt;
    self.value -= percentageDecrease;
    
    if (self.value <= 0) {
        [self.lives removeLife];
        self.value = 100;
    }
}

- (void)addValue:(LightValue)value
{
    if (value == High) {
        self.value += COUNTDOWN_HIGH_INCREASE_PERCENTAGE;
    }
    
    if (self.value > 100) self.value = 100;
}

- (void)draw
{
    float valueProportion = self.value / 100.0;
    self.centreSprite.scaleX = valueProportion;
    
    GLubyte red = 0;
    GLubyte green = 0;
    if (valueProportion >= CRITICAL_THRESHOLD) {
        red = 255 - 255 * (valueProportion - CRITICAL_THRESHOLD) / (1 - CRITICAL_THRESHOLD);
        green = 255 * (valueProportion - CRITICAL_THRESHOLD) / (1 - CRITICAL_THRESHOLD);
    } else {
        red = 255 * valueProportion / CRITICAL_THRESHOLD;
    }
    self.centreSprite.color = ccc3(red, green, 0);
    self.centreSprite.opacity = COUNTDOWN_BAR_OPACITY;
}

@end
