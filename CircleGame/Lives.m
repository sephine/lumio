//
//  Lives.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Lives.h"
#import "GameConfig.h"

@interface Lives ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic) int numberOfLives;
@property (nonatomic, strong) CCSprite *sprite;

@end

@implementation Lives

@synthesize position = _position;
@synthesize gameLayer = _gameLayer;
@synthesize numberOfLives = _numberOfLives;
@synthesize sprite = _sprite;

- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.sprite.position = position;
}

- (void)setNumberOfLives:(int)numberOfLives
{
    _numberOfLives = numberOfLives;
    switch (numberOfLives) {
        case 1:
            self.sprite = [CCSprite spriteWithFile:@"Lives1.png"];
            break;
        case 2:
            self.sprite = [CCSprite spriteWithFile:@"Lives2.png"];
            break;
        case 3:
            self.sprite = [CCSprite spriteWithFile:@"Lives3.png"];
            break;
        default:
            break;
    }
}

- (void)setSprite:(CCSprite *)sprite
{
    [_sprite removeFromParentAndCleanup:YES];
    _sprite = sprite;
    _sprite.position = self.position;
    _sprite.anchorPoint = ccp(0, 0);
    [self addChild:_sprite];
}

- (id)initWithGameLayer:(GameLayer *)gameLayer
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.numberOfLives = NUMBER_OF_LIVES;
        
        [self.gameLayer addChild:self];
    }
    return self;
}

- (void)removeLife
{
    self.numberOfLives--;
    
    if (self.numberOfLives == 0)
    {
        //TODO GameOver!
    }
}

@end
