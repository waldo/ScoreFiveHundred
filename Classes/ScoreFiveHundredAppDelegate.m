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
@synthesize cellWrapper;

@synthesize bidSelectionTableView;
@synthesize tricksWonSegmentedControl;

@synthesize bidTypeKeys;

- (IBAction)newGame {
  if ([[navigationController viewControllers] containsObject:gameController]) {
    [navigationController popToViewController:gameController animated:YES];
  }
  else {
    [navigationController pushViewController:gameController animated:YES];
  }
}

- (IBAction)teamBid {
  [navigationController pushViewController:roundController animated:YES];
}

- (IBAction)cancelScore {
  [navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveScore {
  // assumes case 815 protects this function until tricks won and bid are both selected
  // work out what was clicked
  NSNumber *tricksWon = [NSNumber numberWithLong:tricksWonSegmentedControl.selectedSegmentIndex];
  NSString *key = [self.bidTypeKeys objectAtIndex:[[self.bidSelectionTableView indexPathForSelectedRow] row]];

  // scoring
  NSNumber *biddersChange = [BidType biddersPointsForKey:key AndBiddersTricksWon:tricksWon];
  NSNumber *nonBiddersChange = [BidType nonBiddersPointsForKey:key AndBiddersTricksWon:tricksWon];
    
  // work out team score + update label (+ update round?)
  NSLog(@"bidders points: %@", biddersChange);
  NSLog(@"non-bidders points: %@", nonBiddersChange);
  
  [navigationController popViewControllerAnimated:YES];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  self.bidTypeKeys = [BidType orderedKeys];

  NSLog(@"%@", self.bidTypeKeys);

  [window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
}

//
// UITableView delegate methods
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.bidTypeKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CellBidType";
  
  CellBidType *cellBidType = (CellBidType *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellBidType == nil) {
    [cellWrapper loadMyNibFile:CellIdentifier];
    cellBidType = (CellBidType *)cellWrapper.cell;
  }
  
  NSString *key = [self.bidTypeKeys objectAtIndex:indexPath.row];
  
  cellBidType.symbolLabel.text = [BidType tricksAndSymbolForKey:key];

  if ([[BidType suitColourForKey:key] isEqual:@"red" ]) {
    cellBidType.symbolLabel.textColor = [UIColor redColor];
    cellBidType.symbolLabel.highlightedTextColor = [UIColor redColor];
  }
  else if ([[BidType suitColourForKey:key] isEqual:@"black" ]) {
    cellBidType.symbolLabel.textColor = [UIColor blackColor];
    cellBidType.symbolLabel.highlightedTextColor = [UIColor blackColor];
  }
  
  cellBidType.descriptionLabel.text = [BidType descriptionForKey:key];
  cellBidType.pointsLabel.text = [BidType pointsStringForKey:key];

  return cellBidType;
}

- (void)dealloc {
  //HACK dealloc all other instance variables?
  [cellWrapper release];
  [navigationController release];
  [gameListController release];
  [gameController release];
  [teamOneScoreLabel release];
  [teamTwoScoreLabel release];
  [roundController release];
  [bidTypeKeys release];
  [window release];
  [super dealloc];
}
@end
