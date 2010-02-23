//
//  TricksWonViewController.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 24/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import "TricksWonViewController.h"
#import "ScoreFiveHundredAppDelegate.h"


@implementation TricksWonViewController

static NSString* ssBidVariationRegular = @"regular";
static int siMaximumTricks = 10;

// MARK: synthesize
@synthesize tricksWonTableView;
@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize scoreTeamOne;
@synthesize scoreTeamTwo;

@synthesize hand;
@synthesize teamName;
@synthesize bidVariation;
@synthesize regularList;
@synthesize misereList;


- (void) dealloc {
  [tricksWonTableView release];
  [nameTeamOne release];
  [nameTeamTwo release];
  [scoreTeamOne release];
  [scoreTeamTwo release];

  [hand release];
  [teamName release];
  [bidVariation release];
  [regularList release];
  [misereList release];
  
  [super dealloc];
}

- (void) didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void) viewDidLoad {
  self.regularList = [NSArray arrayWithObjects:
                      @"10 tricks",
                      @"9 tricks",
                      @"8 tricks",
                      @"7 tricks",
                      @"6 tricks",
                      @"5 tricks",
                      @"4 tricks",
                      @"3 tricks",
                      @"2 tricks",
                      @"1 trick",
                      @"0 tricks", 
                      nil
                      ];

  self.misereList = [NSArray arrayWithObjects:
                     @"Won by losing every trick",
                     @"Got one or more tricks",
                     nil
                     ];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  NSLog(@"self.bidVariation: %@", self.bidVariation);
  NSLog(@"[self tricksWonList: %@", [self tricksWonList]);
  
  [self.tricksWonTableView reloadData];
}

- (NSArray*) tricksWonList {
  NSArray* list = nil;
  
  if (self.bidVariation == ssBidVariationRegular) {
    list = self.regularList;
  }
  else {
    list = self.misereList;
  }

  return list;
}

- (void) styleWithHand:(NSString*)bid teamName:(NSString*)team {
  self.hand = bid;
  self.teamName = team;
  self.bidVariation = [BidType variation:self.hand];

  self.title = [BidType tricksAndDescriptionForHand:hand];
}
  
// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
	return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  return [NSString stringWithFormat:@"%@ bid %@. How many did they actually win?", teamName, [BidType tricksAndDescriptionForHand:hand]];
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self tricksWonList] count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellIdentifier = @"CellTricksWon";
  
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
  }

  int score = 0;
  int tricksWon = 0;
  
  if (self.bidVariation == ssBidVariationRegular) {
    tricksWon = (siMaximumTricks - indexPath.row);
  }
  else {
    tricksWon = indexPath.row;
  }

  score = [[BidType biddersPointsForHand:hand AndBiddersTricksWon:[NSNumber numberWithInt:tricksWon]] intValue];
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = [[self tricksWonList] objectAtIndex:indexPath.row];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%i pts", score];
  [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
  if (score > 0) {
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:53.0/255.0 green:102.0/255.0 blue:201.0/255.0 alpha:1.0]];
  }
  else {
    [cell.detailTextLabel setTextColor:[UIColor redColor]];
  }
  
  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  int tricksWon = 0;

  ScoreFiveHundredAppDelegate* app = (ScoreFiveHundredAppDelegate*)[[UIApplication sharedApplication] delegate];
  
  if (self.bidVariation == @"regular") {
    tricksWon = 10 - indexPath.row;
  }
  else {
    tricksWon = indexPath.row; 
  }

  [app saveScoreWithTricksWon:tricksWon];
}

@end
