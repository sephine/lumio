//
//  CountdownBar.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CountdownBar.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"

@interface CountdownBar ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic, strong) CCSprite *borderSprite;
@property (nonatomic, strong) CCSprite *centreSprite;
@property (nonatomic, strong) CCSprite *maskSprite;
@property (nonatomic) float value;
@property (nonatomic) float countdownSpeed;
@property (nonatomic) ccTime glowTimeRemaining;

@end

@implementation CountdownBar

@synthesize position = _position;
@synthesize gameLayer = _gameLayer;
@synthesize borderSprite = _borderSprite;
@synthesize centreSprite = _centreSprite;
@synthesize maskSprite = _maskSprite;
@synthesize value = _value;
@synthesize countdownSpeed = _countdownSpeed;
@synthesize glowTimeRemaining = _glowTimeRemaining;

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
        self.glowTimeRemaining = 0;
        
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
    float initialValue = self.value;
    
    //decrease the value based on the time passed and the speed of decrease.
    float percentageDecrease = self.countdownSpeed * dt;
    self.value -= percentageDecrease;
    
    self.glowTimeRemaining -= dt;
    if (self.glowTimeRemaining < 0) self.glowTimeRemaining = 0;
    
    if (self.value <= 0) {
        [self.gameLayer gameOver];
    } else {
        [self setTheCentreSpriteScaleAndColour];
    }
    
    //play warning sound once in warning zone.
    if (self.value <= COUNTDOWN_WARNING_START_PERCENTAGE && initialValue > COUNTDOWN_WARNING_START_PERCENTAGE) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"warningSoundEffect.wav"];
    }
    
    //if (newTimeRemaining <= COUNTDOWN_WARNING_START_TIME) {
    //    float initialSoundTimeRemaining = fmodf(initialTimeRemaining, COUNTDOWN_WARNING_START_TIME /4);
    //    float newSoundTimeRemaining = fmodf(newTimeRemaining, COUNTDOWN_WARNING_START_TIME /4);
    //    if (newSoundTimeRemaining > initialSoundTimeRemaining) {
    //        [[SimpleAudioEngine sharedEngine] playEffect:@"drumSoundEffect.mp3"];
    //    }
    //}
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
    self.glowTimeRemaining = COUNTDOWN_BAR_GLOW_TIME;
}

- (void)setTheCentreSpriteScaleAndColour
{
    //modify the scale of the mask based on the value.
    float valueProportion = self.value / 100.0;
    self.maskSprite.scaleX = 1 - valueProportion;
    
    //change the colour to black if time left until bar empties is less than the warning time.
    GLubyte red, green, blue;
    //float timeRemaining = self.value / self.countdownSpeed;
    if (self.value <= COUNTDOWN_WARNING_START_PERCENTAGE) {
        //float flashTimeProportion = fmodf(timeRemaining, COUNTDOWN_BAR_WARNING_FLASH_TIME) / COUNTDOWN_BAR_WARNING_FLASH_TIME;
        /*if (flashTimeProportion <= 0.5) {
            red = 3 + 252 * flashTimeProportion * 2;
            green = 171 - 171 * flashTimeProportion * 2;
            blue = 255 - 255 * flashTimeProportion * 2;
        } else {
            red = 255 - 252 * (flashTimeProportion - 0.5) * 2;
            green = 0 + 171 * (flashTimeProportion - 0.5) * 2;
            blue = 0 + 255 * (flashTimeProportion - 0.5) * 2;
        }*/
        red = 0;
        green = 0;
        blue = 255;
    } else {
        //change the colour to white based on glow time remaining.
        blue = 255;
        float glowTimeProportion = self.glowTimeRemaining/ COUNTDOWN_BAR_GLOW_TIME;
        if (glowTimeProportion <= 0.4) {
            red = 3 + 97 * glowTimeProportion * 2.5;
            green = 171 + 59 * glowTimeProportion * 2.5;
        } else if (glowTimeProportion >= 0.6) {
            red = 100 - 97 * (glowTimeProportion - 0.6) * 2.5;
            green = 230 - 59 * (glowTimeProportion - 0.6) * 2.5;
        } else {
            red = 100;
            green = 230;
        }
    }
    self.centreSprite.color = ccc3(red, green, blue);
}

@end
