#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Setting.h"

@interface GameModeViewController : UITableViewController

@property Setting *setting;

- (void)initWithSetting:(Setting *)s;

@end
