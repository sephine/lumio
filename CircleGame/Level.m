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
//TODO change this to the better CCLabelBMFont using a tool like heiro??
@property (nonatomic, strong) CCLabelTTF *levelLabel;
@property (nonatomic, strong) CCLabelTTF *timeLabel;
@property (nonatomic) int level;
@property (nonatomic) ccTime time;

@end

@implementation Level

@synthesize position = _position;
@synthesize gameLayer = _gameLayer;
@synthesize countdownBar = _countdownBar;
@synthesize levelLabel = _levelLabel;
@synthesize timeLabel = _timeLabel;
@synthesize level = _level;
@synthesize time = _time;

- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.levelLabel.position = position;
    self.timeLabel.position = ccp(position.x + TIME_LABEL_OFFSET, position.y);
}

- (id)initWithGameLayer:(GameLayer *)gameLayer countdownBar:(CountdownBar *)countdownBar
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.countdownBar = countdownBar;
        [self.gameLayer addChild:self];
        
        self.level = 1;
        NSString *levelString = [NSString stringWithFormat:@"lvl %d", self.level];
        self.levelLabel = [CCLabelTTF labelWithString:levelString
                                           dimensions:CGSizeMake(LEVEL_WIDTH, LEVEL_HEIGHT)
                                            alignment:UITextAlignmentLeft
                                             fontName:@"Helvetica"
                                             fontSize:22];
        self.levelLabel.anchorPoint = ccp(0, 0);
        [self addChild:self.levelLabel];

        self.time = LEVEL_LENGTH_IN_SECONDS;
        NSString *timeString = [NSString stringWithFormat:@"%d", (int)ceil(self.time)];
        self.timeLabel = [CCLabelTTF labelWithString:timeString
                                           dimensions:CGSizeMake(TIME_WIDTH, TIME_HEIGHT)
                                            alignment:UITextAlignmentRight
                                             fontName:@"Helvetica"
                                             fontSize:22];
        self.timeLabel.anchorPoint = ccp(0, 0);
        [self addChild:self.timeLabel];
    }
    return self;
}

- (void)update:(ccTime)dt
{
    self.time -= dt;
    
    if (self.time <= 0) {
        [self increaseLevel];
        self.time = LEVEL_LENGTH_IN_SECONDS;
    }
    
    NSString *timeString = [NSString stringWithFormat:@"%d", (int)ceil(self.time)];
    [self.timeLabel setString:timeString];
}

- (void)increaseLevel
{
    self.level += 1;
    NSString *levelString = [NSString stringWithFormat:@"lvl %d", self.level];
    [self.levelLabel setString:levelString];
    
    //refillCountdownBar when they level up and increase countdownSpeed.
    [self.countdownBar refillBar];
    float speedIncrease;
    if (self.level <= 3) {
        speedIncrease = LEVEL_1_TO_3_COUNTDOWN_SPEED_INCREASE;
    } else if (self.level <= 5) {
        speedIncrease = LEVEL_4_TO_5_COUNTDOWN_SPEED_INCREASE;
    } else {
        speedIncrease = LEVEL_6_ONWARDS_COUNTDOWN_SPEED_INCREASE;
    }
    [self.countdownBar increaseCountdownSpeed:speedIncrease];
}

@end
