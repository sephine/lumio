//
//  Light.m
//  Lumio
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "Light.h"
#import "GameConfig.h"

//class contains all the functionality for the game light objects.
@interface Light ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic) LightValue lightValue;
@property (nonatomic, strong) CCSprite *innerCircleSprite;
@property (nonatomic, strong) CCSprite *outerCircleSprite;
@property (nonatomic, strong) CCSprite *routedSprite;
@property (nonatomic, strong) CCSprite *valueSprite;
@property (nonatomic) ccTime activeTimeRemaining;
@property (nonatomic) ccTime cooldownTimeRemaining;
@property (nonatomic) ccTime chargeTimeRemaining;

@end

@implementation Light

@synthesize position = _position;

//when the light position is set also need to set the position of it's sprites and connectors.
- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.innerCircleSprite.position = position;
    self.outerCircleSprite.position = position;
    self.routedSprite.position = position;
    self.valueSprite.position = position;
    
    CGPoint topConnectorPosition = ccp(position.x, position.y + 0.5 * SQUARE_SIDE_LENGTH);
    self.topConnector.position = topConnectorPosition;
    CGPoint rightConnectorPosition = ccp(position.x + 0.5 * SQUARE_SIDE_LENGTH, position.y);
    self.rightConnector.position = rightConnectorPosition;
}

//show routed sprite based on whether the light is routed.
- (void)setIsPartOfRoute:(BOOL)isPartOfRoute
{
    _isPartOfRoute = isPartOfRoute;
    if (isPartOfRoute) {
        self.routedSprite.opacity = OPAQUE;
    } else {
        self.routedSprite.opacity = TRANSPARENT;
    }
}

//manage active and cooldown timers and sprites based on state.
- (void)setLightState:(LightState)lightState
{
    _lightState = lightState;
    switch (lightState) {
        case Active:
            if (self.lightValue == NoValue) {
                self.innerCircleSprite = [CCSprite spriteWithFile:@"active.png"];
                self.outerCircleSprite.opacity = OPAQUE;
            } else {
                self.innerCircleSprite = [CCSprite spriteWithFile:@"buffcircle.png"];
                self.outerCircleSprite.opacity = TRANSPARENT;
            }
            //let the light manager know the light is now active so it can handle the connectors from the light appropriately.
            [self.lightManager lightNowActive:self];
            break;
        case Cooldown:
            self.innerCircleSprite = [CCSprite spriteWithFile:@"inactive.png"];
            self.outerCircleSprite.opacity = TRANSPARENT;
            //set the light value to no value and let the light manager know if it had a value so it can choose a new value light.
            LightValue oldValue = self.lightValue;
            self.lightValue = NoValue;
            if (oldValue != NoValue) {
                [self.lightManager chooseNewLightWithValue:oldValue];
            }
            
            //reset the timers.
            self.activeTimeRemaining = [self generateSpawnActiveTime];
            self.cooldownTimeRemaining = [self generateCooldownTime];
            
            //let the light manager know the light is now on cooldown so it can handle the connectors from the light appropriately.
            [self.lightManager lightNowOnCooldown:self];
            break;
        case Charging:
            self.chargeTimeRemaining = CHARGE_TIME;
        default:
            break;
    }
}

//set sprite based on light value.
- (void)setLightValue:(LightValue)lightValue
{
    _lightValue = lightValue;
    switch (lightValue) {
        case Low:
            self.valueSprite = [CCSprite spriteWithFile:@"1star.png"];
            self.valueSprite.opacity = OPAQUE;
            break;
        case Medium:
            self.valueSprite = [CCSprite spriteWithFile:@"2star.png"];
            self.valueSprite.opacity = OPAQUE;
            break;
        case High:
            self.valueSprite = [CCSprite spriteWithFile:@"3star.png"];
            self.valueSprite.opacity = OPAQUE;
            break;
        case Charge:
            self.valueSprite = [CCSprite spriteWithFile:@"buff.png"];
            self.valueSprite.opacity = OPAQUE;
            break;
        case NoValue:
            self.valueSprite.opacity = TRANSPARENT;
            break;
        default:
            break;
    }
}

