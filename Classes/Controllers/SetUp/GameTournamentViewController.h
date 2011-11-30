#import <UIKit/UIKit.h>
#import "Setting.h"

@interface GameTournamentViewController : UIViewController {
  IBOutlet UITableView* table;
  Setting* setting;
  NSOrderedSet* tournamentOptions;
}

@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) Setting* setting;
@property (nonatomic, retain) NSOrderedSet* tournamentOptions;

- (void) initWithSetting:(Setting*)s;

@end
