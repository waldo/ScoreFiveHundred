//
//  BiddingViewController.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 02/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import "BiddingViewController.h"


@implementation BiddingViewController

// MARK: synthesize
@synthesize bidSelectionTableView;
@synthesize cellWrapper;
@synthesize tricksWonSegmentedControl;

@synthesize bidTypeHands;

- (void)dealloc {
  [bidSelectionTableView release];
  [cellWrapper dealloc];
  [tricksWonSegmentedControl release];
  [bidTypeHands release];
  
  [super dealloc];
}

- (NSNumber*) tricksWon {
  return [NSNumber numberWithInt:[[self.tricksWonSegmentedControl titleForSegmentAtIndex:self.tricksWonSegmentedControl.selectedSegmentIndex] intValue]];
}

- (NSString*) hand {
  return [self.bidTypeHands objectAtIndex:[self.bidSelectionTableView indexPathForSelectedRow].row];
}

// MARK: view loading
- (void) viewDidLoad {
  [super viewDidLoad];

  self.bidTypeHands = [BidType orderedHands];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self.tricksWonSegmentedControl setSelectedSegmentIndex:5];
  [self.bidSelectionTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

// MARK: tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bidTypeHands count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CellBidType";
  
  CellBidType *cellBidType = (CellBidType *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellBidType == nil) {
    [self.cellWrapper loadMyNibFile:CellIdentifier];
    cellBidType = (CellBidType *)self.cellWrapper.cell;
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

@end