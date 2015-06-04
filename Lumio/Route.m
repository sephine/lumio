//
//  Route.m
//  Lumio
//
//  Created by Joanne Dyer on 1/19/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "Route.h"
#import "GameConfig.h"

//used to handle the routing of the player around the lights.
@interface Route ()

//light stays on route when occupied, array should never be empty.
@property (nonatomic, strong) GameLayer *gameLayer;
@property (nonatomic, strong) LightManager *lightManager;
@property (nonatomic, strong) NSMutableArray *lightsInRoute;
@property (nonatomic) BOOL containsCooldownLight;

@end

@implementation Route

- (id)initWithGameLayer:(GameLayer *)gameLayer lightManager:(LightManager *)lightManager
{
    if (self = [super init]) {
        self.gameLayer = gameLayer;
        [self.gameLayer addChild:self];
        self.lightManager = lightManager;
        
        self.lightManager.route = self;
        
        self.lightsInRoute = [NSMutableArray array];
        self.containsCooldownLight = NO;
    }
    return self;
}

//called by lights when they enter cooldown and so need to be removed from the route.
- (void)removeLightFromRoute:(Light *)light;
{
    [self removeLightAndAllFollowingFromRoute:light];
}

//used by game layer at the beginning of the game to add the light the player is initially sat in to the route.
- (void)setInitialLight:(Light *)light
{
    [self.lightsInRoute addObject:light];
    light.isPartOfRoute = YES;
}

