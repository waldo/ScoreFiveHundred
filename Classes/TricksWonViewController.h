//
//  TricksWonViewController.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 24/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TricksWonViewController : UIViewController {
  IBOutlet UIBarButtonItem* saveBid;
  IBOutlet UISegmentedControl* tricksWonSegmentedControl;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem* saveBid;
@property (nonatomic, retain) IBOutlet UISegmentedControl* tricksWonSegmentedControl;

- (NSNumber*) tricksWon;

@end
