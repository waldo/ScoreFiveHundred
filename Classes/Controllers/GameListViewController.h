#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Game.h"
@class Setting;
#import "CellWrapper.h"
#import "CellGame.h"
#import "GameSetUpViewController.h"
#import "GameViewController.h"


@interface GameListViewController : UIViewController {
  IBOutlet CellWrapper* cellWrapper;
  IBOutlet UITableView* gameListTableView;
  IBOutlet UIBarButtonItem* addButton;
  IBOutlet GameSetUpViewController* setUpController;
  IBOutlet GameViewController* gameController;

  NSManagedObjectContext* managedObjectContext;
  NSMutableArray* gamesInProgress;
  NSMutableArray* gamesComplete;
  Game* mostRecentGame;
}


@property (nonatomic, retain) IBOutlet CellWrapper* cellWrapper;
@property (nonatomic, retain) IBOutlet UITableView* gameListTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* addButton;
@property (nonatomic, retain) IBOutlet GameSetUpViewController* setUpController;
@property (nonatomic, retain) IBOutlet GameViewController* gameController;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray* gamesInProgress;
@property (nonatomic, retain) NSMutableArray* gamesComplete;
@property (nonatomic, retain) Game* mostRecentGame;

- (IBAction) newGame:(id)sender;

- (void) loadGames;
- (id) valueForSection:(NSInteger)section valueInProgress:(id)valueInProgress valueCompleted:(id)valueCompleted;
- (Game*) gameForIndexPath:(NSIndexPath*)index;

@end
