//
//  Level.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Level.h"
#import "GameConfig.h"

@interface Level ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic, strong) CountdownBar *countdownBar;
@property (nonatomic, strong) LightManager *lightManager;
//TODO change this to the better CCLabelBMFont using a tool like heiro??
@property (nonatomic, strong) CCLabelTTF *levelLabel;
@property (nonatomic) int level;

@end

@implementation Level

@synthesize position = _position;
@synthesize gameLayer = _gameLayer;
@synthesize countdownBar = _countdownBar;
@synthesize lightManager = _lightManager;
@synthesize levelLabel = _levelLabel;
@synthesize level = _level;

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
        
        //set up the light manager with the intial max cooldown.
        self.lightManager = lightManager;
        self.lightManager.maxCooldown = INITIAL_MAX_COOLDOWN;
        
        self.level = 1;
        NSString *levelString = [NSString stringWithFormat:@"Level - %d", self.level];
        self.levelLabel = [CCLabelTTF labelWithString:levelString
                                           dimensions:CGSizeMake(LEVEL_WIDTH, LEVEL_HEIGHT)
                                            alignment:UITextAlignmentLeft
                                             fontName:@"Helvetica"
                                             fontSize:20];
        self.levelLabel.anchorPoint = ccp(0, 0);
        [self addChild:self.levelLabel];
    }
    return self;
}

- (void)increaseLevel
{
    self.level += 1;
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
    self.lightManager.maxCooldown = INITIAL_MAX_COOLDOWN + MAX_COOLDOWN_INCREASE * self.level;
}

@end
