#import <UIKit/UIKit.h>
#import "TricksWonViewController.h"
#import "ScoreMiniViewController.h"
#import "Game.h"
#import "Round.h"
#import "BidType.h"
@class GameViewController;

@interface TricksWonSummaryViewController : UIViewController {
  IBOutlet GameViewController* gameController;
  IBOutlet TricksWonViewController* tricksWonController;
  IBOutlet ScoreMiniViewController* scoreController;
  IBOutlet UITableView* table;
  IBOutlet UIBarButtonItem* saveButton;
  
  Game* game;
  Round* round;
}

@property (nonatomic, retain) IBOutlet GameViewController* gameController;
@property (nonatomic, retain) IBOutlet TricksWonViewController* tricksWonController;
@property (nonatomic, retain) IBOutlet ScoreMiniViewController* scoreController;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* saveButton;

@property (nonatomic, retain) Game* game;
@property (nonatomic, retain) Round* round;

- (void) initWithGame:(Game*)g andRound:(Round*)r;
- (IBAction) save:(id)sender;

@end
