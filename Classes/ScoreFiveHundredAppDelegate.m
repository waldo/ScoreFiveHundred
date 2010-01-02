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
  [self viewGame:nil WithKey:[ScoreFiveHundredAppDelegate uniqueId] AndIsNewGame:YES];
}

- (IBAction) cancelScore {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) saveScore {
  // work out what was clicked
  NSNumber *tricksWon = [self.biddingController tricksWon];
  NSString *hand = [self.biddingController hand];

  [self.gameController updateRoundWithHand:hand AndTricksWon:tricksWon];
  
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) bidForTeamName:(NSString*)teamName {
  self.biddingController.title = [NSString stringWithFormat:@"%@ Bid", teamName];
  [self.navigationController pushViewController:self.biddingController animated:YES];
}

- (void) saveGame:(NSDictionary*)game ForKey:(NSString*)key {
  [self.gameListController saveGame:game ForKey:key];
}

- (void) viewGame:(NSDictionary*)gameToOpen WithKey:(NSString*)key AndIsNewGame:(BOOL)newGame {
  [self.gameController openGame:gameToOpen WithKey:key AndIsNewGame:newGame];
  [self.navigationController pushViewController:self.gameController animated:YES];
}  

- (void) applicationDidFinishLaunching:(UIApplication *)application {

  [self.window addSubview:[self.navigationController view]];
  [self.window makeKeyAndVisible];
}

@end