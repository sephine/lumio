//
//  Level.m
//  Lumio
//
//  Created by Joanne Dyer on 1/25/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "Level.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"

//class controls the levelling up process and the labels showing current level.
@interface Level ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic, strong) CountdownBar *countdownBar;
@property (nonatomic, strong) LightManager *lightManager;
@property (nonatomic, strong) CCLabelTTF *levelLabel;
@property (nonatomic) int level;

@end

@implementation Level

@synthesize position = _position;

//when the level's position is set also need to set the position of it's label.
- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.levelLabel.position = position;
}

- (id)initWithGameLayer:(GameLayer *)gameLayer countdownBar:(CountdownBar *)countdownBar lightManager:(LightManager *)lightManager
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.countdownBar = countdownBar;
        [self.gameLayer addChild:self];
        
        //set up the light manager with the intial max cooldown and an initial no countdown reduction.
        self.lightManager = lightManager;
        self.lightManager.maxCooldown = INITIAL_MAX_COOLDOWN;
        self.lightManager.countdownReduction = INITIAL_COUNTDOWN_REDUCTION;
        
        self.level = 1;
        NSString *levelString = [NSString stringWithFormat:@"Level - %d", self.level];
        self.levelLabel = [CCLabelTTF labelWithString:levelString
                                           dimensions:CGSizeMake(LEVEL_WIDTH, LEVEL_HEIGHT)
                                            alignment:UITextAlignmentLeft
                                             fontName:FONT_NAME
                                             fontSize:FONT_SIZE];
        self.levelLabel.color = STANDARD_BLUE;
        [self addChild:self.levelLabel];
    }
    return self;
}

//increase level, called when enough stars have been collected to level up.
- (void)increaseLevel
{
    self.level += 1;
    if (self.level > MAX_LEVEL) self.level = MAX_LEVEL;
    
    NSString *levelString = [NSString stringWithFormat:@"Level - %d", self.level];
    [self.levelLabel setString:levelString];
    
    //refillCountdownBar when they level up and increase countdownSpeed.
    [self.countdownBar refillBar];
    float speedIncrease;
    if (self.level <= 5) {
        speedIncrease = LEVEL_1_TO_5_COUNTDOWN_SPEED_INCREASE;
    } else if (self.level <= 10) {
        speedIncrease = LEVEL_6_TO_10_COUNTDOWN_SPEED_INCREASE;
    } else if (self.level <= 20) {
        speedIncrease = LEVEL_11_TO_20_COUNTDOWN_SPEED_INCREASE;
    } else {
        speedIncrease = LEVEL_21_ONWARDS_COUNTDOWN_SPEED_INCREASE;
    }
    [self.countdownBar increaseCountdownSpeed:speedIncrease];
    
    //update the lightmanager cooldown based on the new level.
    self.lightManager.maxCooldown = INITIAL_MAX_COOLDOWN + MAX_COOLDOWN_INCREASE * (self.level - 1);
    float countdownReduction = (self.level - 1) * COUNTDOWN_REDUCTION_PER_LEVEL;
    if (countdownReduction > MAX_COUNTDOWN_REDUCTION) countdownReduction = MAX_COUNTDOWN_REDUCTION;
    self.lightManager.countdownReduction = countdownReduction;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"levelUpSoundEffect.wav"];
}

@end
