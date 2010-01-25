//
//  ScoreFiveHundredAppDelegate.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 26/11/2009.
//  Copyright MeltingWaldo 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameListViewController.h"
#import "GameViewController.h"
#import "BiddingViewController.h"
#import "TricksWonViewController.h"
#import "CellWrapper.h"
#import "CellGame.h"

@interface ScoreFiveHundredAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  
  IBOutlet UINavigationController *navigationController;
  
  IBOutlet GameListViewController *gameListController;
  IBOutlet GameViewController* gameController;
  IBOutlet BiddingViewController *biddingController;
  IBOutlet TricksWonViewController* tricksWonController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet GameListViewController *gameListController;
@property (nonatomic, retain) IBOutlet GameViewController* gameController;
@property (nonatomic, retain) IBOutlet BiddingViewController *biddingController;
@property (nonatomic, retain) IBOutlet TricksWonViewController* tricksWonController;

+ (NSString *) uniqueId;

- (IBAction) newGame;
- (IBAction) saveScore;

- (void) viewGame:(NSDictionary*)gameToOpen WithKey:(NSString*)key AndIsNewGame:(BOOL)newGame;
- (void) saveGame:(NSDictionary*)game forKey:(NSString*)key;
- (void) rematch:(NSDictionary*)originalGame forKey:(NSString*)originalGameKey;
- (void) bidForTeamName:(NSString*)teamName;
- (void) bidTypeSelected:(NSString*)bidType;

@end