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

// MARK: synthesize
@synthesize tricksWonTableView;

@synthesize bidDescription;
@synthesize bidVariation;
@synthesize regularList;
@synthesize misereList;


- (void) dealloc {
  [tricksWonTableView dealloc];

  [bidDescription dealloc];
  [bidVariation dealloc];
  [regularList dealloc];
  [misereList dealloc];
  
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
                     @"Successfully lost every trick",
                     @"Won at least one trick",
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
  
  if (self.bidVariation == @"regular") {
    list = self.regularList;
  }
  else {
    list = self.misereList;
  }

  return list;
}  
  
// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
	return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  return self.bidDescription;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self tricksWonList] count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellIdentifier = @"CellTricksWon";
  
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
  }

  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = [[self tricksWonList] objectAtIndex:indexPath.row];

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
