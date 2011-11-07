#import <UIKit/UIKit.h>
@class GameViewController;
#import "Game.h"
#import "Round.h"

@interface TricksWonViewController : UIViewController {
  IBOutlet GameViewController* gameController;
  IBOutlet UITableView* tricksWonTableView;
  IBOutlet UILabel* nameTeamOne;
  IBOutlet UILabel* nameTeamTwo;
  IBOutlet UILabel* scoreTeamOne;
  IBOutlet UILabel* scoreTeamTwo;

  Game* game;
  Team* biddingTeam;
  NSString* hand;
  NSString* bidVariation;
  NSArray* regularList;
  NSArray* misereList;
}

@property (nonatomic, retain) IBOutlet GameViewController* gameController;
@property (nonatomic, retain) IBOutlet UITableView* tricksWonTableView;
@property (nonatomic, retain) UILabel* nameTeamOne;
@property (nonatomic, retain) UILabel* nameTeamTwo;
@property (nonatomic, retain) UILabel* scoreTeamOne;
@property (nonatomic, retain) UILabel* scoreTeamTwo;

@property (nonatomic, retain) Game* game;
@property (nonatomic, retain) Team* biddingTeam;
@property (nonatomic, retain) NSString* hand;
@property (nonatomic, retain) NSString* bidVariation;
@property (nonatomic, retain) NSArray* regularList;
@property (nonatomic, retain) NSArray* misereList;


- (NSArray*) tricksWonList;
- (void) initWithGame:(Game*)g team:(Team*)t andBid:(NSString*)hand;

@end
