#import <UIKit/UIKit.h>
#import "ScoreMiniViewController.h"
#import "Game.h"
#import "Round.h"
@class GameViewController;

@interface TricksWonViewController : UIViewController {
  IBOutlet GameViewController* gameController;
  IBOutlet ScoreMiniViewController* scoreController;
  IBOutlet UITableView* tricksWonTableView;

  Game* game;
  Round* round;
  Team* team;
  NSString* bidVariation;
  NSArray* regularList;
  NSArray* misereList;
}

@property (nonatomic, retain) IBOutlet GameViewController* gameController;
@property (nonatomic, retain) IBOutlet ScoreMiniViewController* scoreController;
@property (nonatomic, retain) IBOutlet UITableView* tricksWonTableView;

@property (nonatomic, retain) Game* game;
@property (nonatomic, retain) Round* round;
@property (nonatomic, retain) Team* team;
@property (nonatomic, retain) NSString* bidVariation;
@property (nonatomic, retain) NSArray* regularList;
@property (nonatomic, retain) NSArray* misereList;


- (NSArray*) tricksWonList;
- (void) initWithGame:(Game*)g round:(Round*)r andTeam:(Team*)t;

@end
