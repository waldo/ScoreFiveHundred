//
//  CellBidType.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 09/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CellBidType : UITableViewCell {
  UILabel *symbolLabel;
  UILabel *descriptionLabel;
  UILabel *pointsLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *symbolLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointsLabel;

@end
