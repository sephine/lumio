//
//  Light.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Light.h"
#import "GameConfig.h"

@interface Light ()

@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic) LightState lightState;
@property (nonatomic) LightValue lightValue;
@property (nonatomic, strong) CCSprite *innerCircleSprite;
@property (nonatomic, strong) CCSprite *outerCircleSprite;
@property (nonatomic, strong) CCSprite *valueSprite;
@property (nonatomic) ccTime activeTimeRemaining;
@property (nonatomic) ccTime cooldownTimeRemaining;

@end

static NSMutableArray *allLightInstances = nil;
static BOOL valueLightExists = NO;

@implementation Light

@synthesize position = _position;
@synthesize gridLocation = _gridLocation;
@synthesize isPartOfRoute = _isPartOfRoute;
@synthesize topConnector = _topConnector;
@synthesize rightConnector = _rightConnector;
@synthesize lightState = _lightState;
@synthesize lightValue = _lightValue;
@synthesize gameLayer = _gameLayer;
@synthesize innerCircleSprite = _innerCircleSprite;
@synthesize outerCircleSprite = _outerCircleSprite;
@synthesize valueSprite = _valueSprite;
@synthesize activeTimeRemaining = _activeTimeRemaining;
@synthesize cooldownTimeRemaining = _cooldownTimeRemaining;

//when the light position is set also need to set the position of it's sprites and connectors.
- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.innerCircleSprite.position = position;
    self.outerCircleSprite.position = position;
    self.valueSprite.position = position;
    
    //CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint topConnectorPosition = ccp(position.x, position.y + 0.5 * GAME_AREA_HEIGHT / NUMBER_OF_ROWS);
    self.topConnector.position = topConnectorPosition;
    CGPoint rightConnectorPosition = ccp(position.x + 0.5 * GAME_AREA_WIDTH / NUMBER_OF_COLUMNS, position.y);
    self.rightConnector.position = rightConnectorPosition;
}

//set sprites based on whether the light is routed.
- (void)setIsPartOfRoute:(BOOL)isPartOfRoute
{
    _isPartOfRoute = isPartOfRoute;
    if (isPartOfRoute) {
        self.innerCircleSprite = [CCSprite spriteWithFile:@"RoutedCircle.png"];
    } else {
        switch (self.lightState) {
            case Active:
            case AlmostOccupied:
            case Occupied:
                self.innerCircleSprite = [CCSprite spriteWithFile:@"BlackCircle.png"];
                break;
            case Cooldown:
                self.innerCircleSprite = [CCSprite spriteWithFile:@"EmptyCircle.png"];
                break;
            default:
                break;
        }
    }
}

//manage active and cooldown timers and sprites based on state.
- (void)setLightState:(LightState)lightState
{
    _lightState = lightState;
    switch (lightState) {
        case Active:
            self.innerCircleSprite = [CCSprite spriteWithFile:@"BlackCircle.png"];
            break;
        case Cooldown:
            self.innerCircleSprite = [CCSprite spriteWithFile:@"EmptyCircle.png"];
            //self.lightValue = [self generateLightValue];
            LightValue oldValue = self.lightValue;
            self.lightValue = NoValue;
            if (oldValue == High) {
                [Light chooseNewValueLight];
            }
            
            self.activeTimeRemaining = [self generateActiveTime];
            self.cooldownTimeRemaining = [self generateCooldownTime];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:NOTIFICATION_LIGHT_ON_COOLDOWN
             object:self];
            break;
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
            self.valueSprite = [CCSprite spriteWithFile:@"Number1.png"];
            break;
        case Medium:
            self.valueSprite = [CCSprite spriteWithFile:@"Number3.png"];
            break;
        case High:
            self.valueSprite = [CCSprite spriteWithFile:@"Number9White.png"];
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
    _innerCircleSprite.anchorPoint = ccp(0.5, 0.5);
    [self addChild:_innerCircleSprite z:2];
}

