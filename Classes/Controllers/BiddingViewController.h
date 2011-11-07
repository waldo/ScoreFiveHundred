#import <UIKit/UIKit.h>
#import "TricksWonViewController.h"
#import "Game.h"
#import "Team.h"
#import "BidType.h"
#import "CellWrapper.h"
#import "CellBidType.h"

@interface BiddingViewController : UIViewController {
  IBOutlet TricksWonViewController* tricksWonController;
  IBOutlet UITableView* bidSelectionTableView;
  IBOutlet CellWrapper* cellWrapper;
  IBOutlet UILabel* nameTeamOne;
  IBOutlet UILabel* nameTeamTwo;
  IBOutlet UILabel* scoreTeamOne;
  IBOutlet UILabel* scoreTeamTwo;  
  
  NSArray* bidTypeHands;
  Game* game;
  Team* biddingTeam;
}

@property (nonatomic, retain) IBOutlet TricksWonViewController* tricksWonController;
@property (nonatomic, retain) IBOutlet UITableView* bidSelectionTableView;
@property (nonatomic, retain) IBOutlet CellWrapper* cellWrapper;
@property (nonatomic, retain) UILabel* nameTeamOne;
@property (nonatomic, retain) UILabel* nameTeamTwo;
@property (nonatomic, retain) UILabel* scoreTeamOne;
@property (nonatomic, retain) UILabel* scoreTeamTwo;

@property (nonatomic, retain) NSArray* bidTypeHands;
@property (nonatomic, retain) Game* game;
@property (nonatomic, retain) Team* biddingTeam;

- (NSString*) hand;
- (void) initWithGame:(Game*)g andTeam:(Team*)t;

@end
