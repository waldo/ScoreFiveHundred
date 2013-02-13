#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Game.h"
#import "GameSetUpViewController.h"
#import "GameViewController.h"
#import "SettingDelegate.h"
#import "RematchDelegate.h"

@interface GameListViewController : UITableViewController <SettingDelegate, RematchDelegate>

@property NSManagedObjectContext *managedObjectContext;
@property NSMutableArray *games;
@property Game *mostRecentGame;

- (void)loadGames;
- (void)fixOldGames;
- (void)fixForVersion_1_2;
- (NSMutableArray *)gamesInProgress;
- (NSMutableArray *)gamesComplete;
- (Game *)gameForIndexPath:(NSIndexPath *)index;
- (id)valueForSection:(NSInteger)section valueInProgress:(id)valueInProgress valueCompleted:(id)valueCompleted;

@end
