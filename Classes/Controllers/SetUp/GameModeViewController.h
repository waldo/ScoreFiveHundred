#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Setting.h"
@class GameSetUpViewController;

@interface GameModeViewController : UIViewController {
  IBOutlet UITableView* table;
  Setting* setting;
}

@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) Setting* setting;

- (void) initWithSetting:(Setting*)s;

@end