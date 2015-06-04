//
//  Player.m
//  Lumio
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "Player.h"
#import "Light.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"

//class contains all the functionality for the player object whose movement is controlled by the user.
@interface Player ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic, strong) Route *route;
@property (nonatomic, strong) CountdownBar *countdownBar;
@property (nonatomic, strong) Score *score;
@property (nonatomic, strong) Light *currentLight;
@property (nonatomic, strong) Light *nextLight;
@property (nonatomic, strong) Light *possibleLight;
@property (nonatomic, strong) CCSprite *sprite;

@end

@implementation Player

@synthesize position = _position;

//when the player's position is set also need to set the position of it's sprite.
- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.sprite.position = position;
}

//set whether the player is charged and change it's appearance accordingly.
- (void)setHasCharge:(BOOL)hasCharge
{
    _hasCharge = hasCharge;
    if (hasCharge) {
        self.sprite = [CCSprite spriteWithFile:@"playerbuffed.png"];
    } else {
        self.sprite = [CCSprite spriteWithFile:@"player.png"];
    }
}

//when you change the file for a sprite you need to remove the sprite and add it again.
- (void)setSprite:(CCSprite *)sprite
{
    [_sprite removeFromParentAndCleanup:YES];
    _sprite = sprite;
    _sprite.position = self.position;
    [self addChild:_sprite z:2];
}

- (id)initWithGameLayer:(GameLayer *)gameLayer route:(id)route currentLight:(Light *)currentLight countdownBar:(CountdownBar *)countdownBar score:(Score *)score
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.route = route;
        self.route.player = self;
        
        self.countdownBar = countdownBar;
        self.score = score;
        
        self.currentLight = currentLight;
        
        //let the current light know it has been occupied by the player.
        [self.currentLight occupyLightAndGetValue];
        self.position = currentLight.position;
        
        self.hasCharge = NO;
        [self.gameLayer addChild:self];
    }
    return self;
}

//moves the player along the route based on it's speed and the time since last update.
- (void)update:(ccTime)dt
{
    float distanceTravelled = SPEED_IN_POINTS_PER_SECOND * dt;
    
    //keep calling the movement function until all the distance has been used up or there is no where else to go.
    do {
    distanceTravelled = [self getRemainingDistanceAfterMovingPlayerAlongRouteWithDistance:distanceTravelled];
    } while (distanceTravelled > 0);
}

//used to move the player along the route.
- (float)getRemainingDistanceAfterMovingPlayerAlongRouteWithDistance:(float)distanceTravelled
{
    //if there is currently no next light or possible light (one that is charging) check if there is a new one in the route yet.
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
    
    //if the possible light has finished charging set it to the next light and remove the current light from the route and almost occupy the next. Remove the player's charge. 
    if (self.possibleLight && self.possibleLight.lightState == Active) {
        self.nextLight = self.possibleLight;
        self.possibleLight = nil;
        self.hasCharge = NO;
        [self.route removeFirstLightFromRoute];
        [self.currentLight leaveLight];
        [self.nextLight almostOccupyLight];
    }
    
    //if a next light exists move the player towards it by the specified distance.
    if (self.nextLight) {
        //either difference in height will be equal or difference in width.
        CGFloat differenceInHeight = self.nextLight.position.y - self.position.y;
        CGFloat differenceInWidth = self.nextLight.position.x - self.position.x;
        
        //if the next light has not yet been reached but the distance is enough to reach it. Remove the travelled distance, occupy the light and pass the value on.
        if ((differenceInWidth > 0 && distanceTravelled > differenceInWidth) || (differenceInWidth < 0 && distanceTravelled > -differenceInWidth) ||  (differenceInHeight > 0 && distanceTravelled > differenceInHeight) || (differenceInHeight < 0 && distanceTravelled > -differenceInHeight) || (differenceInWidth == 0 && differenceInHeight == 0)) {
            //next light has been reached.
            self.currentLight = self.nextLight;
            LightValue value = [self.currentLight occupyLightAndGetValue];
            if (value == Charge) {
                self.hasCharge = YES;
                [[SimpleAudioEngine sharedEngine] playEffect:@"purpleSoundEffect.wav"];
            } else if (value != NoValue) {
                [self.countdownBar addValue:value];
                [self.score increaseScoreByValue:value];
                [[SimpleAudioEngine sharedEngine] playEffect:@"purpleSoundEffect.wav"];
            }
            
            //move the light to the reached lights position. set the next light to nil as it has been reached.
            self.position = self.currentLight.position;
            self.nextLight = nil;
            
            //remove the distance travelled from the remaining distance (so that when this method is recalled it can continue to travel the remaining distance).
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
        //if the next light can't be reached, move the player towards it by the distance travelled.
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
