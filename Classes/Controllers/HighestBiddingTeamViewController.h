#import <UIKit/UIKit.h>
#import "Game.h"
#import "Round.h"
#import "BiddingViewController.h"
#import "ScoreMiniViewController.h"
#import "RoundDelegate.h"

@protocol RoundDelegate;

@interface HighestBiddingTeamViewController : UITableViewController

@property(weak) id<RoundDelegate> delegate;

- (void)initWithGame:(Game *)g;

@end
