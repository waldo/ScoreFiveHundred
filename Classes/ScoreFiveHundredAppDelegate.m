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
  [tricksWonController release];
  
  [super dealloc];
}

- (void) applicationDidFinishLaunching:(UIApplication*)application {
  
  [self.window addSubview:[self.navigationController view]];
  [self.window makeKeyAndVisible];
}

+ (NSString*) uniqueId {
  CFUUIDRef uniqueId = CFUUIDCreate(NULL);
  NSString* sUniqueId = (NSString*)CFUUIDCreateString(NULL, uniqueId); // convert to string
  CFRelease(uniqueId);
  
  return [sUniqueId autorelease];
}

- (IBAction) newGame {
  [self.gameListController setEditing:NO animated:NO];
  [self viewGame:nil WithKey:[ScoreFiveHundredAppDelegate uniqueId] AndIsNewGame:YES];
}

- (void) saveGame:(NSDictionary*)game forKey:(NSString*)key {
  [self.gameListController saveGame:game forKey:key];
}

- (void) rematch:(NSDictionary*)originalGame forKey:(NSString*)originalGameKey {
  // because we are pushing and popping the same view controller viewDisappear won't be called - thus we need to save first
  [self.gameListController saveGame:originalGame forKey:originalGameKey];
  [self.navigationController popViewControllerAnimated:NO];
  [self.gameController rematchOfGame:originalGame newKey:[ScoreFiveHundredAppDelegate uniqueId]];
  [self.navigationController pushViewController:self.gameController animated:YES];
}

- (void) viewGame:(NSDictionary*)gameToOpen WithKey:(NSString*)key AndIsNewGame:(BOOL)newGame {
  [self.gameController openGame:gameToOpen key:key isNewGame:newGame];
  [self.navigationController pushViewController:self.gameController animated:YES];
}

- (void) bidForTeamName:(NSString*)teamName {
  [self.biddingController setTitleUsingTeamName:teamName];

  [self.navigationController pushViewController:self.biddingController animated:YES];

  self.biddingController.nameTeamOne.text = self.gameController.curNameTeamOne;
  self.biddingController.nameTeamTwo.text = self.gameController.curNameTeamTwo;
  self.biddingController.scoreTeamOne.text = [NSString stringWithFormat:@"%i pts", [self.gameController scoreForSlot:0]];
  self.biddingController.scoreTeamTwo.text = [NSString stringWithFormat:@"%i pts", [self.gameController scoreForSlot:1]];
}

- (void) bidSelected:(NSString*)hand forTeamName:(NSString*)teamName {
  [self.tricksWonController styleWithHand:hand teamName:teamName];
  
  [self.navigationController pushViewController:self.tricksWonController animated:YES];

  self.tricksWonController.nameTeamOne.text = self.gameController.curNameTeamOne;
  self.tricksWonController.nameTeamTwo.text = self.gameController.curNameTeamTwo;
  self.tricksWonController.scoreTeamOne.text = [NSString stringWithFormat:@"%i pts", [self.gameController scoreForSlot:0]];
  self.tricksWonController.scoreTeamTwo.text = [NSString stringWithFormat:@"%i pts", [self.gameController scoreForSlot:1]];  
}

- (void) saveScoreWithTricksWon:(NSInteger)tricksWon {
  NSNumber* tricks = [NSNumber numberWithInt:tricksWon];
  NSString* hand = [self.biddingController hand];
  
  [self.gameController updateRoundWithHand:hand tricksWon:tricks];
  
  [self.navigationController popViewControllerAnimated:NO];
  [self.navigationController popViewControllerAnimated:YES];
}


@end