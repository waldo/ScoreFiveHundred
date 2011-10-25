//
//  CellBidType.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 09/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import "CellBidType.h"


@implementation CellBidType

@synthesize symbol;
@synthesize description;
@synthesize points;

- (void)dealloc {
  [symbol release];
  [description release];
  [points release];

  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
