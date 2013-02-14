#import <UIKit/UIKit.h>
#import "Setting.h"

@interface DefendersScoringViewController : UITableViewController

@property Setting *setting;

- (void)initWithSetting:(Setting *)s;

@end
