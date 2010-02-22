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

@synthesize bidAttemptedTeamOneLabel;
@synthesize bidAttemptedTeamTwoLabel;
@synthesize pointsTeamOneLabel;
@synthesize pointsTeamTwoLabel;
@synthesize symbolBidResultTeamOneLabel;
@synthesize symbolBidResultTeamTwoLabel;
@synthesize scoreSummaryTeamOneLabel;
@synthesize scoreSummaryTeamTwoLabel;

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
    self.bidAttemptedTeamTwoLabel.hidden = YES;
    self.symbolBidResultTeamTwoLabel.hidden = YES;

    self.bidAttemptedTeamOneLabel.text = [self prettyStringForHand:teamOneBidAttempted];
    if (teamOneBidAchieved) {
      self.symbolBidResultTeamOneLabel.text = ssSymbolForBidWon;
      self.symbolBidResultTeamOneLabel.textColor = [UIColor greenColor];
    }
    else {
      self.symbolBidResultTeamOneLabel.text = ssSymbolForBidLost;
      self.symbolBidResultTeamOneLabel.textColor = [UIColor redColor];
    }
  }
  else if (teamTwoWasBidder) {
    // hide team one's bid labels
    self.bidAttemptedTeamOneLabel.hidden = YES;
    self.symbolBidResultTeamOneLabel.hidden = YES;
    
    self.bidAttemptedTeamTwoLabel.text = [self prettyStringForHand:teamTwoBidAttempted];
    if (teamTwoBidAchieved) {
      self.symbolBidResultTeamTwoLabel.text = ssSymbolForBidWon;
      self.symbolBidResultTeamTwoLabel.textColor = [UIColor greenColor];
    }
    else {
      self.symbolBidResultTeamTwoLabel.text = ssSymbolForBidLost;
      self.symbolBidResultTeamTwoLabel.textColor = [UIColor redColor];
    }
  }  
}

- (void) descriptionForTeamSlot:(NSNumber*)teamSlot FromTricksWon:(NSNumber*)tricksWon AndPoints:(NSNumber*)points {
  NSString* pointsPrefix = ([points intValue] > 0 ? @"+" : @"");
  NSString* summary = [NSString stringWithFormat:@"Won %@, %@%@ pts", tricksWon, pointsPrefix, points];
  
  if ([teamSlot intValue] == siSlotTeamOne) {
    self.scoreSummaryTeamOneLabel.text = summary;
  }
  else if ([teamSlot intValue] == siSlotTeamTwo) {
    self.scoreSummaryTeamTwoLabel.text = summary;
  }
}

- (NSString*) prettyStringForHand:(NSString*)hand {
  return [BidType tricksAndSymbolForHand:hand];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
}


@end