//called by game layer when a light has been touched, either removed it from route or tries to add it.
- (void)lightSelected:(Light *)light
{
    //if light is in route remove it and all the lights following it. Otherwise add light to route if possible.
    if ([self.lightsInRoute containsObject:light]) {
        [self removeLightAndAllFollowingFromRoute:light];
    } else {        
        Light *lastLightInRoute = [self.lightsInRoute lastObject];
        //Check if a route between this light and the current last light in the route is viable. If yes, add all the between to the route and note which direction the route goes.
        BOOL viableRoute = NO;
        BOOL routeContainsCooldownLight = self.containsCooldownLight;
        NSMutableArray *lightsToAddToRoute = [NSMutableArray array];
        //first check if the light is either directly horizontal or directly vertical from the last light in the route.
        RouteDirection routeDirection = [self getDirectionBetweenFirstLight:lastLightInRoute andSecondLight:light];

        //If route direction is left or right go through each light in the columns between the light and the last light in the route checking if they are in the correct state. If route direction is up or down, go through rows.
        if (routeDirection == Right) {
            viableRoute = YES;
            for (int column = lastLightInRoute.column + 1; column <= light.column; column++) {
                Light *lightAtLocation = [self.lightManager getLightAtRow:light.row column:column];
                
                //if the light is in the correct state to be routed, or is the selected light and the player is charged add it to the array of lights to add, else break the loop as no lights will be added.
                if ([lightAtLocation canAddLightToRoute]) {
                    [lightsToAddToRoute addObject:lightAtLocation];
                } else if (self.player.hasCharge && !routeContainsCooldownLight && lightAtLocation.lightState == Cooldown) {
                    [lightsToAddToRoute addObject:lightAtLocation];
                    routeContainsCooldownLight = YES;
                } else {
                    viableRoute = NO;
                    break;
                }
            }
        } else if (routeDirection == Left) {
            viableRoute = YES;
            for (int column = lastLightInRoute.column - 1; column >= light.column; column--) {
                Light *lightAtLocation = [self.lightManager getLightAtRow:light.row column:column];
                
                //if the light is in the correct state to be routed add it to the array of lights to add, else break the loop as no lights will be added.
                if ([lightAtLocation canAddLightToRoute]) {
                    [lightsToAddToRoute addObject:lightAtLocation];
                } else if (self.player.hasCharge && !routeContainsCooldownLight && lightAtLocation.lightState == Cooldown) {
                    [lightsToAddToRoute addObject:lightAtLocation];
                    routeContainsCooldownLight = YES;
                } else {
                    viableRoute = NO;
                    break;
                }
            }
        } else if (routeDirection == Up) {
            viableRoute = YES;
            for (int row = lastLightInRoute.row + 1; row <= light.row; row++) {
                Light *lightAtLocation = [self.lightManager getLightAtRow:row column:light.column];
                
                //if the light is in the correct state to be routed add it to the array of lights to add, else break the loop as no lights will be added.
                if ([lightAtLocation canAddLightToRoute]) {
                    [lightsToAddToRoute addObject:lightAtLocation];
                } else if (self.player.hasCharge && !routeContainsCooldownLight && lightAtLocation.lightState == Cooldown) {
                    [lightsToAddToRoute addObject:lightAtLocation];
                    routeContainsCooldownLight = YES;
                } else {
                    viableRoute = NO;
                    break;
                }
            }
        } else if (routeDirection == Down) {
            viableRoute = YES;
            for (int row = lastLightInRoute.row - 1; row >= light.row; row--) {
                Light *lightAtLocation = [self.lightManager getLightAtRow:row column:light.column];
                
                //if the light is in the correct state to be routed add it to the array of lights to add, else break the loop as no lights will be added.
                if ([lightAtLocation canAddLightToRoute]) {
                    [lightsToAddToRoute addObject:lightAtLocation];
                } else if (self.player.hasCharge && !routeContainsCooldownLight && lightAtLocation.lightState == Cooldown) {
                    [lightsToAddToRoute addObject:lightAtLocation];
                    routeContainsCooldownLight = YES;
                } else {
                    viableRoute = NO;
                    break;
                }
            }
        }
        
        //if the route ended up being viable, add all the of the lights between the provided light and the last light in the array to the route and set up their connectors.
        if (viableRoute) {
            [self.lightsInRoute addObjectsFromArray:lightsToAddToRoute];
            self.containsCooldownLight = routeContainsCooldownLight;
            int numberOfNewLights = lightsToAddToRoute.count;
            for (int i = 0; i < numberOfNewLights; i++) {
                Light *lightAtIndex = [lightsToAddToRoute objectAtIndex:i];
                lightAtIndex.isPartOfRoute = YES;
                switch (routeDirection) {
                    case Up:
                        lastLightInRoute.topConnector.state = Routed;
                        if (i < numberOfNewLights - 1) lightAtIndex.topConnector.state = Routed;
                        break;
                    case Down:
                        lightAtIndex.topConnector.state = Routed;
                        break;
                    case Left:
                        lightAtIndex.rightConnector.state = Routed;
                        break;
                    case Right:
                        lastLightInRoute.rightConnector.state = Routed;
                        if (i < numberOfNewLights - 1) lightAtIndex.rightConnector.state = Routed;
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

//used by player to get the second light in the route so it can travel to it. (The first light will be the one it is already at.)
- (Light *)getNextLightFromRoute
{
    Light *nextLight = nil;
    if (self.lightsInRoute.count >= 2) {
        nextLight = [self.lightsInRoute objectAtIndex:1];
    } 
    return nextLight;
}

//used by player when it starts moving to the next light in the route from the first.
- (void)removeFirstLightFromRoute
{
    int count = self.lightsInRoute.count;
    if (count >= 2) {
        Light *firstLight = [self.lightsInRoute objectAtIndex:0];
        firstLight.isPartOfRoute = NO;
        [self.lightsInRoute removeObjectAtIndex:0];
        [self updateContainsCooldownLight];
        
        //update connector states following delay of the time it takes to travel half the distance between the lights.
        float delay = SQUARE_SIDE_LENGTH / SPEED_IN_POINTS_PER_SECOND / 2.0;
        [self performSelector:@selector(updateConntectorsFollowingDelayForFirstLight:) withObject:firstLight afterDelay:delay];
    }
}

//change connectors from routed to enabled for lights removed from route.
- (void)updateConntectorsFollowingDelayForFirstLight:(Light *)firstLight
{
    //The previous first light will have been removed from the array.
    Light *secondLight = [self.lightsInRoute objectAtIndex:0];
    RouteDirection routeDirection = [self getDirectionBetweenFirstLight:firstLight andSecondLight:secondLight];
    switch (routeDirection) {
        case Up:
            firstLight.topConnector.state = Enabled;
            break;
        case Down:
            secondLight.topConnector.state = Enabled;
            break;
        case Left:
            secondLight.rightConnector.state = Enabled;
            break;
        case Right:
            firstLight.rightConnector.state = Enabled;
            break;
        default:
            break;
    }
}

//used when a touch removes part of the route or a light goes on to cooldown.
- (void)removeLightAndAllFollowingFromRoute:(Light *)light
{
    //if light is in route remove it and all the lights following it. Set each light as no longer part of the route.
    if ([self.lightsInRoute containsObject:light]) {
        int lightIndex = [self.lightsInRoute indexOfObject:light];
        
        //do not remove the first light in the route, or a light that is charging.
        if (lightIndex >= 1 && light.lightState != Charging) {
            int arrayLength = self.lightsInRoute.count;
            for (int i = lightIndex - 1; i < arrayLength - 1; i++) {
                Light *previousLight = [self.lightsInRoute objectAtIndex:i];
                Light *nextLight = [self.lightsInRoute objectAtIndex:i + 1];
                nextLight.isPartOfRoute = NO;
                RouteDirection routeDirection = [self getDirectionBetweenFirstLight:previousLight andSecondLight:nextLight];
                if (routeDirection == Up) {
                    previousLight.topConnector.state = (previousLight.lightState == Cooldown || nextLight.lightState == Cooldown) ? Disabled : Enabled;
                } else if (routeDirection == Right) {
                    previousLight.rightConnector.state = (previousLight.lightState == Cooldown || nextLight.lightState == Cooldown) ? Disabled : Enabled;
                } else if (routeDirection == Down) {
                    nextLight.topConnector.state = (previousLight.lightState == Cooldown || nextLight.lightState == Cooldown) ? Disabled : Enabled;
                } else if (routeDirection == Left) {
                    nextLight.rightConnector.state = (previousLight.lightState == Cooldown || nextLight.lightState == Cooldown) ? Disabled : Enabled;
                }
            }
        
            NSRange rangeOfIndices = {lightIndex, arrayLength - lightIndex};
            [self.lightsInRoute removeObjectsInRange:rangeOfIndices];
        }
    }
    
    [self updateContainsCooldownLight];
}

//called to check if the route still contains a cooldown light and so cannot contain another.
- (void)updateContainsCooldownLight
{
    //check if route still contains a cooldown or charging light.
    BOOL routeContainsCooldownLight = NO;
    for (Light *light in self.lightsInRoute) {
        if (light.lightState == Cooldown || light.lightState == Charging) {
            routeContainsCooldownLight = YES;
            break;
        }
    }
    self.containsCooldownLight = routeContainsCooldownLight;
}

//gets direction between two lights (up, down, left, right) to help with routing.
- (RouteDirection)getDirectionBetweenFirstLight:(Light *)firstLight andSecondLight:(Light *)secondLight
{
    RouteDirection direction = None;
    BOOL rowsAreEqual = (secondLight.row == firstLight.row);
    BOOL columnsAreEqual = (secondLight.column == firstLight.column);
    
    if (rowsAreEqual) {
        if (firstLight.column < secondLight.column) {
            direction = Right;
        } else {
            direction = Left;
        }
    } else if (columnsAreEqual) {
        if (firstLight.row < secondLight.row) {
            direction = Up;
        } else {
            direction = Down;
        }
    }
    return direction;
}

@end
