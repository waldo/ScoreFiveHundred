#import <UIKit/UIKit.h>
#import "Game.h"
#import "Round.h"
#import "BiddingViewController.h"
#import "ScoreMiniViewController.h"
#import "RoundDelegate.h"

@protocol RoundDelegate;

@interface HighestBiddingTeamViewController : UITableViewController

@property Game *game;
@property Round *round;
@property(weak) id<RoundDelegate> delegate;

- (void)initWithGame:(Game *)g;
- (IBAction)cancel:(id)sender;

@end
