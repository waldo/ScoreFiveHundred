//
//  HighestBiddingTeamViewController.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 2011-10-19.
//  Copyright 2011 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScoreFiveHundredAppDelegate;

@interface HighestBiddingTeamViewController : UIViewController {
  IBOutlet UITableView* teamSelectionTableView;
  IBOutlet UILabel* nameTeamOne;
  IBOutlet UILabel* nameTeamTwo;
  IBOutlet UILabel* scoreTeamOne;
  IBOutlet UILabel* scoreTeamTwo;  
  
  NSArray* teams;
}

@property (nonatomic, retain) IBOutlet UITableView* teamSelectionTableView;
@property (nonatomic, retain) UILabel* nameTeamOne;
@property (nonatomic, retain) UILabel* nameTeamTwo;
@property (nonatomic, retain) UILabel* scoreTeamOne;
@property (nonatomic, retain) UILabel* scoreTeamTwo;

@property (nonatomic, retain) NSArray* teams;

- (NSString*) team;

@end
