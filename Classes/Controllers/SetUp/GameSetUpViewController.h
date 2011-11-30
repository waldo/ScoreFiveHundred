#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Game.h"
#import "Setting.h"
#import "GameViewController.h"
#import "GameModeViewController.h"
#import "GameTournamentViewController.h"

@interface GameSetUpViewController : UIViewController <UITextFieldDelegate>{
  IBOutlet GameViewController* gameController;
  IBOutlet GameModeViewController* gameModeController;
  IBOutlet GameTournamentViewController* gameTournamentController;
  IBOutlet UITableView* table;
  IBOutlet UIBarButtonItem* cancel;  
  IBOutlet UIBarButtonItem* start;  
  Game* game;
  NSMutableOrderedSet* teamNameTextFields;
}

@property (nonatomic, retain) IBOutlet GameViewController* gameController;
@property (nonatomic, retain) IBOutlet GameModeViewController* gameModeController;
@property (nonatomic, retain) IBOutlet GameTournamentViewController* gameTournamentController;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* cancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* start;
@property (nonatomic, retain) Game* game;
@property (nonatomic, retain) NSMutableOrderedSet* teamNameTextFields;


- (IBAction) cancel:(id)sender;
- (IBAction) start:(id)sender;

- (void) initWithGame:(Game*)g mostRecentSettings:(Setting*)recent;

@end