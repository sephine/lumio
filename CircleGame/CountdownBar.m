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
@property (nonatomic, strong) CCSprite *borderSprite;
@property (nonatomic, strong) CCSprite *centreSprite;
@property (nonatomic, strong) CCSprite *maskSprite;
@property (nonatomic) float value;
@property (nonatomic) float countdownSpeed;

@end

@implementation CountdownBar

@synthesize position = _position;
@synthesize gameLayer = _gameLayer;
@synthesize borderSprite = _borderSprite;
@synthesize centreSprite = _centreSprite;
@synthesize maskSprite = _maskSprite;
@synthesize value = _value;
@synthesize countdownSpeed = _countdownSpeed;

- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.borderSprite.position = position;
    self.centreSprite.position = ccp(position.x + 4, position.y + 7);
    self.maskSprite.position = ccp(position.x + 4 + 235, position.y + 6);
}

- (id)initWithGameLayer:(GameLayer *)gameLayer
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.value = 100;
        self.countdownSpeed = INITIAL_COUNTDOWN_SPEED_IN_PERCENTAGE_PER_SECOND;
        
        self.centreSprite = [CCSprite spriteWithFile:@"energy.png"];
        self.centreSprite.position = self.position;
        self.centreSprite.anchorPoint = ccp(0, 0);
        [self addChild:self.centreSprite z:1];
        
        self.maskSprite = [CCSprite spriteWithFile:@"energymask.png"];
        self.maskSprite.position = self.position;
        self.maskSprite.anchorPoint = ccp(1, 0);
        [self addChild:self.maskSprite z:2];
        
        self.borderSprite = [CCSprite spriteWithFile:@"energybar.png"];
        self.borderSprite.position = self.position;
        self.borderSprite.anchorPoint = ccp(0, 0);
        [self addChild:self.borderSprite z:3];
        
        [self.gameLayer addChild:self];
        
        [self setTheCentreSpriteScaleAndColour];
    }
    return self;
}

- (void)update:(ccTime)dt
{
    //decrease the value based on the time passed and the speed of decrease.
    float percentageDecrease = self.countdownSpeed * dt;
    self.value -= percentageDecrease;
    
    if (self.value <= 0) {
        [self.gameLayer gameOver];
    } else {
        [self setTheCentreSpriteScaleAndColour];
    }
}

- (void)addValue:(LightValue)value
{
    if (value == High) {
        self.value += COUNTDOWN_HIGH_INCREASE_PERCENTAGE;
    } else if (value == Medium) {
        self.value += COUNTDOWN_MEDIUM_INCREASE_PERCENTAGE;
    } else if (value == Low) {
        self.value += COUNTDOWN_LOW_INCREASE_PERCENTAGE;
    }
    
    if (self.value > 100) self.value = 100;
}

- (void)increaseCountdownSpeed:(float)speedIncrease
{
    self.countdownSpeed += speedIncrease;
}

- (void)refillBar
{
    self.value = 100;
}

- (void)setTheCentreSpriteScaleAndColour
{
    //modify the scale of the mask based on the value.
    float valueProportion = self.value / 100.0;
    self.maskSprite.scaleX = 1 - valueProportion;
    
    //self.centreSprite.scaleX = valueProportion;
    
    /*GLubyte red = 0;
    GLubyte green = 0;
    if (valueProportion >= CRITICAL_THRESHOLD) {
        red = 255 - 255 * (valueProportion - CRITICAL_THRESHOLD) / (1 - CRITICAL_THRESHOLD);
        green = 255 * (valueProportion - CRITICAL_THRESHOLD) / (1 - CRITICAL_THRESHOLD);
    } else {
        red = 255 * valueProportion / CRITICAL_THRESHOLD;
    }
    self.centreSprite.color = ccc3(red, green, 0);*/
}

@end
