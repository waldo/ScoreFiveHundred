#import <UIKit/UIKit.h>
#import "TricksWonViewController.h"
#import "ScoreMiniViewController.h"
#import "Game.h"
#import "Round.h"
#import "BidType.h"

@class GameViewController;

@interface TricksWonSummaryViewController : UIViewController

@property IBOutlet GameViewController *gameController;
@property IBOutlet TricksWonViewController *tricksWonController;
@property IBOutlet ScoreMiniViewController *scoreController;
@property IBOutlet UITableView *table;
@property IBOutlet UIBarButtonItem *saveButton;
@property Game *game;
@property Round *round;

- (void)initWithGame:(Game *)g andRound:(Round *)r;
- (IBAction)save:(id)sender;

@end
