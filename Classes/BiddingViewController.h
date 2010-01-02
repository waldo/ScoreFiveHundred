//
//  BiddingViewController.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 02/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BidType.h"
#import "CellWrapper.h"
#import "CellBidType.h"

@interface BiddingViewController : UIViewController {
  IBOutlet UITableView *bidSelectionTableView;
  IBOutlet CellWrapper *cellWrapper;
  IBOutlet UISegmentedControl *tricksWonSegmentedControl;
  
  NSArray *bidTypeHands;
}

@property (nonatomic, retain) IBOutlet UITableView *bidSelectionTableView;
@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;
@property (nonatomic, retain) IBOutlet UISegmentedControl *tricksWonSegmentedControl;

@property (nonatomic, retain) NSArray *bidTypeHands;


- (NSNumber*) tricksWon;
- (NSString*) hand;

@end
