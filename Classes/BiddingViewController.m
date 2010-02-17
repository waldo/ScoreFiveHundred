//
//  BiddingViewController.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 02/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import "BiddingViewController.h"
#import "ScoreFiveHundredAppDelegate.h"


@implementation BiddingViewController

// MARK: synthesize
@synthesize bidSelectionTableView;
@synthesize cellWrapper;

@synthesize bidTypeHands;
@synthesize team;

- (void)dealloc {
  [bidSelectionTableView release];
  [cellWrapper dealloc];
  [bidTypeHands release];
  
  [super dealloc];
}

- (NSString*) hand {
  return [self.bidTypeHands objectAtIndex:[self.bidSelectionTableView indexPathForSelectedRow].row];
}

- (void) setTitleUsingTeamName:(NSString*)teamName {
  self.team = teamName;
  self.title = [NSString stringWithFormat:@"%@ Bid", self.team];
}

// MARK: view loading
- (void) viewDidLoad {
  [super viewDidLoad];

  self.bidTypeHands = [BidType orderedHands];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.bidSelectionTableView reloadData];
}

// MARK: tableview delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bidTypeHands count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  ScoreFiveHundredAppDelegate* app = (ScoreFiveHundredAppDelegate*)[[UIApplication sharedApplication] delegate];

  NSString* bidTypeDescription = [BidType tricksAndDescriptionForHand:[self hand]];
  
  [app bidTypeSelected:bidTypeDescription forTeamName:self.team];
}

@end