//when you change the file for a sprite you need to remove the sprite and add it again.
- (void)setOuterCircleSprite:(CCSprite *)outerCircleSprite
{
    [_outerCircleSprite removeFromParentAndCleanup:YES];
    _outerCircleSprite = outerCircleSprite;
    _outerCircleSprite.position = self.position;
    _outerCircleSprite.anchorPoint = ccp(0.5, 0.5);
    [self addChild:_outerCircleSprite z:1];
}

//when you change the file for a sprite you need to remove the sprite and add it again.
- (void)setValueSprite:(CCSprite *)valueSprite
{
    [_valueSprite removeFromParentAndCleanup:YES];
    _valueSprite = valueSprite;
    _valueSprite.position = self.position;
    _valueSprite.anchorPoint = ccp(0.5, 0.5);
    [self addChild:_valueSprite z:3];
}

- (id)initWithGameLayer:(GameLayer *)gameLayer gridLocation:(struct GridLocation)gridLocation
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        self.gridLocation = gridLocation;
        
        //add the instance to the array of all instances.
        if (!allLightInstances) {
            allLightInstances = [[NSMutableArray alloc] init];
        }
        [allLightInstances addObject:self];
        
        //Generate value, start the lights on cooldown and active and give them a time between 0 and the max.
        //self.lightValue = [self generateLightValue];
        self.lightValue = NoValue;
        
        self.isPartOfRoute = NO;
        int randomPercentage = arc4random() % 100;
        if (randomPercentage < PERCENTAGE_OF_LIGHTS_START_ON_COOLDOWN) {
            self.lightState = Cooldown;
            self.cooldownTimeRemaining = arc4random() % MAX_COOLDOWN + 1;
        } else {
            self.lightState = Active;
            self.activeTimeRemaining = arc4random() % MAX_COUNTDOWN + 1;
        }
        
        //create the connectors based on grid location.
        self.topConnector = nil;
        if (self.gridLocation.row != NUMBER_OF_ROWS - 1) {
            self.topConnector = [[Connector alloc] initWithGameLayer:self.gameLayer orientation:Vertical];
        }
        
        self.rightConnector = nil;
        if (self.gridLocation.column != NUMBER_OF_COLUMNS - 1) {
            self.rightConnector = [[Connector alloc] initWithGameLayer:self.gameLayer orientation:Horizontal];
        }
        
        //Create sprites and add to layer.
        [self.gameLayer addChild:self];
        
        //sprites are added to the layer in their setters.
        self.outerCircleSprite = [CCSprite spriteWithFile:@"WhiteCircle.png"];
    }
    return self;
}

//updates the time remaining on the timers.
- (void)update:(ccTime)dt
{
    switch (self.lightState) {
        case Active:
            self.activeTimeRemaining -= dt;
            if (self.activeTimeRemaining < 0) {
                self.lightState = Cooldown;
            }
            break;
        case Cooldown:
            self.cooldownTimeRemaining -= dt;
            if (self.cooldownTimeRemaining < 0) {
                self.lightState = Active;
            }
            break;
        case AlmostOccupied:
            self.activeTimeRemaining -= dt;
            if (self.activeTimeRemaining < 0) self.activeTimeRemaining = 0;
        default:
            break;
    }
}

//used by the touch method to check if this sprite has been touched.
- (CGRect)getBounds
{
    CGSize size = [self.innerCircleSprite contentSize];
    return CGRectMake(self.position.x - size.width * self.innerCircleSprite.anchorPoint.x,
                      self.position.y - size.height * self.innerCircleSprite.anchorPoint.y,
                      size.width, size.height);
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
    self.lightState = Occupied;
    LightValue oldValue = self.lightValue;
    self.lightValue = NoValue;
    if (oldValue == High || !valueLightExists) {
        [Light chooseNewValueLight];
        valueLightExists = YES;
    }
    return oldValue;
}

//used by the player at the moment it moves from a light, sets the state to active again with a new time and value.
- (void)leaveLight
{
    //self.lightValue = [self generateLightValue];
    self.activeTimeRemaining = [self generateActiveTime];
    self.lightState = Active;
}

