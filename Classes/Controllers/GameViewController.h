#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HighestBiddingTeamViewController.h"
#import "Game.h"
#import "Round.h"
#import "BidType.h"
#import "CellScoringRound.h"
#import "RematchDelegate.h"

@interface GameViewController : UITableViewController <RoundDelegate>

@property IBOutlet UIBarButtonItem *addBarButton;
@property IBOutlet UIBarButtonItem *rematchBarButton;
@property IBOutlet UIButton *addButton;
@property IBOutlet UIButton *rematchButton;
@property ScoreMiniViewController *scoreSummary;
@property Game *game;
@property(weak) id<RematchDelegate> delegate;

- (void)initWithGame:(Game *)g;
- (IBAction)rematch:(id)sender;

@end
