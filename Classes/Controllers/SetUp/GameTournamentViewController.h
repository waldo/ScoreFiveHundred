#import <UIKit/UIKit.h>
#import "Setting.h"

@interface GameTournamentViewController : UITableViewController

@property Setting *setting;
@property NSArray *tournamentOptions;

- (void)initWithSetting:(Setting *)s;

@end
