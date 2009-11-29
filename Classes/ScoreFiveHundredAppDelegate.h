//
//  ScoreFiveHundredAppDelegate.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 26/11/2009.
//  Copyright MeltingWaldo 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreFiveHundredAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  
  IBOutlet UINavigationController *navigationController;
  
  // Game list view
  IBOutlet UIViewController *gameListController;
  
  // Game view
  IBOutlet UIViewController *gameController;
  IBOutlet UILabel *teamOneScoreLabel;
  IBOutlet UILabel *teamTwoScoreLabel;
  
  // Round view
  IBOutlet UIViewController *roundController;  
  
  NSMutableArray *bidTypes;
  
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) NSMutableArray *bidTypes;

- (IBAction)newGame;
- (IBAction)teamBid;
- (IBAction)cancelScore;
- (IBAction)saveScore;

@end

