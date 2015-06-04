//
//  GameKitHelper.m
//  Lumio
//
//  Created by Joanne Dyer on 2/20/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import "GameKitHelper.h"
#import "AppDelegate.h"
#import "GameConfig.h"

//used by the other objects to handle all interaction with GameCenter
@interface GameKitHelper () <GKGameCenterControllerDelegate>

@property (nonatomic) BOOL userAuthenticated;

@end

@implementation GameKitHelper

- (void)setLastError:(NSError *)lastError
{
    _lastError = [lastError copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

//gets a singleton of GameKitHelper.
+ (id)sharedGameKitHelper
{
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

- (id)init
{
    if (self = [super init]) {
        //get the player's high score from game center.
        self.highScore = 0;
        self.highScoreFetchedOK = NO;
        self.authenticationAttempted = NO;
        
        //set up the notification for if the player authentication has changed (used for ios 5).
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
    }
    return self;
}

//called to authenticate the local player when the app first opens so that game center functionality can be used.
- (void)authenticateLocalPlayer
{
    self.authenticationAttempted = YES;
    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        // Gamekit login for ios 6
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            self.lastError = error;
            
            if (viewController) {
                [self presentViewController:viewController];
            } else if (localPlayer.isAuthenticated) {
                self.userAuthenticated = YES;
                [self getHighScore];
            } else {
                self.userAuthenticated = NO;
                self.highScoreFetchedOK = NO;
                self.highScore = 0;
            }
        };
    } else {
        // Gamekit login for ios 5
        [localPlayer authenticateWithCompletionHandler:nil];
    }
}

//called when the authentication changes (only for ios5)
- (void)authenticationChanged
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    self.userAuthenticated = localPlayer.isAuthenticated;
    if (self.userAuthenticated) {
        [self getHighScore];
    } else {
        self.highScoreFetchedOK = NO;
        self.highScore = 0;
    }
}

//used to show the controller to login to game center.
- (void)presentViewController:(UIViewController *)viewController
{
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController presentViewController:viewController animated:YES completion:nil];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    //no action required.
}

- (void)submitScore:(int64_t)score
{
    //only try and submit score if game center features enabled.
    if (!self.userAuthenticated) {
        NSLog(@"Player not authenticated");
    } else {
        //create score object, there is only one score category. Set the value to the score.
        GKScore* gkScore = [[GKScore alloc] initWithCategory:HIGH_SCORE_CATEGORY];
        gkScore.value = score;
        
        //send score to game center.
        [gkScore reportScoreWithCompletionHandler:^(NSError *error) {
            [self setLastError:error];
            BOOL success = (error == nil);
            [self.delegate onScoresSubmitted:success];
        }];
    }
}

//get the player's high score from game center if possible. Calls localPlayerScoreReceived when done.
- (void)getHighScore
{
    self.highScoreFetchedOK = NO;
    self.highScore = 0;
    if (!self.userAuthenticated) {
        NSLog(@"Player not authenticated");
    } else {
        NSString *localPlayerID = [GKLocalPlayer localPlayer].playerID;
        NSArray *playerIDArray = [NSArray arrayWithObject:localPlayerID];
        GKLeaderboard *leaderboard = [[GKLeaderboard alloc] initWithPlayerIDs:playerIDArray];
        //get the local player score.
        [leaderboard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error){
            self.lastError = error;
            if (!error) {
                [self localPlayerScoreReceived:leaderboard.localPlayerScore];
            }
        }];
    }
}

- (void)localPlayerScoreReceived:(GKScore *)score
{
    self.highScore = score.value;
    self.highScoreFetchedOK = YES;
}

//called by the menu to open the game center leaderboard up.
- (void)showLeaderboard
{
    GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    leaderboardViewController.leaderboardDelegate = self;
    leaderboardViewController.category = HIGH_SCORE_CATEGORY;
    
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [[app navController] presentModalViewController:leaderboardViewController animated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
}

@end
