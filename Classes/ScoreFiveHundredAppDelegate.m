//
//  ScoreFiveHundredAppDelegate.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 26/11/2009.
//  Copyright MeltingWaldo 2009. All rights reserved.
//

#import "ScoreFiveHundredAppDelegate.h"
#import "BidType.h"

@implementation ScoreFiveHundredAppDelegate

@synthesize window;

@synthesize bidTypes;

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
  [navigationController popViewControllerAnimated:YES];
  
  // work out what was clicked
  // work out team score + update label (+ update round?)
    // if normal
     // if tricksWon >= bid.numberOfTricks
          // team 1 gets bid.Points
     // else
          // team 1 gets -bid.points
     // team 2 gets (10 - tricksWon) x 10
    // if misere
     // if tricksWon = 0
          // team 1 gets bid.Points
     // else
          // team 1 gets -bid.Points
     // team 2 gets 0
  
      // NOTE: write some tests!
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  NSArray *ordered = [BidType orderedKeys];
//  NSDictionary *allTypes = [BidType allTypes];
  
  self.bidTypes = [[NSMutableArray alloc] init];
  
  for (NSString *key in ordered) {
    [self.bidTypes addObject:[NSString stringWithFormat:[BidType anyFormattedString:key]]];
  }
  
  NSLog(@"%@", self.bidTypes);
  
  [self.bidTypes release];

  [window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
}

//
// UITableView delegate methods
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.bidTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"BidTypeCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
  }
  
  cell.textLabel.text = [self.bidTypes objectAtIndex:indexPath.row];
  
  return cell;  
}

- (void)dealloc {
  [window release];
  //HACK dealloc all other instance variables?
  [super dealloc];
}
@end