//when you change the file for a sprite you need to remove the sprite and add it again.
- (void)setInnerCircleSprite:(CCSprite *)innerCircleSprite
{
    [_innerCircleSprite removeFromParentAndCleanup:YES];
    _innerCircleSprite = innerCircleSprite;
    _innerCircleSprite.position = self.position;
    [self addChild:_innerCircleSprite z:2];
}

//when you change the file for a sprite you need to remove the sprite and add it again.
- (void)setValueSprite:(CCSprite *)valueSprite
{
    [_valueSprite removeFromParentAndCleanup:YES];
    _valueSprite = valueSprite;
    _valueSprite.position = self.position;
    [self addChild:_valueSprite z:4];
}

- (id)initWithGameLayer:(GameLayer *)gameLayer row:(int)row column:(int)column
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.row = row;
        self.column = column;
        self.lightValue = NoValue;
        
        //create outer sprite and routed sprite and add to layer. The other layers are added in their setters as they are frequently changed.
        self.outerCircleSprite = [CCSprite spriteWithFile:@"glow.png"];
        self.outerCircleSprite.position = self.position;
        [self addChild:self.outerCircleSprite z:1];
        
        self.routedSprite = [CCSprite spriteWithFile:@"BlueRoutedLayer.png"];
        self.routedSprite.position = self.position;
        self.routedSprite.opacity = TRANSPARENT;
        [self addChild:self.routedSprite z:3];
        self.isPartOfRoute = NO;
        
        //create the connectors based on grid location.
        self.topConnector = nil;
        if (self.row != NUMBER_OF_ROWS - 1) {
            self.topConnector = [[Connector alloc] initWithGameLayer:self.gameLayer orientation:Vertical];
        }
        
        self.rightConnector = nil;
        if (self.column != NUMBER_OF_COLUMNS - 1) {
            self.rightConnector = [[Connector alloc] initWithGameLayer:self.gameLayer orientation:Horizontal];
        }
        
        //Generate value, start the lights on cooldown and active and give them a time between 0 and the max.
        //self.lightValue = [self generateLightValue];
        int randomPercentage = arc4random() % 100;
        if (randomPercentage < PERCENTAGE_OF_LIGHTS_START_ON_COOLDOWN) {
            self.lightState = Cooldown;
            self.cooldownTimeRemaining = arc4random() % INITIAL_MAX_COOLDOWN + 1;
        } else if (randomPercentage < PERCENTAGE_OF_LIGHTS_START_ON_COOLDOWN + PERCENTAGE_OF_LIGHTS_START_ON_MAX_COUNTDOWN) {
            self.lightState = Active;
            self.activeTimeRemaining = arc4random() % (MAX_REFRESH_COUNTDOWN - MIN_REFRESH_COUNTDOWN + 1) + MIN_REFRESH_COUNTDOWN;
        } else {
            self.lightState = Active;
            self.activeTimeRemaining = arc4random() % MAX_REFRESH_COUNTDOWN + 1;
        }
        [self setSpriteScaleAndColourForTimeRemaining];
        
        [self.gameLayer addChild:self];
    }
    return self;
}

//updates the time remaining on the timers (unless the light has a value in which case it lasts forever).
- (void)update:(ccTime)dt
{
    if (self.lightValue == NoValue) {
        switch (self.lightState) {
            case Active:
                self.activeTimeRemaining -= dt;
                if (self.activeTimeRemaining < 0) {
                    self.lightState = Cooldown;
                }
                [self setSpriteScaleAndColourForTimeRemaining];
                break;
            case Cooldown:
                self.cooldownTimeRemaining -= dt;
                if (self.cooldownTimeRemaining < 0) {
                    self.lightState = Active;
                }
                [self setSpriteScaleAndColourForTimeRemaining];
                break;
            case Charging:
                self.chargeTimeRemaining -= dt;
                if (self.chargeTimeRemaining < 0) {
                    self.lightState = Active;
                }
                [self setSpriteScaleAndColourForTimeRemaining];
                break;
            case AlmostOccupied:
                self.activeTimeRemaining -= dt;
                if (self.activeTimeRemaining < 0) self.activeTimeRemaining = 0;
                [self setSpriteScaleAndColourForTimeRemaining];
            default:
                break;
        }
    }
}

- (void)setAsInitialLight
{
    self.lightState = Active;
    self.lightState = Occupied;
}

