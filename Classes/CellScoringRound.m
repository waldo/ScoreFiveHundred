//
//  CellScoringRound.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 23/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import "CellScoringRound.h"


@implementation CellScoringRound

static NSString* ssSymbolForBidWon  = @"✔";
static NSString* ssSymbolForBidLost = @"✘";
static int siSlotTeamOne            = 0;
static int siSlotTeamTwo            = 1;

@synthesize bidAttemptedTeamOne;
@synthesize bidAttemptedTeamTwo;
@synthesize pointsTeamOne;
@synthesize pointsTeamTwo;
@synthesize symbolBidResultTeamOne;
@synthesize symbolBidResultTeamTwo;
@synthesize scoreSummaryTeamOne;
@synthesize scoreSummaryTeamTwo;

- (void) dealloc {
  [bidAttemptedTeamOne release];
  [bidAttemptedTeamTwo release];
  [pointsTeamOne release];
  [pointsTeamTwo release];
  [symbolBidResultTeamOne release];
  [symbolBidResultTeamTwo release];
  [scoreSummaryTeamOne release];
  [scoreSummaryTeamTwo release];

  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void) setStyleForTeamOneBidAttempted:(NSString*)teamOneBidAttempted AndTeamOneBidAchieved:(BOOL)teamOneBidAchieved WithTeamTwoBidAttempted:(NSString*)teamTwoBidAttempted AndTeamTwoBidAchieved:(BOOL)teamTwoBidAchieved {
  
  BOOL teamOneWasBidder = teamOneBidAttempted != nil;
  BOOL teamTwoWasBidder = teamTwoBidAttempted != nil;

  if (teamOneWasBidder) {
    // hide team two's bid labels
    self.bidAttemptedTeamTwo.hidden = YES;
    self.symbolBidResultTeamTwo.hidden = YES;

    self.bidAttemptedTeamOne.text = [self prettyStringForHand:teamOneBidAttempted];
    if (teamOneBidAchieved) {
      self.symbolBidResultTeamOne.text = ssSymbolForBidWon;
      self.symbolBidResultTeamOne.textColor = [UIColor greenColor];
    }
    else {
      self.symbolBidResultTeamOne.text = ssSymbolForBidLost;
      self.symbolBidResultTeamOne.textColor = [UIColor redColor];
    }
  }
  else if (teamTwoWasBidder) {
    // hide team one's bid labels
    self.bidAttemptedTeamOne.hidden = YES;
    self.symbolBidResultTeamOne.hidden = YES;
    
    self.bidAttemptedTeamTwo.text = [self prettyStringForHand:teamTwoBidAttempted];
    if (teamTwoBidAchieved) {
      self.symbolBidResultTeamTwo.text = ssSymbolForBidWon;
      self.symbolBidResultTeamTwo.textColor = [UIColor greenColor];
    }
    else {
      self.symbolBidResultTeamTwo.text = ssSymbolForBidLost;
      self.symbolBidResultTeamTwo.textColor = [UIColor redColor];
    }
  }  
}

- (void) descriptionForTeamSlot:(NSNumber*)teamSlot FromTricksWon:(NSNumber*)tricksWon AndPoints:(NSNumber*)points {
  NSString* pointsPrefix = ([points intValue] > 0 ? @"+" : @"");
  NSString* summary = [NSString stringWithFormat:@"Won %@, %@%@ pts", tricksWon, pointsPrefix, points];
  
  if ([teamSlot intValue] == siSlotTeamOne) {
    self.scoreSummaryTeamOne.text = summary;
  }
  else if ([teamSlot intValue] == siSlotTeamTwo) {
    self.scoreSummaryTeamTwo.text = summary;
  }
}

- (NSString*) prettyStringForHand:(NSString*)hand {
  return [BidType tricksAndSymbolForHand:hand];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
