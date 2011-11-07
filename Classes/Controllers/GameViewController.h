#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HighestBiddingTeamViewController.h"
#import "Game.h"
#import "Round.h"
#import "BidType.h"
#import "CellWrapper.h"
#import "CellScoringRound.h"

@interface GameViewController : UIViewController {
  IBOutlet HighestBiddingTeamViewController* highestBidderController;
  IBOutlet UITableView* roundsTableView;
  IBOutlet CellWrapper* cellWrapper;
  IBOutlet UIBarButtonItem* editButton;
  IBOutlet UITextField* teamOneName;
  IBOutlet UITextField* teamTwoName;
  IBOutlet UIButton* bidButton;
  IBOutlet UIButton* congratulations;
  IBOutlet UILabel* dividerTop;
  
  Game* game;
}

@property (nonatomic, retain) IBOutlet HighestBiddingTeamViewController* highestBidderController;
@property (nonatomic, retain) IBOutlet UITableView* roundsTableView;
@property (nonatomic, retain) IBOutlet CellWrapper* cellWrapper;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* editButton;
@property (nonatomic, retain) IBOutlet UITextField* teamOneName;
@property (nonatomic, retain) IBOutlet UITextField* teamTwoName;
@property (nonatomic, retain) IBOutlet UIButton* bidButton;
@property (nonatomic, retain) IBOutlet UIButton* congratulations;
@property (nonatomic, retain) IBOutlet UILabel* dividerTop;

@property (nonatomic, retain) Game* game;

- (IBAction) edit:(id)sender;
- (IBAction) bid:(id)sender;
- (IBAction) rematch:(id)sender;

- (void) initWithGame:(Game*)g;
- (void) addFinalisedRound:(Round*)r;

@end