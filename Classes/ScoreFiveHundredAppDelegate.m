//
//  ScoreFiveHundredAppDelegate.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 26/11/2009.
//  Copyright MeltingWaldo 2009. All rights reserved.
//

#import "ScoreFiveHundredAppDelegate.h"

@implementation ScoreFiveHundredAppDelegate

// MARK: synthesize
@synthesize window;

@synthesize navigationController;

@synthesize gameListController;
@synthesize gameController;
@synthesize biddingController;
@synthesize tricksWonController;


- (void) dealloc {
  [window release];
  [navigationController release];
  [gameListController release];
  [gameController release];
  [biddingController release];
  
  [super dealloc];
}

+ (NSString *) uniqueId {
  CFUUIDRef uniqueId = CFUUIDCreate(NULL);
  NSString *sUniqueId = (NSString *)CFUUIDCreateString(NULL, uniqueId); // convert to string
  CFRelease(uniqueId);
  
  return [sUniqueId autorelease];
}

- (IBAction) newGame {
  [self.gameListController setEditing:NO animated:NO];
  [self viewGame:nil WithKey:[ScoreFiveHundredAppDelegate uniqueId] AndIsNewGame:YES];
}

- (IBAction) saveScore {
  // work out what was clicked
  NSNumber *tricksWon = [self.tricksWonController tricksWon];
  NSString *hand = [self.biddingController hand];

  [self.gameController updateRoundWithHand:hand AndTricksWon:tricksWon];
  
  [self.navigationController popViewControllerAnimated:NO];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) saveGame:(NSDictionary*)game forKey:(NSString*)key {
  [self.gameListController saveGame:game forKey:key];
}

- (void) rematch:(NSDictionary*)originalGame forKey:(NSString*)originalGameKey {
  // because we are pushing and popping the same view controller viewDisappear won't be called - thus we need to save first
  [self.gameListController saveGame:originalGame forKey:originalGameKey];
  [self.navigationController popViewControllerAnimated:NO];
  [self.gameController rematchOfGame:originalGame withNewKey:[ScoreFiveHundredAppDelegate uniqueId]];
  [self.navigationController pushViewController:self.gameController animated:YES];
}

- (void) viewGame:(NSDictionary*)gameToOpen WithKey:(NSString*)key AndIsNewGame:(BOOL)newGame {
  [self.gameController openGame:gameToOpen WithKey:key AndIsNewGame:newGame];
  [self.navigationController pushViewController:self.gameController animated:YES];
}

- (void) bidForTeamName:(NSString*)teamName {
  self.biddingController.title = [NSString stringWithFormat:@"%@ Bid", teamName];
  [self.navigationController pushViewController:self.biddingController animated:YES];
}

- (void) bidTypeSelected:(NSString*)bidType {
  self.tricksWonController.title = bidType;
  [self.navigationController pushViewController:self.tricksWonController animated:YES];
}

- (void) applicationDidFinishLaunching:(UIApplication *)application {

  [self.window addSubview:[self.navigationController view]];
  [self.window makeKeyAndVisible];
}

@end