//
//  MenuCircleGenerator.m
//  Lumio
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "MenuCircleGenerator.h"
#import "GameConfig.h"

//class handles the creation and animation of the background circles for the menu screens.
@interface MenuCircleGenerator ()

@property (nonatomic, strong) BaseMenuLayer *menuLayer;
@property (nonatomic, strong) NSMutableArray *spriteArray;
@property (nonatomic, strong) NSMutableArray *timeArray;

@end

@implementation MenuCircleGenerator

//creates 6 circles positioned in various places in the screen and at different states based on the time remaining set. Adds all the circles to the base menu layer and to the sprite array. Adds all the time remainings to the time array.
- (id)initWithMenuLayer:(BaseMenuLayer *)menuLayer
{
    if (self = [super init]) {
        self.menuLayer = menuLayer;
        [self.menuLayer addChild:self];
        self.spriteArray = [NSMutableArray array];
        self.timeArray = [NSMutableArray array];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *sprite1 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite1.position = ccp(CIRCLE_1_X_COORD, size.height == 568 ? CIRCLE_1_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : CIRCLE_1_Y_COORD);
        [self addChild:sprite1];
        [self.spriteArray addObject:sprite1];
        float sprite1Timer = CIRCLE_1_INITIAL_TIME;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite1Timer]];
        
        CCSprite *sprite2 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite2.position = ccp(CIRCLE_2_X_COORD, size.height == 568 ? CIRCLE_2_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : CIRCLE_2_Y_COORD);
        [self addChild:sprite2];
        [self.spriteArray addObject:sprite2];
        float sprite2Timer = CIRCLE_2_INITIAL_TIME;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite2Timer]];
        
        CCSprite *sprite3 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite3.position = ccp(CIRCLE_3_X_COORD, size.height == 568 ? CIRCLE_3_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : CIRCLE_3_Y_COORD);
        [self addChild:sprite3];
        [self.spriteArray addObject:sprite3];
        float sprite3Timer = CIRCLE_3_INITIAL_TIME;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite3Timer]];
        
        CCSprite *sprite4 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite4.position = ccp(CIRCLE_4_X_COORD, size.height == 568 ? CIRCLE_4_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : CIRCLE_4_Y_COORD);
        [self addChild:sprite4];
        [self.spriteArray addObject:sprite4];
        float sprite4Timer = CIRCLE_4_INITIAL_TIME;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite4Timer]];
        
        CCSprite *sprite5 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite5.position = ccp(CIRCLE_5_X_COORD, size.height == 568 ? CIRCLE_5_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : CIRCLE_5_Y_COORD);
        [self addChild:sprite5];
        [self.spriteArray addObject:sprite5];
        float sprite5Timer = CIRCLE_5_INITIAL_TIME;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite5Timer]];
        
        CCSprite *sprite6 = [CCSprite spriteWithFile:@"MenuCircle.png"];
        sprite6.position = ccp(CIRCLE_6_X_COORD, size.height == 568 ? CIRCLE_6_Y_COORD + FOUR_INCH_SCREEN_HEIGHT_ADJUSTMENT : CIRCLE_6_Y_COORD);
        [self addChild:sprite6];
        [self.spriteArray addObject:sprite6];
        float sprite6Timer = CIRCLE_6_INITIAL_TIME;
        [self.timeArray addObject:[NSNumber numberWithFloat:sprite6Timer]];
        
        [self setTheSpritesScaleAndColour];
    }
    return self;
}

//updates the time remaining on the timers and resets them when they reach 0.
- (void)update:(ccTime)dt
{
    for (int i = 0; i < 6; i++) {
        //reduce the time by dt (take the module with the max time so that the delay is never larger than the max time.
        float time = [[self.timeArray objectAtIndex:i] floatValue];
        time -= fmodf(dt, MAX_CIRCLE_TIME);
        if (time <= 0) time += MAX_CIRCLE_TIME;
        [self.timeArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:time]];
    }
    [self setTheSpritesScaleAndColour];
}

//sets all six sprites scales based on their time remaining. Sprites will fade in when first appearing and transition to black at the end.
- (void)setTheSpritesScaleAndColour
{
    for (int i = 0; i < 6; i++) {        
        //change the size and colour of the sprites based on the time.
        CCSprite *sprite = [self.spriteArray objectAtIndex:i];
        float time = [[self.timeArray objectAtIndex:i] floatValue];
        float timeProportion = time / MAX_CIRCLE_TIME;
        sprite.scale = timeProportion;
        GLubyte red, green, blue;
        if (timeProportion >= MENU_CRITICAL_THRESHOLD) {
            red = 3;
            green = 171;
            blue = 255;
        } else {
            red = 3 * timeProportion / MENU_CRITICAL_THRESHOLD;
            green = 171 * timeProportion / MENU_CRITICAL_THRESHOLD;
            blue = 255 * timeProportion / MENU_CRITICAL_THRESHOLD;
        }
        sprite.color = ccc3(red, green, blue);
        
        if (time >= MAX_CIRCLE_TIME - 1) {
            sprite.opacity = MENU_CIRCLE_OPACITY * (MAX_CIRCLE_TIME - time);
        } else {
            sprite.opacity = MENU_CIRCLE_OPACITY;
        }
    }
}

@end
