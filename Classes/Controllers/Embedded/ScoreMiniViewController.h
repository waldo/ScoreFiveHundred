#import <UIKit/UIKit.h>
#import "Game.h"

@interface ScoreMiniViewController : UIViewController

@property UILabel *nameTeamOne;
@property UILabel *nameTeamTwo;
@property UILabel *scoreTeamOne;
@property UILabel *scoreTeamTwo;
@property Game *game;

- (void)initWithGame:(Game *)g;

@end
