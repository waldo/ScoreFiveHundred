#import <UIKit/UIKit.h>
#import "Game.h"
#import "Round.h"
#import "BiddingViewController.h"

@interface HighestBiddingTeamViewController : UIViewController {
  IBOutlet BiddingViewController* biddingController;
  IBOutlet TricksWonViewController* tricksWonController;
  IBOutlet UITableView* teamSelectionTableView;
  IBOutlet UILabel* nameTeamOne;
  IBOutlet UILabel* nameTeamTwo;
  IBOutlet UILabel* scoreTeamOne;
  IBOutlet UILabel* scoreTeamTwo;

  Game* game;
}

@property (nonatomic, retain) IBOutlet BiddingViewController* biddingController;
@property (nonatomic, retain) IBOutlet TricksWonViewController* tricksWonController;
@property (nonatomic, retain) IBOutlet UITableView* teamSelectionTableView;
@property (nonatomic, retain) UILabel* nameTeamOne;
@property (nonatomic, retain) UILabel* nameTeamTwo;
@property (nonatomic, retain) UILabel* scoreTeamOne;
@property (nonatomic, retain) UILabel* scoreTeamTwo;

@property (nonatomic, retain) Game* game;

- (void) initWithGame:(Game*)g;
- (NSString*) selectedTeam;

@end
