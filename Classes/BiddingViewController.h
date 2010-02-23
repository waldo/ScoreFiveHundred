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
  IBOutlet UITableView* bidSelectionTableView;
  IBOutlet CellWrapper* cellWrapper;
  IBOutlet UILabel* nameTeamOne;
  IBOutlet UILabel* nameTeamTwo;
  IBOutlet UILabel* scoreTeamOne;
  IBOutlet UILabel* scoreTeamTwo;  
  
  NSArray* bidTypeHands;
  NSString* team;
}

@property (nonatomic, retain) IBOutlet UITableView* bidSelectionTableView;
@property (nonatomic, retain) IBOutlet CellWrapper* cellWrapper;
@property (nonatomic, retain) UILabel* nameTeamOne;
@property (nonatomic, retain) UILabel* nameTeamTwo;
@property (nonatomic, retain) UILabel* scoreTeamOne;
@property (nonatomic, retain) UILabel* scoreTeamTwo;

@property (nonatomic, retain) NSArray* bidTypeHands;
@property (nonatomic, retain) NSString* team;

- (NSString*) hand;
- (void) setTitleUsingTeamName:(NSString*)teamName;

@end
