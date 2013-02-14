#import <UIKit/UIKit.h>
#import "ScoreMiniViewController.h"
#import "Game.h"
#import "Round.h"
#import "BidType.h"
#import "RoundDelegate.h"

@interface TricksWonViewController : UITableViewController

@property Game *game;
@property Round *round;
@property Team *team;
@property(weak) id<RoundDelegate> delegate;

- (void)initWithGame:(Game *)g andTeam:(Team *)t;

@end
