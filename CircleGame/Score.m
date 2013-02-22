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
@property (nonatomic) int starsToLevelUp;
@property (nonatomic, strong) CCLabelTTF *starsToLevelUpLabel;

@end

@implementation Score

@synthesize position = _position;
@synthesize gameLayer = _gameLayer;
@synthesize level = _level;
@synthesize scoreLabel = _scoreLabel;
@synthesize scoreValue = _scoreValue;
@synthesize starsToLevelUp = _starsToLevelUp;
@synthesize starsToLevelUpLabel = _starsToLevelUpLabel;

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
        self.starsToLevelUp = STARS_TO_LEVEL_UP;
        
        [self.gameLayer addChild:self];
        
        self.scoreValue = 0;
        NSString *scoreString = [NSString stringWithFormat:@"Score - %d", self.scoreValue];
        self.scoreLabel = [CCLabelTTF labelWithString:scoreString
                                           dimensions:CGSizeMake(SCORE_WIDTH, SCORE_HEIGHT)
                                            alignment:UITextAlignmentLeft
                                             fontName:@"Helvetica"
                                             fontSize:19];
        self.scoreLabel.color = ccc3(160, 48, 252);
        self.scoreLabel.anchorPoint = ccp(0, 0);
        [self addChild:self.scoreLabel];
        
        //add the star sprite
        CCSprite *starSprite = [CCSprite spriteWithFile:@"1star.png"];
        starSprite.position = ccp(STAR_SPRITE_X_COORD, STAR_SPRITE_Y_COORD);
        starSprite.anchorPoint = ccp(0.5, 0.5);
        [self addChild:starSprite];
        
        //add the stars remaining label.
        NSString *starsToLevelUpString = [NSString stringWithFormat:@"%d", self.starsToLevelUp];
        self.starsToLevelUpLabel = [CCLabelTTF labelWithString:starsToLevelUpString
                                           dimensions:CGSizeMake(STARS_REMAINING_WIDTH, STARS_REMAINING_HEIGHT)
                                            alignment:UITextAlignmentLeft
                                             fontName:@"Helvetica"
                                             fontSize:19];
        self.starsToLevelUpLabel.color = ccc3(3, 171, 255);
        self.starsToLevelUpLabel.anchorPoint = ccp(0, 0);
        self.starsToLevelUpLabel.position =ccp(STARS_REMAINING_X_COORD, STARS_REMAINING_Y_COORD);
        [self addChild:self.starsToLevelUpLabel];
    }
    return self;
}

- (void)increaseScoreByValue:(LightValue)lighValue
{
    if (lighValue == High) {
        self.scoreValue += SCORE_FOR_HIGH_VALUE;
        self.starsToLevelUp -= 3;
    } else if (lighValue == Medium) {
        self.scoreValue += SCORE_FOR_MEDIUM_VALUE;
        self.starsToLevelUp -= 2;
    } else if (lighValue == Low) {
        self.scoreValue += SCORE_FOR_LOW_VALUE;
        self.starsToLevelUp -= 1;
    }
    
    if (self.scoreValue > MAX_SCORE) self.scoreValue = MAX_SCORE;
    
    NSString *scoreString = [NSString stringWithFormat:@"Score - %d", self.scoreValue];
    [self.scoreLabel setString:scoreString];
    
    if (self.starsToLevelUp <= 0) {
        self.starsToLevelUp = STARS_TO_LEVEL_UP;
        [self.level increaseLevel];
    }
    
    NSString *starsToLevelUpString = [NSString stringWithFormat:@"%d", self.starsToLevelUp];
    [self.starsToLevelUpLabel setString:starsToLevelUpString];
}

@end
