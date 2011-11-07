#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Game.h"
#import "GameViewController.h"

@interface GameSetUpViewController : UIViewController <UITextFieldDelegate>{
  IBOutlet GameViewController* gameController;
  IBOutlet UITableView* table;
  IBOutlet UIBarButtonItem* startButton;  
  Game* game;
  NSMutableOrderedSet* teamNameTextFields;
}

@property (nonatomic, retain) IBOutlet GameViewController* gameController;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* startButton;
@property (nonatomic, retain) Game* game;
@property (nonatomic, retain) NSMutableOrderedSet* teamNameTextFields;


- (IBAction) start:(id)sender;

- (void) initWithGame:(Game*)g;

@end