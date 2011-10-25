//
//  CellGame.m
//
//  Created by Ben Walsham on 29/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import "CellGame.h"

@implementation CellGame

@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize pointsTeamOne;
@synthesize pointsTeamTwo;
@synthesize symbolResultTeamOne;
@synthesize symbolResultTeamTwo;
@synthesize dateLastPlayed;

- (void) dealloc {
  [nameTeamOne release];
  [nameTeamTwo release];
  [pointsTeamOne release];
  [pointsTeamTwo release];
  [symbolResultTeamOne release];
  [symbolResultTeamTwo release];
  [dateLastPlayed release];

  [super dealloc];
}

//
// UITableViewCell functions
//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
