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
@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize scoreTeamOne;
@synthesize scoreTeamTwo;

@synthesize bidTypeHands;
@synthesize team;

- (void)dealloc {
  [bidSelectionTableView release];
  [cellWrapper release];
  [nameTeamOne release];
  [nameTeamTwo release];
  [scoreTeamOne release];
  [scoreTeamTwo release];  

  [bidTypeHands release];
  [team release];
  
  [super dealloc];
}

- (NSString*) hand {
  return [self.bidTypeHands objectAtIndex:[self.bidSelectionTableView indexPathForSelectedRow].row];
}

- (void) setTitleUsingTeamName:(NSString*)teamName {
  NSString* possessive = nil;
  self.team = teamName;
  
  if ([[teamName substringFromIndex:[teamName length]-1] isEqual:@"s"]) {
    possessive = [NSString stringWithFormat:@"%@'", teamName];
  }
  else {
    possessive = [NSString stringWithFormat:@"%@'s", teamName];
  }
  
  self.title = [NSString stringWithFormat:@"%@ Bid", possessive];
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
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bidTypeHands count];
}


- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellIdentifier = @"CellBidType";
  
  CellBidType* cellBidType = (CellBidType*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellBidType == nil) {
    [self.cellWrapper loadMyNibFile:CellIdentifier];
    cellBidType = (CellBidType*)self.cellWrapper.cell;
  }
  
  NSString* key = [self.bidTypeHands objectAtIndex:indexPath.row];
  
  cellBidType.symbol.text = [BidType tricksAndSymbolForHand:key];
  
  if ([[BidType suitColourForHand:key] isEqual:@"red" ]) {
    cellBidType.symbol.textColor = [UIColor redColor];
    cellBidType.symbol.highlightedTextColor = [UIColor redColor];
  }
  else if ([[BidType suitColourForHand:key] isEqual:@"black" ]) {
    cellBidType.symbol.textColor = [UIColor blackColor];
    cellBidType.symbol.highlightedTextColor = [UIColor blackColor];
  }
  
  cellBidType.description.text = [BidType descriptionForHand:key];
  cellBidType.points.text = [BidType pointsStringForHand:key];
  
  return cellBidType;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  ScoreFiveHundredAppDelegate* app = (ScoreFiveHundredAppDelegate*)[[UIApplication sharedApplication] delegate];

  [app bidSelected:[self hand] forTeamName:self.team];
}

@end