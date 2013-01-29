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

@property (nonatomic, strong) NSMutableArray *twoDimensionalLightArray;

@end

@implementation LightManager

@synthesize twoDimensionalLightArray = _twoDimensionalLightArray;

- (id)initWithLightArray:(NSMutableArray *)lightArray
{
    if (self = [super init]) {
        self.twoDimensionalLightArray = lightArray;
        
        //add self as listener to the new value light needed notifcication.
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(newValueLightNeededEventHandler:)
         name:NOTIFICATION_NEW_VALUE_LIGHT_NEEDED
         object:nil];
    }
    return self;
}

- (void)update:(ccTime)dt {
    for (NSMutableArray *innerArray in self.twoDimensionalLightArray) {
        for (Light *light in innerArray) {
            [light update:dt];
        }
    }
}

//handles the events sent by lights when a value light has been occupied.
- (void)newValueLightNeededEventHandler:(NSNotification *)notification
{
    [self chooseNewValueLight];
}

- (void)chooseNewValueLight
{    
    //choose an instance to change to a value light. This light can not be almost occupied, or occupied.
    int randomRowIndex, randomColumnIndex;
    Light *chosenLight;
    do {
        //as the board is square we can just choose a row at random then a column at random.
        randomRowIndex = arc4random() % NUMBER_OF_ROWS;
        randomColumnIndex = arc4random() % NUMBER_OF_COLUMNS;
        chosenLight = [[self.twoDimensionalLightArray objectAtIndex:randomRowIndex] objectAtIndex:randomColumnIndex];
    } while (![chosenLight canBeValueLight]);
    
    //tell this light to give itself a value.
    [chosenLight setUpLightWithValue];
}

- (Light *)findSelectedLightFromLocation:(CGPoint)location {
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

@end
