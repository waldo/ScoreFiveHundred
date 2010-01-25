//
//  TricksWonViewController.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 24/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import "TricksWonViewController.h"


@implementation TricksWonViewController

@synthesize tricksWonSegmentedControl;
@synthesize saveBid;


- (void) dealloc {
  [saveBid dealloc];
  [tricksWonSegmentedControl dealloc];
  
  [super dealloc];
}

- (void) didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.tricksWonSegmentedControl setSelectedSegmentIndex:5];
}

- (NSNumber*) tricksWon {
  return [NSNumber numberWithInt:[[self.tricksWonSegmentedControl titleForSegmentAtIndex:self.tricksWonSegmentedControl.selectedSegmentIndex] intValue]];
}

@end
