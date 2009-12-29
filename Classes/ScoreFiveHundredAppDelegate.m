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

@synthesize bidSelectionTableView;
@synthesize cellWrapper;
@synthesize tricksWonSegmentedControl;
@synthesize currentBidIsWithTeamSlot;

@synthesize bidTypeHands;

- (IBAction) newGame {
  [gameController openGameForKey:@"dummy_game_key" AndIsNewGame:YES];
  [navigationController pushViewController:gameController animated:YES];
}

- (IBAction) teamOneBid {
  [self teamBid:0];
}

- (IBAction) teamTwoBid {
  [self teamBid:1];
}

- (void) teamBid:(int)teamSlot {
  self.currentBidIsWithTeamSlot = [NSNumber numberWithInt:teamSlot];
  roundController.title = [NSString stringWithFormat:@"%@ Bid", [gameController teamNameForSlot:self.currentBidIsWithTeamSlot]];
  [self.bidSelectionTableView deselectRowAtIndexPath:[self.bidSelectionTableView indexPathForSelectedRow] animated:NO];
  [self.tricksWonSegmentedControl setSelectedSegmentIndex:5];
  [navigationController pushViewController:roundController animated:YES];
}

- (IBAction) cancelScore {
  [navigationController popViewControllerAnimated:YES];
}

- (IBAction) saveScore {
  // work out what was clicked
  NSNumber *tricksWon = [NSNumber numberWithLong:tricksWonSegmentedControl.selectedSegmentIndex];
  NSString *hand = [self.bidTypeHands objectAtIndex:[[self.bidSelectionTableView indexPathForSelectedRow] row]];

  // update round
//  gameController
  [gameController updateRound:(BOOL)NO ForTeamSlot:self.currentBidIsWithTeamSlot ForHand:hand AndTricksWon:tricksWon];
  
  
  // scoring
  NSNumber *biddersChange = [BidType biddersPointsForHand:hand AndBiddersTricksWon:tricksWon];
  NSNumber *nonBiddersChange = [BidType nonBiddersPointsForHand:hand AndBiddersTricksWon:tricksWon];
    
  NSLog(@"bidders points: %@", biddersChange);
  NSLog(@"non-bidders points: %@", nonBiddersChange);  
  
  [navigationController popViewControllerAnimated:YES];
}

- (void) applicationDidFinishLaunching:(UIApplication *)application {
  self.bidTypeHands = [BidType orderedHands];

  [window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
}

//
// UITableView delegate methods
//
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.bidTypeHands count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CellBidType";
  
  CellBidType *cellBidType = (CellBidType *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellBidType == nil) {
    [cellWrapper loadMyNibFile:CellIdentifier];
    cellBidType = (CellBidType *)cellWrapper.cell;
  }
  
  NSString *key = [self.bidTypeHands objectAtIndex:indexPath.row];
  
  cellBidType.symbolLabel.text = [BidType tricksAndSymbolForHand:key];

  if ([[BidType suitColourForHand:key] isEqual:@"red" ]) {
    cellBidType.symbolLabel.textColor = [UIColor redColor];
    cellBidType.symbolLabel.highlightedTextColor = [UIColor redColor];
  }
  else if ([[BidType suitColourForHand:key] isEqual:@"black" ]) {
    cellBidType.symbolLabel.textColor = [UIColor blackColor];
    cellBidType.symbolLabel.highlightedTextColor = [UIColor blackColor];
  }
  
  cellBidType.descriptionLabel.text = [BidType descriptionForHand:key];
  cellBidType.pointsLabel.text = [BidType pointsStringForHand:key];

  return cellBidType;
}

- (void) dealloc {
  [window release];
  [navigationController release];
  [gameListController release];
  [gameController release];
  [roundController release];
  [bidSelectionTableView release];
  [cellWrapper release];
  [tricksWonSegmentedControl release];
  [bidTypeHands release];

  [super dealloc];
}
@end
