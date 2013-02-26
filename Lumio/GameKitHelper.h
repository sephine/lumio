//
//  GameKitHelper.h
//  CircleGame
//
//  Created by Joanne Dyer on 2/20/13.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

//used to notify other objects when Game Center events occur or async tasks are completed.
@protocol GameKitHelperProtocol <NSObject>

- (void)onScoresSubmitted:(BOOL)success;

@end

@interface GameKitHelper : NSObject <GKLeaderboardViewControllerDelegate>

@property (nonatomic, strong) id<GameKitHelperProtocol> delegate;
@property (nonatomic) BOOL authenticationAttempted;
@property (nonatomic) int64_t highScore;
@property (nonatomic) BOOL highScoreFetchedOK;

//holds the last Game Center error
@property (nonatomic, strong) NSError *lastError;

//used to stop sign in popup appearing during game
//@property (nonatomic) BOOL inGame;

+ (id)sharedGameKitHelper;
- (void)authenticateLocalPlayer;
- (void)submitScore:(int64_t)score;
- (void)showLeaderboard;

@end
