#import <UIKit/UIKit.h>
#import "TricksWonSummaryViewController.h"
#import "TricksWonViewController.h"
#import "TricksWonMisereViewController.h"
#import "ScoreMiniViewController.h"
#import "Game.h"
#import "Team.h"
#import "BidType.h"
#import "RoundDelegate.h"

@interface BiddingViewController : UITableViewController

@property(weak) id<RoundDelegate> delegate;

- (void)initWithGame:(Game *)g;

@end
