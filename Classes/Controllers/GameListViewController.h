#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Game.h"
#import "GameSetUpViewController.h"
#import "GameViewController.h"
#import "SettingDelegate.h"
#import "RematchDelegate.h"

@interface GameListViewController : UITableViewController <SettingDelegate, RematchDelegate>

@end
