//
//  Player.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Light.h"
#import "GameConfig.h"

@interface Player ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic, strong) Route *route;
@property (nonatomic, strong) Light *currentLight;
@property (nonatomic, strong) Light *nextLight;
@property (nonatomic, strong) CCSprite *sprite;

@end

@implementation Player

@synthesize position = _position;
@synthesize gameLayer = _gameLayer;
@synthesize route = _route;
@synthesize currentLight = _currentLight;
@synthesize nextLight = _nextLight;
@synthesize sprite = _sprite;

- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.sprite.position = position;
}

- (void)setSprite:(CCSprite *)sprite
{
    [_sprite removeFromParentAndCleanup:YES];
    _sprite = sprite;
    _sprite.position = self.position;
    _sprite.anchorPoint = ccp(0.5, 0.5);
    [self addChild:_sprite z:2];
}

- (id)initWithGameLayer:(GameLayer *)gameLayer route:(id)route currentLight:(Light *)currentLight
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.route = route;
        self.currentLight = currentLight;
        [self.currentLight occupyLightAndGetValue];
        self.position = currentLight.position;
        
        self.sprite = [CCSprite spriteWithFile:@"BlueCircle.png"];
        [self.gameLayer addChild:self];
    }
    return self;
}

//used to move the player along the route.
- (void)update:(ccTime)dt
{
    if (!self.nextLight) {
        self.nextLight = [self.route getNextLightFromRoute];
        if (self.nextLight) {
            [self.route removeFirstLightFromRoute];
            [self.currentLight leaveLight];
            [self.nextLight almostOccupyLight];
        }
    } else {
        //either difference in height will be equal or difference in width.
        CGFloat differenceInHeight = self.nextLight.position.y - self.position.y;
        CGFloat differenceInWidth = self.nextLight.position.x - self.position.x;
        
        float distanceTravelled = SPEED_IN_POINTS_PER_SECOND * dt;
        if ((differenceInWidth > 0 && distanceTravelled > differenceInWidth) || (differenceInWidth < 0 && distanceTravelled > -differenceInWidth) ||  (differenceInHeight > 0 && distanceTravelled > differenceInHeight) || (differenceInHeight < 0 && distanceTravelled > -differenceInHeight)) {
            //next light has been reached.
            self.currentLight = self.nextLight;
            //[self.route removeFirstLightFromRoute];
            //TODO use value.
            [self.currentLight occupyLightAndGetValue];
            self.position = self.currentLight.position;
            self.nextLight = [self.route getNextLightFromRoute];
            if (self.nextLight) {
                [self.route removeFirstLightFromRoute];
                [self.currentLight leaveLight];
                [self.nextLight almostOccupyLight];
                if (differenceInWidth > 0) {
                    distanceTravelled -= differenceInWidth;
                } else if (differenceInWidth < 0) {
                    distanceTravelled += differenceInWidth;
                } else if (differenceInHeight > 0) {
                    distanceTravelled -= differenceInHeight;
                } else if (differenceInHeight < 0) {
                    distanceTravelled += differenceInHeight;
                }
                differenceInHeight = self.nextLight.position.y - self.position.y;
                differenceInWidth = self.nextLight.position.x - self.position.x;
            } else {
                distanceTravelled = 0;
            }
        }
        
        if (differenceInWidth > 0) {
            CGPoint newPosition = ccp(self.position.x + distanceTravelled, self.position.y);
            self.position = newPosition;
        } else if (differenceInWidth < 0) {
            CGPoint newPosition = ccp(self.position.x - distanceTravelled, self.position.y);
            self.position = newPosition;
        } else if (differenceInHeight > 0) {
            CGPoint newPosition = ccp(self.position.x, self.position.y + distanceTravelled);
            self.position = newPosition;
        } else if (differenceInHeight < 0) {
            CGPoint newPosition = ccp(self.position.x, self.position.y - distanceTravelled);
            self.position = newPosition;
        }
    }
}

- (void)draw
{
    
}

@end
