#import <UIKit/UIKit.h>
#import "TricksWonViewController.h"
#import "ScoreMiniViewController.h"
#import "Game.h"
#import "Round.h"
#import "BidType.h"

@class GameViewController;

@interface TricksWonSummaryViewController : UIViewController

- (void)initWithGame:(Game *)g andRound:(Round *)r;

@end
