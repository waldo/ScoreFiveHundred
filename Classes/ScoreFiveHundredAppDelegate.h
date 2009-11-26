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
  
  UINavigationController *navigationController;
  
  UIViewController *gameListController;
  UIViewController *gameController;
  UIViewController *roundController;
  
  UIBarButtonItem *newGameButton;
  UIButton *roundScoreButton;
  UIBarButtonItem *cancelScoreButton;
  UIButton *saveScoreButton;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet UIViewController *gameListController;
@property (nonatomic, retain) IBOutlet UIViewController *gameController;
@property (nonatomic, retain) IBOutlet UIViewController *roundController;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *newGameButton;
@property (nonatomic, retain) IBOutlet UIButton *roundScoreButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelScoreButton;
@property (nonatomic, retain) IBOutlet UIButton *saveScoreButton;

- (IBAction)newGame;
- (IBAction)roundScore;
- (IBAction)cancelScore;
- (IBAction)saveScore;

@end

