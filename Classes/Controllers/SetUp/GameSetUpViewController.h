#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Game.h"
#import "Setting.h"
#import "SettingDelegate.h"
#import "GameViewController.h"
#import "GameModeViewController.h"
#import "GameTournamentViewController.h"
#import "DefendersScoringViewController.h"

@interface GameSetUpViewController : UITableViewController <UITextFieldDelegate>

@property(weak) id<SettingDelegate> delegate;

- (void)initWithGame:(Game *)g mostRecentSettings:(Setting *)recent;

@end
