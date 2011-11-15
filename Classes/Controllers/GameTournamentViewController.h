#import <UIKit/UIKit.h>
#import "Setting.h"

@interface GameTournamentViewController : UIViewController {
  IBOutlet UITableView* table;
  Setting* setting;
}

@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) Setting* setting;

- (void) initWithSetting:(Setting*)s;

@end
