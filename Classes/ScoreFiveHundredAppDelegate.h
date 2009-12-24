//
//  ScoreFiveHundredAppDelegate.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 26/11/2009.
//  Copyright MeltingWaldo 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BidType.h"
#import "CellWrapper.h"
#import "CellBidType.h"
#import "GameViewController.h"

@interface ScoreFiveHundredAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  
  IBOutlet UINavigationController *navigationController;
  
  // Game list view
  IBOutlet UIViewController *gameListController;
  
  // Game view
  IBOutlet GameViewController *gameController;
  
  // Round view
  IBOutlet UIViewController *roundController;
  IBOutlet UITableView *bidSelectionTableView;
  CellWrapper *cellWrapper;
  IBOutlet UISegmentedControl *tricksWonSegmentedControl;
  
  NSArray *bidTypeHands;
  NSNumber *currentBidIsWithTeamSlot;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITableView *bidSelectionTableView;
@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;
@property (nonatomic, retain) IBOutlet UISegmentedControl *tricksWonSegmentedControl;

@property (nonatomic, retain) NSArray *bidTypeHands;
@property (nonatomic, retain) NSNumber *currentBidIsWithTeamSlot;


- (IBAction) newGame;
- (IBAction) teamOneBid;
- (IBAction) teamTwoBid;
- (IBAction) cancelScore;
- (IBAction) saveScore;

- (void) teamBid:(int)teamSlot;

@end