+ (void)chooseNewValueLight
{
    int numberOfLights = allLightInstances.count;
    
    //choose an instance to change to a value light. This light can not be almost occupied, or occupied.
    int randomIndex;
    Light *chosenLight;
    do {
        randomIndex = arc4random() % numberOfLights;
        chosenLight = [allLightInstances objectAtIndex:randomIndex];
    } while (chosenLight.lightState == AlmostOccupied || chosenLight.lightState == Occupied);
    
    //tell this light to give itself a value.
    [chosenLight setUpLightWithValue];
}

- (void)setUpLightWithValue
{
    self.lightValue = High;
    self.lightState = Active;
    self.activeTimeRemaining = [self generateValueActiveTime];
}

- (void)draw
{
    switch (self.lightState) {
        case Active:
        case AlmostOccupied:
        case Occupied:
            [self setSpriteScaleAndColourForActiveTimeRemaining];
            self.outerCircleSprite.opacity = OUTER_CIRCLE_OPACITY;
            if (self.lightValue == High) {
                self.valueSprite.opacity = OPAQUE;
            } else {
                self.valueSprite.opacity = TRANSPARENT;
            }
            //self.innerCircleSprite.opacity = INNER_CIRCLE_OPACITY;
            break;
        case Cooldown:
            [self setSpriteScaleAndColourForActiveTimeRemaining];
            self.outerCircleSprite.opacity = TRANSPARENT;
            self.valueSprite.opacity = TRANSPARENT;
            //self.innerCircleSprite.opacity = TRANSPARENT;
            break;
        default:
            break;
    }
}

//generates a random value based on the high, medium and low percentages.
/*- (LightValue)generateLightValue
{
    LightValue lightValue = Low;
    int randomPercentage = arc4random() % 100;
    if (randomPercentage < HIGH_VALUE_PERCENTAGE) {
        lightValue = High;
    } else if (randomPercentage < HIGH_VALUE_PERCENTAGE + MEDIUM_VALUE_PERCENTAGE) {
        lightValue = Medium;
    }
    return lightValue;
}*/

//generates a time based on the split between high countdowns and low countdowns and randomly chooses a time in the given range.
- (float)generateActiveTime
{
    //int randomPercentage = arc4random() % 100;
    int countdown;
    //if (randomPercentage < LOW_COUNTDOWN_PERCENTAGE) {
    //    countdown = arc4random() % (LOW_MAX_COUNTDOWN - LOW_MIN_COUNTDOWN + 1) + LOW_MIN_COUNTDOWN;
    //} else {
        countdown = arc4random() % (MAX_COUNTDOWN - MIN_COUNTDOWN + 1) + MIN_COUNTDOWN;
    //}
    return countdown;
}

- (float)generateValueActiveTime
{
    return arc4random() % (MAX_VALUE_COUNTDOWN - MIN_VALUE_COUNTDOWN + 1) + MIN_VALUE_COUNTDOWN;
}

//generates a random cooldown time within the given range.
- (float)generateCooldownTime
{
    return arc4random() % (MAX_COOLDOWN - MIN_COOLDOWN + 1) + MIN_COOLDOWN;
}

//sets the scale and colour of the outer circle sprite based on time remaining. It will start out green then transition to red at the critical threshold then transition to black.
- (void)setSpriteScaleAndColourForActiveTimeRemaining
{
    float timeProportion = self.activeTimeRemaining / MAX_COUNTDOWN;
    if (timeProportion > 1) timeProportion = 1;
    
    CGFloat newScale = ((MAX_RADIUS - MIN_RADIUS) * timeProportion + MIN_RADIUS)/MAX_RADIUS;
    self.outerCircleSprite.scale = newScale;
    GLubyte red = 0;
    GLubyte green = 0;
    if (timeProportion >= CRITICAL_THRESHOLD) {
        red = 255 - 255 * (timeProportion - CRITICAL_THRESHOLD) / (1 - CRITICAL_THRESHOLD);
        green = 255 * (timeProportion - CRITICAL_THRESHOLD) / (1 - CRITICAL_THRESHOLD);
    } else {
        red = 255 * timeProportion / CRITICAL_THRESHOLD;
    }
    self.outerCircleSprite.color = ccc3(red, green, 0);
}

@end
