#import <UIKit/UIKit.h>
#import "Game.h"
#import "Round.h"
#import "BiddingViewController.h"
#import "ScoreMiniViewController.h"

@interface HighestBiddingTeamViewController : UIViewController {
  IBOutlet BiddingViewController* biddingController;
  IBOutlet TricksWonSummaryViewController* tricksWonSummaryController;
  IBOutlet TricksWonViewController* tricksWonController;
  IBOutlet UITableView* teamSelectionTableView;
  IBOutlet ScoreMiniViewController* scoreController;
  IBOutlet UIBarButtonItem* cancelButton;

  Game* game;
  Round* round;
}

@property (nonatomic, retain) IBOutlet BiddingViewController* biddingController;
@property (nonatomic, retain) IBOutlet TricksWonSummaryViewController* tricksWonSummaryController;
@property (nonatomic, retain) IBOutlet TricksWonViewController* tricksWonController;
@property (nonatomic, retain) IBOutlet UITableView* teamSelectionTableView;
@property (nonatomic, retain) IBOutlet ScoreMiniViewController* scoreController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* cancelButton;

@property (nonatomic, retain) Game* game;
@property (nonatomic, retain) Round* round;

- (void) initWithGame:(Game*)g;
- (IBAction) cancel:(id)sender;

@end
