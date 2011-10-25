//
//  HighestBiddingTeamViewController.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 2011-10-19.
//  Copyright 2011 MeltingWaldo. All rights reserved.
//

#import "HighestBiddingTeamViewController.h"
#import "ScoreFiveHundredAppDelegate.h"


@implementation HighestBiddingTeamViewController

// MARK: synthesize
@synthesize teamSelectionTableView;
@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize scoreTeamOne;
@synthesize scoreTeamTwo;

@synthesize teams;

- (void)dealloc {
  [teamSelectionTableView release];
  [nameTeamOne release];
  [nameTeamTwo release];
  [scoreTeamOne release];
  [scoreTeamTwo release];  

  [teams release];
  
  [super dealloc];
}

- (NSString*) team {
  return [NSString stringWithString:[self.teams objectAtIndex:[self.teamSelectionTableView indexPathForSelectedRow].row]];
}

// MARK: view loading
- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.teamSelectionTableView reloadData];
}

// MARK: tableview delegate
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.teams count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString *TeamIdentifier = @"TeamSelection";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TeamIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TeamIdentifier] autorelease];
  }

  cell.textLabel.text = [teams objectAtIndex:indexPath.row];

  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  ScoreFiveHundredAppDelegate* app = (ScoreFiveHundredAppDelegate*)[[UIApplication sharedApplication] delegate];

  [app bidForTeamName:[self team]];
}

@end