//
//  BiddingViewController.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 02/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScoreFiveHundredAppDelegate;
#import "BidType.h"
#import "CellWrapper.h"
#import "CellBidType.h"

@interface BiddingViewController : UIViewController {
  IBOutlet UITableView *bidSelectionTableView;
  IBOutlet CellWrapper *cellWrapper;
  
  NSArray *bidTypeHands;
}

@property (nonatomic, retain) IBOutlet UITableView *bidSelectionTableView;
@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;

@property (nonatomic, retain) NSArray *bidTypeHands;


- (NSString*) hand;

@end
