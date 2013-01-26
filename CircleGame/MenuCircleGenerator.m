//
//  MenuCircleGenerator.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuCircleGenerator.h"
#import "GameConfig.h"

@interface MenuCircleGenerator ()

@property (nonatomic, strong) MenuLayer *menuLayer;
@property (nonatomic, strong) NSMutableArray *spriteArray;
@property (nonatomic, strong) NSMutableArray *timeArray;

@end

@implementation MenuCircleGenerator

@synthesize menuLayer = _menuLayer;
@synthesize spriteArray = _spriteArray;
@synthesize timeArray = _timeArray;

- (id)initWithMenuLayer:(MenuLayer *)menuLayer
{
    if (self = [super init]) {
        self.menuLayer = menuLayer;
        [self.menuLayer addChild:self];
        self.spriteArray = [NSMutableArray array];
        self.timeArray = [NSMutableArray array];
        
        CCSprite *sprite1 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite1.position = ccp(204, 456);
        sprite1.anchorPoint = ccp(0.5, 0.5);
        [self addChild:sprite1];
        [self.spriteArray addObject:sprite1];
        float sprite1Timer = 24;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite1Timer]];
        
        CCSprite *sprite2 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite2.position = ccp(39, 390);
        sprite2.anchorPoint = ccp(0.5, 0.5);
        [self addChild:sprite2];
        [self.spriteArray addObject:sprite2];
        float sprite2Timer = 12;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite2Timer]];
        
        CCSprite *sprite3 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite3.position = ccp(160, 320);
        sprite3.anchorPoint = ccp(0.5, 0.5);
        [self addChild:sprite3];
        [self.spriteArray addObject:sprite3];
        float sprite3Timer = 8;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite3Timer]];
        
        CCSprite *sprite4 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite4.position = ccp(74, 204);
        sprite4.anchorPoint = ccp(0.5, 0.5);
        [self addChild:sprite4];
        [self.spriteArray addObject:sprite4];
        float sprite4Timer = 20;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite4Timer]];
        
        CCSprite *sprite5 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite5.position = ccp(244, 168);
        sprite5.anchorPoint = ccp(0.5, 0.5);
        [self addChild:sprite5];
        [self.spriteArray addObject:sprite5];
        float sprite5Timer = 16;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite5Timer]];
        
        CCSprite *sprite6 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite6.position = ccp(115, 65);
        sprite6.anchorPoint = ccp(0.5, 0.5);
        [self addChild:sprite6];
        [self.spriteArray addObject:sprite6];
        float sprite6Timer = 4;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite6Timer]];
    }
    return self;
}

//updates the time remaining on the timers.
- (void)update:(ccTime)dt
{
    for (int i = 0; i < 6; i++) {
        float currentSpriteTimer = [[self.timeArray objectAtIndex:i] floatValue];
        currentSpriteTimer -= dt;
        if (currentSpriteTimer <= 0) currentSpriteTimer = 24;
        [self.timeArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:currentSpriteTimer]];
    }
}

- (void)draw
{
    for (int i = 0; i < 6; i++) {
        CCSprite *sprite = [self.spriteArray objectAtIndex:i];
        float time = [[self.timeArray objectAtIndex:i] floatValue];
        float timeProportion = time / 24;
        sprite.scale = timeProportion;
        GLubyte red = 0;
        GLubyte green = 0;
        if (timeProportion >= CRITICAL_THRESHOLD) {
            red = 255 - 255 * (timeProportion - CRITICAL_THRESHOLD) / (1 - CRITICAL_THRESHOLD);
            green = 255 * (timeProportion - CRITICAL_THRESHOLD) / (1 - CRITICAL_THRESHOLD);
        } else {
            red = 255 * timeProportion / CRITICAL_THRESHOLD;
        }
        sprite.color = ccc3(red, green, 0);
        
        if (time >= 23) {
            sprite.opacity = 60 * (24 - time);
        } else {
            sprite.opacity = 60;
        }
    }
}

@end
