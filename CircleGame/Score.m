//
//  Score.m
//  CircleGame
//
//  Created by Joanne Dyer on 2/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Score.h"
#import "GameConfig.h"

@interface Score ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic, strong) Level *level;
@property (nonatomic, strong) CCLabelTTF *scoreLabel;
@property (nonatomic) int score;

@end

@implementation Score

@synthesize position = _position;
@synthesize gameLayer = _gameLayer;
@synthesize level = _level;
@synthesize scoreLabel = _scoreLabel;
@synthesize score = _score;

- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.scoreLabel.position = position;
}

- (id)initWithGameLayer:(GameLayer *)gameLayer level:(Level *)level
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.level = level;
        
        [self.gameLayer addChild:self];
        
        self.score = 0;
        NSString *scoreString = [NSString stringWithFormat:@"Score - %d", self.score];
        self.scoreLabel = [CCLabelTTF labelWithString:scoreString
                                           dimensions:CGSizeMake(SCORE_WIDTH, SCORE_HEIGHT)
                                            alignment:UITextAlignmentLeft
                                             fontName:@"Helvetica"
                                             fontSize:20];
        self.scoreLabel.anchorPoint = ccp(0, 0);
        [self addChild:self.scoreLabel];
    }
    return self;
}

- (void)increaseScoreByValue:(LightValue)value
{
    int originalLevel = self.score / SCORE_TO_LEVEL_UP;
    
    if (value == High) {
        self.score += SCORE_FOR_HIGH_VALUE;
    } else if (value == Medium) {
        self.score += SCORE_FOR_MEDIUM_VALUE;
    } else if (value == Low) {
        self.score += SCORE_FOR_LOW_VALUE;
    }
    
    NSString *scoreString = [NSString stringWithFormat:@"Score - %d", self.score];
    [self.scoreLabel setString:scoreString];
    
    int newLevel = self.score / SCORE_TO_LEVEL_UP;
    if (newLevel > originalLevel) {
        [self.level increaseLevel];
    }
}

@end
