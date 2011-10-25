//
//  TricksWonViewController.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 24/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScoreFiveHundredAppDelegate;


@interface TricksWonViewController : UIViewController {
  IBOutlet UITableView* tricksWonTableView;
  IBOutlet UILabel* nameTeamOne;
  IBOutlet UILabel* nameTeamTwo;
  IBOutlet UILabel* scoreTeamOne;
  IBOutlet UILabel* scoreTeamTwo;
  
  NSString* hand;
  NSString* teamName;
  NSString* bidVariation;
  NSArray* regularList;
  NSArray* misereList;
}

@property (nonatomic, retain) IBOutlet UITableView* tricksWonTableView;
@property (nonatomic, retain) UILabel* nameTeamOne;
@property (nonatomic, retain) UILabel* nameTeamTwo;
@property (nonatomic, retain) UILabel* scoreTeamOne;
@property (nonatomic, retain) UILabel* scoreTeamTwo;

@property (nonatomic, retain) NSString* hand;
@property (nonatomic, retain) NSString* teamName;
@property (nonatomic, retain) NSString* bidVariation;
@property (nonatomic, retain) NSArray* regularList;
@property (nonatomic, retain) NSArray* misereList;


- (NSArray*) tricksWonList;
- (void) styleWithHand:(NSString*)bid teamName:(NSString*)team;

@end
