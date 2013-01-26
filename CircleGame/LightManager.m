//
//  LightManager.m
//  CircleGame
//
//  Created by Joanne Dyer on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "LightManager.h"
#import "GameConfig.h"

@interface LightManager ()

@property (nonatomic, strong) NSMutableArray *allLightInstances;

@end

@implementation LightManager

@synthesize allLightInstances = _allLightInstances;

- (id)init
{
    if (self = [super init]) {
        self.allLightInstances = [NSMutableArray array];
        
        //add self as listener to the new value light needed notifcication.
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(newValueLightNeededEventHandler:)
         name:NOTIFICATION_NEW_VALUE_LIGHT_NEEDED
         object:nil];
    }
    return self;
}

- (void)addToAllLightInstances:(Light *)light
{
    [self.allLightInstances addObject:light];
}

//handles the events sent by lights when a value light has been occupied.
- (void)newValueLightNeededEventHandler:(NSNotification *)notification
{
    [self chooseNewValueLight];
}

- (void)chooseNewValueLight
{
    int numberOfLights = self.allLightInstances.count;
    
    //choose an instance to change to a value light. This light can not be almost occupied, or occupied.
    int randomIndex;
    Light *chosenLight;
    do {
        randomIndex = arc4random() % numberOfLights;
        chosenLight = [self.allLightInstances objectAtIndex:randomIndex];
    } while (![chosenLight canBeValueLight]);
    
    //tell this light to give itself a value.
    [chosenLight setUpLightWithValue];
}

@end
