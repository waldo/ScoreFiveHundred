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

@interface ScoreFiveHundredAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  CellWrapper *cellWrapper;
  
  IBOutlet UINavigationController *navigationController;
  
  // Game list view
  IBOutlet UIViewController *gameListController;
  
  // Game view
  IBOutlet UIViewController *gameController;
  IBOutlet UILabel *teamOneScoreLabel;
  IBOutlet UILabel *teamTwoScoreLabel;
  
  // Round view
  IBOutlet UIViewController *roundController;  
  
  NSArray *bidTypeKeys;
  
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;

@property (nonatomic, retain) NSArray *bidTypeKeys;

- (IBAction)newGame;
- (IBAction)teamBid;
- (IBAction)cancelScore;
- (IBAction)saveScore;

@end

