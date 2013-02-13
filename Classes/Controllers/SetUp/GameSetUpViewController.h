#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Game.h"
#import "Setting.h"
#import "GameViewController.h"
#import "GameModeViewController.h"
#import "GameTournamentViewController.h"
#import "SettingDelegate.h"

@interface GameSetUpViewController : UITableViewController <UITextFieldDelegate>

@property Game *game;
@property IBOutletCollection(UITextField) NSArray *teamFields;
@property IBOutlet UISwitch *firstToCross;
@property IBOutlet UISwitch *nonBidderScoresTen;
@property IBOutlet UISwitch *noOneBid;
@property(weak) id<SettingDelegate> delegate;

- (void)initWithGame:(Game *)g mostRecentSettings:(Setting *)recent;
- (void)reloadElements;
- (IBAction)start:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)firstToCrossChanged:(id)sender;
- (IBAction)nonBidderScoresTenChanged:(id)sender;
- (IBAction)noOneBidChanged:(id)sender;

@end
