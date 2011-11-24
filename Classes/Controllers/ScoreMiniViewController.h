#import <UIKit/UIKit.h>
#import "Game.h"

@interface ScoreMiniViewController : UIViewController {
  IBOutlet UILabel* nameTeamOne;
  IBOutlet UILabel* nameTeamTwo;
  IBOutlet UILabel* scoreTeamOne;
  IBOutlet UILabel* scoreTeamTwo;
}

@property (nonatomic, retain) UILabel* nameTeamOne;
@property (nonatomic, retain) UILabel* nameTeamTwo;
@property (nonatomic, retain) UILabel* scoreTeamOne;
@property (nonatomic, retain) UILabel* scoreTeamTwo;

- (void) initWithGame:(Game*)g;
- (void) setStandardFrame;

@end
