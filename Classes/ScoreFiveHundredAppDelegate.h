//
//  ScoreFiveHundredAppDelegate.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 26/11/2009.
//  Copyright MeltingWaldo 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "BiddingViewController.h"
#import "CellWrapper.h"
#import "CellGame.h"

@interface ScoreFiveHundredAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  
  IBOutlet UINavigationController *navigationController;
  
  // Game list view
  IBOutlet UIViewController *gameListController;
  IBOutlet CellWrapper *cellWrapper;
  IBOutlet UITableView *gameListTableView;
  
  // Game view
  IBOutlet GameViewController* gameController;
  
  // Bidding view
  IBOutlet BiddingViewController *biddingController;
  
  NSMutableArray* gameKeys;
  NSMutableDictionary* gameList;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet UIViewController *gameListController;
@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;
@property (nonatomic, retain) IBOutlet UITableView *gameListTableView;

@property (nonatomic, retain) IBOutlet GameViewController* gameController;

@property (nonatomic, retain) IBOutlet BiddingViewController *biddingController;

@property (nonatomic, retain) NSMutableArray* gameKeys;
@property (nonatomic, retain) NSMutableDictionary* gameList;

+ (NSString *) uniqueId;

- (IBAction) newGame;
- (IBAction) cancelScore;
- (IBAction) saveScore;

- (void) bidForTeamName:(NSString*)teamName;
- (void) viewGameForKey:(NSString*)key AndIsNewGame:(BOOL)newGame;

@end

