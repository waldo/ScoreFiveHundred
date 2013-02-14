#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HighestBiddingTeamViewController.h"
#import "Game.h"
#import "Round.h"
#import "BidType.h"
#import "CellScoringRound.h"
#import "RematchDelegate.h"

@interface GameViewController : UITableViewController <RoundDelegate>

@property(weak) id<RematchDelegate> delegate;

- (void)initWithGame:(Game *)g;

@end
