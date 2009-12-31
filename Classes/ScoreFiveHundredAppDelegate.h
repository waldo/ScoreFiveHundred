//
//  ScoreFiveHundredAppDelegate.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 26/11/2009.
//  Copyright MeltingWaldo 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "BidType.h"
#import "CellWrapper.h"
#import "CellGame.h"
#import "CellBidType.h"

@interface ScoreFiveHundredAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  
  IBOutlet UINavigationController *navigationController;
  
  // Game list view
  IBOutlet UIViewController *gameListController;
  IBOutlet UITableView *gameListTableView;
  
  // Game view
  IBOutlet GameViewController *gameController;
  
  // Round view
  IBOutlet UIViewController *roundController;
  IBOutlet UITableView *bidSelectionTableView;
  IBOutlet CellWrapper *cellWrapper;
  IBOutlet UISegmentedControl *tricksWonSegmentedControl;
  
  NSArray *bidTypeHands;
  NSNumber *currentBidIsWithTeamSlot;
  NSMutableArray* gameKeys;
  NSMutableDictionary* gameList;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet UIViewController *gameListController;
@property (nonatomic, retain) IBOutlet UITableView *gameListTableView;

@property (nonatomic, retain) IBOutlet GameViewController *gameController;

@property (nonatomic, retain) IBOutlet UIViewController *roundController;
@property (nonatomic, retain) IBOutlet UITableView *bidSelectionTableView;
@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;
@property (nonatomic, retain) IBOutlet UISegmentedControl *tricksWonSegmentedControl;

@property (nonatomic, retain) NSArray *bidTypeHands;
@property (nonatomic, retain) NSNumber *currentBidIsWithTeamSlot;
@property (nonatomic, retain) NSMutableArray* gameKeys;
@property (nonatomic, retain) NSMutableDictionary* gameList;

+ (NSString *) uniqueId;

- (IBAction) newGame;
- (IBAction) teamOneBid;
- (IBAction) teamTwoBid;
- (IBAction) cancelScore;
- (IBAction) saveScore;

- (void) viewGameForKey:(NSString*)key AndIsNewGame:(BOOL)newGame;
- (void) teamBid:(int)teamSlot;

@end

