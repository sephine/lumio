//
//  LightManager.m
//  Lumio
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "LightManager.h"
#import "GameConfig.h"

//used to handle interactions which involve the group of lights as a whole, or the position of the light in the group.
@interface LightManager ()

@property (nonatomic, strong) NSMutableArray *twoDimensionalLightArray;

@end

@implementation LightManager

//lightarray is a two dimensional array that contains all the light objects created by game layer first by row then by column.
- (id)initWithLightArray:(NSMutableArray *)lightArray
{
    if (self = [super init]) {
        self.twoDimensionalLightArray = lightArray;
        
        //set self as the light manager for all the lights and ensure the connectors are in the correct initial states.
        for (NSMutableArray *innerArray in self.twoDimensionalLightArray) {
            for (Light *light in innerArray) {
                light.lightManager = self;
                if (light.lightState == Cooldown) {
                    [self lightNowOnCooldown:light];
                } else {
                    [self lightNowActive:light];
                }
            }
        }
    }
    return self;
}

//calls the update methods for all the stored lights.
- (void)update:(ccTime)dt {
    for (NSMutableArray *innerArray in self.twoDimensionalLightArray) {
        for (Light *light in innerArray) {
            [light update:dt];
        }
    }
}

//called only when the game is first created to make the new value lights.
- (void)chooseFirstLightWithValue:(LightValue)value
{
    NSNumber *boxedValue = [NSNumber numberWithInt:value];
    [self chooseNewLightFollowingDelayWithValue:boxedValue];
}

//called when a value has been taken and a new one is required. Adds a delay before the new value is added.
- (void)chooseNewLightWithValue:(LightValue)value
{
    NSNumber *boxedValue = [NSNumber numberWithInt:value];
    [self performSelector:@selector(chooseNewLightFollowingDelayWithValue:) withObject:boxedValue afterDelay:NEW_VALUE_DELAY_IN_SECONDS];
}

//creates a new value light of the appropriate value.
- (void)chooseNewLightFollowingDelayWithValue:(NSNumber *)value
{
    LightValue lightValue = [value intValue];
    
    //choose an instance to change to a value light. This light can not be almost occupied, or occupied.
    int randomRowIndex, randomColumnIndex;
    Light *chosenLight;
    do {
        //as the board is square we can just choose a row at random then a column at random.
        randomRowIndex = arc4random() % NUMBER_OF_ROWS;
        randomColumnIndex = arc4random() % NUMBER_OF_COLUMNS;
        chosenLight = [self getLightAtRow:randomRowIndex column:randomColumnIndex];
    } while (![chosenLight canBeValueLight]);
    
    //tell this light to give itself a value.
    [chosenLight setUpLightWithValue:lightValue];
}

- (Light *)getSelectedLightFromLocation:(CGPoint)location {
    //go through all the lights seeing if they contain the point.
    Light *selectedLight = nil;
    for (NSMutableArray *innerArray in self.twoDimensionalLightArray) {
        for (Light *light in innerArray) {
            if (CGRectContainsPoint([light getBounds], location)) {
                selectedLight = light;
                break;
            }
        }
    }
    return selectedLight;
}

//returns the light at the provided row and column.
- (Light *)getLightAtRow:(int)row column:(int)column
{
    NSMutableArray *rowArray = [self.twoDimensionalLightArray objectAtIndex:row];
    return [rowArray objectAtIndex:column];
}

//called by a light when it becomes active, will update the state of the relevant connectors.
- (void)lightNowActive:(Light *)light
{
    if (light.row < NUMBER_OF_ROWS - 1) {
        Light *lightAbove = [self getLightAtRow:(light.row + 1) column:light.column];
        if (light.topConnector.state != Routed) light.topConnector.state = lightAbove.lightState == Cooldown ? Disabled : Enabled;
    }
    if (light.column < NUMBER_OF_COLUMNS - 1) {
        Light *lightToTheRight = [self getLightAtRow:light.row column:(light.column + 1)];
        if (light.rightConnector.state != Routed) light.rightConnector.state = lightToTheRight.lightState == Cooldown ? Disabled : Enabled;
    }
    if (light.row > 0) {
        Light *lightBelow = [self getLightAtRow:(light.row - 1) column:light.column];
        if (lightBelow.topConnector.state != Routed) lightBelow.topConnector.state = lightBelow.lightState == Cooldown ? Disabled : Enabled;
    }
    if (light.column > 0) {
        Light *lightToTheLeft = [self getLightAtRow:light.row column:(light.column - 1)];
        if (lightToTheLeft.rightConnector.state != Routed) lightToTheLeft.rightConnector.state = lightToTheLeft.lightState == Cooldown ? Disabled : Enabled;
    }
}

//called by a light when it enters cooldown, will update the state of the relevant connectors and ensure it if removed from the route.
- (void)lightNowOnCooldown:(Light *)light
{
    [self.route removeLightFromRoute:light];
    
    if (light.row < NUMBER_OF_ROWS - 1) {
        light.topConnector.state = Disabled;
    }
    if (light.column < NUMBER_OF_COLUMNS - 1) {
        light.rightConnector.state = Disabled;
    }
    if (light.row > 0) {
        Light *lightBelow = [self getLightAtRow:(light.row - 1) column:light.column];
        lightBelow.topConnector.state = Disabled;
    }
    if (light.column > 0) {
        Light *lightToTheLeft = [self getLightAtRow:light.row column:(light.column - 1)];
        lightToTheLeft.rightConnector.state = Disabled;
    }
}

@end
