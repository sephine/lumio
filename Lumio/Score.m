//
//  Score.m
//  Lumio
//
//  Created by Joanne Dyer on 2/19/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "Score.h"
#import "GameConfig.h"

//class counts up the score and displays it on it's label. Also handles the stars remaining to level up.
@interface Score ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic, strong) Level *level;
@property (nonatomic, strong) CCLabelTTF *scoreLabel;
@property (nonatomic) int starsToLevelUp;
@property (nonatomic, strong) CCLabelTTF *starsToLevelUpLabel;

@end

@implementation Score

@synthesize position = _position;

//when the score's position is set also need to set the position of it's label. The positioning of the remaining stars to level up sprite and label are handled seperately.
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
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //set up the score label and show the intial level of 0.
        self.scoreValue = 0;
        NSString *scoreString = [NSString stringWithFormat:@"Score - %d", self.scoreValue];
        self.scoreLabel = [CCLabelTTF labelWithString:scoreString
                                           dimensions:CGSizeMake(SCORE_WIDTH, SCORE_HEIGHT)
                                            alignment:UITextAlignmentLeft
                                             fontName:FONT_NAME
                                             fontSize:FONT_SIZE];
        self.scoreLabel.color = STANDARD_PURPLE;
        [self addChild:self.scoreLabel];
        
        CCSprite *starSprite = [CCSprite spriteWithFile:@"1star.png"];
        starSprite.position = ccp(STAR_SPRITE_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_STAR_SPRITE_Y_COORD : STAR_SPRITE_Y_COORD);
        [self addChild:starSprite];
        
        NSString *starsToLevelUpString = [NSString stringWithFormat:@"%d", self.starsToLevelUp];
        self.starsToLevelUpLabel = [CCLabelTTF labelWithString:starsToLevelUpString
                                           dimensions:CGSizeMake(STARS_REMAINING_WIDTH, STARS_REMAINING_HEIGHT)
                                            alignment:UITextAlignmentLeft
                                             fontName:FONT_NAME
                                             fontSize:FONT_SIZE];
        self.starsToLevelUpLabel.color = STANDARD_BLUE;
        self.starsToLevelUpLabel.position =ccp(STARS_REMAINING_X_COORD, size.height == 568 ? EXPLICIT_FOUR_INCH_SCREEN_STAR_REMAINING_Y_COORD : STARS_REMAINING_Y_COORD);
        [self addChild:self.starsToLevelUpLabel];
    }
    return self;
}

//called by the player when it gets a value. Increase the score by the appropriate amount and decrease the stars to level up appropriately.
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
    
    //update the score label with the new core.
    NSString *scoreString = [NSString stringWithFormat:@"Score - %d", self.scoreValue];
    [self.scoreLabel setString:scoreString];
    
    //if stars to level up is 0 or less than 0, reset it and tell level to increase.
    if (self.starsToLevelUp <= 0) {
        self.starsToLevelUp = STARS_TO_LEVEL_UP;
        [self.level increaseLevel];
    }
    
    //update the stars to level up label with the new value.
    NSString *starsToLevelUpString = [NSString stringWithFormat:@"%d", self.starsToLevelUp];
    [self.starsToLevelUpLabel setString:starsToLevelUpString];
}

@end
