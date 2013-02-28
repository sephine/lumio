//
//  GameKitHelper.h
//  Lumio
//
//  Created by Joanne Dyer on 2/20/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

//used to notify other objects when Game Center events occur or async tasks are completed.
@protocol GameKitHelperProtocol <NSObject>

- (void)onScoresSubmitted:(BOOL)success;

@end

//used by the other objects to handle all interaction with GameCenter
@interface GameKitHelper : NSObject <GKLeaderboardViewControllerDelegate>

@property (nonatomic, strong) id<GameKitHelperProtocol> delegate;
@property (nonatomic) BOOL authenticationAttempted;
@property (nonatomic) int64_t highScore;
@property (nonatomic) BOOL highScoreFetchedOK;

//holds the last Game Center error
@property (nonatomic, strong) NSError *lastError;

+ (id)sharedGameKitHelper;
- (void)authenticateLocalPlayer;
- (void)submitScore:(int64_t)score;
- (void)showLeaderboard;

@end
