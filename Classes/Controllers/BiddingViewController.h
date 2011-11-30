#import <UIKit/UIKit.h>
#import "TricksWonSummaryViewController.h"
#import "TricksWonViewController.h"
#import "ScoreMiniViewController.h"
#import "Game.h"
#import "Team.h"
#import "BidType.h"
#import "CellWrapper.h"
#import "CellBidType.h"

@interface BiddingViewController : UIViewController {
  IBOutlet TricksWonSummaryViewController* tricksWonSummaryController;
  IBOutlet TricksWonViewController* tricksWonController;
  IBOutlet ScoreMiniViewController* scoreController;
  IBOutlet UITableView* bidSelectionTableView;
  IBOutlet CellWrapper* cellWrapper;
  IBOutlet UILabel* nameTeamOne;
  IBOutlet UILabel* nameTeamTwo;
  IBOutlet UILabel* scoreTeamOne;
  IBOutlet UILabel* scoreTeamTwo;
  
  NSArray* bidTypeHands;
  Game* game;
  Round* round;
}

@property (nonatomic, retain) IBOutlet TricksWonSummaryViewController* tricksWonSummaryController;
@property (nonatomic, retain) IBOutlet TricksWonViewController* tricksWonController;
@property (nonatomic, retain) IBOutlet ScoreMiniViewController* scoreController;
@property (nonatomic, retain) IBOutlet UITableView* bidSelectionTableView;
@property (nonatomic, retain) IBOutlet CellWrapper* cellWrapper;

@property (nonatomic, retain) NSArray* bidTypeHands;
@property (nonatomic, retain) Game* game;
@property (nonatomic, retain) Round* round;

- (NSString*) hand;
- (void) initWithGame:(Game*)g andRound:(Round*)r;

@end
