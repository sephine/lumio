//
//  GameKitHelper.m
//  CircleGame
//
//  Created by Joanne Dyer on 2/20/13.
//
//

#import "GameKitHelper.h"
#import "AppDelegate.h"
#import "GameConfig.h"

@interface GameKitHelper () <GKGameCenterControllerDelegate>

@property (nonatomic) BOOL gameCenterFeaturesEnabled;

@end

@implementation GameKitHelper

@synthesize delegate = _delegate;
@synthesize lastError = _lastError;
//@synthesize inGame = _inGame;
@synthesize gameCenterFeaturesEnabled = _gameCenterFeaturesEnabled;
@synthesize highScore = _highScore;
@synthesize highScoreFetchedOK = _highScoreFetchedOK;

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
        [self getHighScore];
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        self.lastError = error;
        
        if (viewController) {
            //TODO ensure this either doesn't appear in game or that it pauses the game.
            [self presentViewController:viewController];
        } else if (localPlayer.isAuthenticated) {
            self.gameCenterFeaturesEnabled = YES;
        } else {
            self.gameCenterFeaturesEnabled = NO;
        }
    };
}

- (void)presentViewController:(UIViewController *)viewController
{
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController presentViewController:viewController animated:YES completion:nil];
}

- (void)submitScore:(int64_t)score
{
    //only try and submit score if game center features enabled.
    if (!self.gameCenterFeaturesEnabled) {
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
        
        //TODO shouldn't we let them know if the score wasn't submitted cause they're not logged in to Game Center?
    }
}

- (void)getHighScore
{
    if (!self.gameCenterFeaturesEnabled) {
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

- (void)showLeaderboard
{
    GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    leaderboardViewController.leaderboardDelegate = self;
    
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [[app navController] presentModalViewController:leaderboardViewController animated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
