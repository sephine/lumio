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
@property (nonatomic, strong) CountdownBar *countdownBar;
@property (nonatomic, strong) Light *currentLight;
@property (nonatomic, strong) Light *nextLight;
@property (nonatomic, strong) Light *possibleLight;
@property (nonatomic, strong) CCSprite *sprite;

@end

@implementation Player

@synthesize position = _position;
@synthesize hasCharge = _hasCharge;
@synthesize gameLayer = _gameLayer;
@synthesize route = _route;
@synthesize countdownBar = _countdownBar;
@synthesize currentLight = _currentLight;
@synthesize nextLight = _nextLight;
@synthesize possibleLight = _possibleLight;
@synthesize sprite = _sprite;

- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.sprite.position = position;
}

- (void)setHasCharge:(BOOL)hasCharge
{
    _hasCharge = hasCharge;
    if (hasCharge) {
        self.sprite = [CCSprite spriteWithFile:@"playerbuffed.png"];
    } else {
        self.sprite = [CCSprite spriteWithFile:@"player.png"];
    }
}

- (void)setSprite:(CCSprite *)sprite
{
    [_sprite removeFromParentAndCleanup:YES];
    _sprite = sprite;
    _sprite.position = self.position;
    _sprite.anchorPoint = ccp(0.5, 0.5);
    [self addChild:_sprite z:2];
}

- (id)initWithGameLayer:(GameLayer *)gameLayer route:(id)route currentLight:(Light *)currentLight countdownBar:(CountdownBar *)countdownBar
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.route = route;
        self.route.player = self;
        self.countdownBar = countdownBar;
        self.currentLight = currentLight;
        [self.currentLight occupyLightAndGetValue];
        self.position = currentLight.position;
        
        self.hasCharge = NO;
        [self.gameLayer addChild:self];
    }
    return self;
}

- (void)update:(ccTime)dt
{
    float distanceTravelled = SPEED_IN_POINTS_PER_SECOND * dt;
    
    do {
    distanceTravelled = [self getRemainingDistanceAfterMovingPlayerAlongRouteWithDistance:distanceTravelled];
    } while (distanceTravelled > 0);
}

//used to move the player along the route.
- (float)getRemainingDistanceAfterMovingPlayerAlongRouteWithDistance:(float)distanceTravelled
{
    float remainingDistance = 0;
    if (!self.nextLight && !self.possibleLight) {
        Light *nextLightInRoute = [self.route getNextLightFromRoute];
        if (nextLightInRoute) {
            if (nextLightInRoute.lightState == Cooldown) {
                self.possibleLight = nextLightInRoute;
                self.possibleLight.lightState = Charging;
            } else {
                self.nextLight = nextLightInRoute;
                [self.route removeFirstLightFromRoute];
                [self.currentLight leaveLight];
                [self.nextLight almostOccupyLight];
            }
        }
    }
    
    if (self.possibleLight && self.possibleLight.lightState == Active) {
        self.nextLight = self.possibleLight;
        self.possibleLight = nil;
        self.hasCharge = NO;
        [self.route removeFirstLightFromRoute];
        [self.currentLight leaveLight];
        [self.nextLight almostOccupyLight];
    }
    
    if (self.nextLight) {
        //either difference in height will be equal or difference in width.
        CGFloat differenceInHeight = self.nextLight.position.y - self.position.y;
        CGFloat differenceInWidth = self.nextLight.position.x - self.position.x;
        
        if ((differenceInWidth > 0 && distanceTravelled > differenceInWidth) || (differenceInWidth < 0 && distanceTravelled > -differenceInWidth) ||  (differenceInHeight > 0 && distanceTravelled > differenceInHeight) || (differenceInHeight < 0 && distanceTravelled > -differenceInHeight) || (differenceInWidth == 0 && differenceInHeight == 0)) {
            //next light has been reached.
            self.currentLight = self.nextLight;
            //[self.route removeFirstLightFromRoute];
            //send value to countdown bar.
            LightValue value = [self.currentLight occupyLightAndGetValue];
            if (value == Charge) {
                self.hasCharge = YES;
            } else {
                [self.countdownBar addValue:value];
            }
            
            self.position = self.currentLight.position;
            self.nextLight = nil;
            
            if (differenceInWidth > 0) {
                remainingDistance = distanceTravelled - differenceInWidth;
            } else if (differenceInWidth < 0) {
                remainingDistance = distanceTravelled + differenceInWidth;
            } else if (differenceInHeight > 0) {
                remainingDistance = distanceTravelled - differenceInHeight;
            } else if (differenceInHeight < 0) {
                remainingDistance = distanceTravelled + differenceInHeight;
            } else {
                remainingDistance = distanceTravelled;
            }
        } else if (differenceInWidth > 0) {
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
    return remainingDistance;
}
@end
