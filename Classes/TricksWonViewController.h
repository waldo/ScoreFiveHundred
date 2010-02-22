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

  NSString* bidDescription;
  NSString* bidVariation;
  NSArray* regularList;
  NSArray* misereList;
}

@property (nonatomic, retain) IBOutlet UITableView* tricksWonTableView;

@property (nonatomic, retain) NSString* bidDescription;
@property (nonatomic, retain) NSString* bidVariation;
@property (nonatomic, retain) NSArray* regularList;
@property (nonatomic, retain) NSArray* misereList;


- (NSArray*) tricksWonList;

@end
