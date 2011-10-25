//
//  CellBidType.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 09/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CellBidType : UITableViewCell {
  UILabel* symbol;
  UILabel* description;
  UILabel* points;
}

@property (nonatomic, retain) IBOutlet UILabel* symbol;
@property (nonatomic, retain) IBOutlet UILabel* description;
@property (nonatomic, retain) IBOutlet UILabel* points;

@end
