//
//  ScoreFiveHundredAppDelegate.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 26/11/2009.
//  Copyright MeltingWaldo 2009. All rights reserved.
//

#import "ScoreFiveHundredAppDelegate.h"

@implementation ScoreFiveHundredAppDelegate

@synthesize window;

@synthesize navigationController;

@synthesize gameListController;
@synthesize gameController;
@synthesize roundController;

@synthesize newGameButton;
@synthesize roundScoreButton;
@synthesize cancelScoreButton;
@synthesize saveScoreButton;

- (IBAction)newGame {
  [navigationController pushViewController:gameController animated:YES];
}

- (IBAction)roundScore {
  [navigationController pushViewController:roundController animated:YES];
}

- (IBAction)cancelScore {
  [navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveScore {
  [navigationController popViewControllerAnimated:YES];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  [window addSubview:[navigationController view]];
  
  [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}
@end