//used by the touch method to check if this sprite has been touched.
- (CGRect)getBounds
{
    return CGRectMake(self.position.x - SQUARE_SIDE_LENGTH/2,
                      self.position.y - SQUARE_SIDE_LENGTH/2,
                      SQUARE_SIDE_LENGTH, SQUARE_SIDE_LENGTH);
}

//used by the player when it selects the light to be charged and has a charge.
- (void)chargeLight
{
    self.lightState = Charging;
}

//check if this light is in the correct state for routing.
- (BOOL)canAddLightToRoute
{
    //can only add light to route if it is not already in the route and is active.
    return !self.isPartOfRoute && self.lightState == Active;
}

//used by the player when it is approaching the light. it's state has to be set to almost occupied so it doesn't disapear before the player gets there.
- (void)almostOccupyLight
{
    self.lightState = AlmostOccupied;
}

//used by the player when it reaches the light, returns the value of the light.
- (LightValue)occupyLightAndGetValue
{
    LightValue oldValue = self.lightValue;
    self.lightValue = NoValue;
    self.lightState = Occupied;
    if (oldValue != NoValue) {
        [self.lightManager chooseNewLightWithValue:oldValue];
    }
    return oldValue;
}

//used by the player at the moment it moves from a light, sets the state to active again with a new time and value.
- (void)leaveLight
{
    self.activeTimeRemaining = [self generateRefreshActiveTime];
    self.lightState = Active;
}

- (BOOL)canBeValueLight
{
    return !(self.lightState == AlmostOccupied || self.lightState == Occupied || self.lightValue != NoValue);
}

- (void)setUpLightWithValue:(LightValue)value
{
    self.lightValue = value;
    self.lightState = Active;
}

//generates a time based on the split between high refresh countdowns and low refresh countdowns and randomly chooses a time in the given range.
- (float)generateRefreshActiveTime
{
    float activeTimeBeforeReduction = arc4random() % (MAX_REFRESH_COUNTDOWN - MIN_REFRESH_COUNTDOWN + 1) + MIN_REFRESH_COUNTDOWN;
    return activeTimeBeforeReduction - self.lightManager.countdownReduction;
}

//generates a time based on the split between high spawn countdowns and low spawn countdowns and randomly chooses a time in the given range.
- (float)generateSpawnActiveTime
{
    float spawnTimeBeforeReduction = arc4random() % (MAX_SPAWN_COUNTDOWN - MIN_SPAWN_COUNTDOWN + 1) + MIN_SPAWN_COUNTDOWN;
    return spawnTimeBeforeReduction - self.lightManager.countdownReduction;
}

//generates a random cooldown time within the given range.
- (float)generateCooldownTime
{
    int maxCooldown = self.lightManager.maxCooldown;
    return arc4random() % (maxCooldown - MIN_COOLDOWN + 1) + MIN_COOLDOWN;
}

//sets the scale and colour of the outer circle sprite based on the active or cooldown time remaining. It will start out green then transition to red at the critical threshold then transition to black.
- (void)setSpriteScaleAndColourForTimeRemaining
{
    float timeProportion = self.activeTimeRemaining / MAX_REFRESH_COUNTDOWN;
    if (timeProportion > 1) timeProportion = 1;
    
    CGFloat newScale = ((MAX_RADIUS - MIN_RADIUS) * timeProportion + MIN_RADIUS)/MAX_RADIUS;
    
    self.outerCircleSprite.scale = newScale;
    GLubyte red = 0;
    GLubyte green = 0;
    if (timeProportion >= SPEED_UP_THRESHOLD) {
        red = 130 - 130 * (timeProportion - SPEED_UP_THRESHOLD) / (1 - SPEED_UP_THRESHOLD);
        green = 125 + 130 * (timeProportion - SPEED_UP_THRESHOLD) / (1 - SPEED_UP_THRESHOLD);
    } else if (timeProportion >= CRITICAL_THRESHOLD) {
        red = 255 - 125 * (timeProportion - CRITICAL_THRESHOLD) / (SPEED_UP_THRESHOLD - CRITICAL_THRESHOLD);
        green = 125 * (timeProportion - CRITICAL_THRESHOLD) / (SPEED_UP_THRESHOLD - CRITICAL_THRESHOLD);
    } else {
        red = 240 * timeProportion / CRITICAL_THRESHOLD + 15;
    }
    self.outerCircleSprite.color = ccc3(red, green, 0);
}

@end
