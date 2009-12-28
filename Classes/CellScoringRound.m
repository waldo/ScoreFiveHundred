//
//  CellScoringRound.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 23/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import "CellScoringRound.h"


@implementation CellScoringRound

static NSString *ssBidAttemptedLabel = @"Bid Attempted";
static NSString *ssBidWonOrLostLabel = @"Bid Won or Lost";
static NSString *ssScoreSummaryLabel = @"Score Summary";
static NSString *ssRunningTotalScoreLabel = @"Running Total Score";

static NSString *ssSymbolForBidWon = @"✔";
static NSString *ssSymbolForBidLost = @"✘";

@synthesize bidAttemptedTeamOneLabel;
@synthesize bidAttemptedTeamTwoLabel;
@synthesize pointsTeamOneLabel;
@synthesize pointsTeamTwoLabel;
@synthesize symbolBidResultTeamOneLabel;
@synthesize symbolBidResultTeamTwoLabel;
@synthesize scoreSummaryTeamOneLabel;
@synthesize scoreSummaryTeamTwoLabel;

@synthesize labels;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void) setStyleForBidderSlot:(NSNumber *)bidderSlot NonBidderSlot:(NSNumber *)nonBidderSlot WhenBidderWon:(BOOL)didBidderWin AndHandText:(NSString *)handText WithBidderTricksWon:(NSNumber *)bidderTricksWon AndNonBidderTricksWon:(NSNumber *)nonBidderTricksWon AndBidderPoints:(NSNumber *)bidderPoints AndNonBidderPoints:(NSNumber *)nonBidderPoints {

  if (self.labels == nil) {
    self.labels = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    bidAttemptedTeamOneLabel,    ssBidAttemptedLabel,
                    symbolBidResultTeamOneLabel, ssBidWonOrLostLabel,
                    scoreSummaryTeamOneLabel,    ssScoreSummaryLabel,
                    pointsTeamOneLabel,          ssRunningTotalScoreLabel,
                    nil
                    ],
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    bidAttemptedTeamTwoLabel,    ssBidAttemptedLabel,
                    symbolBidResultTeamTwoLabel, ssBidWonOrLostLabel,
                    scoreSummaryTeamTwoLabel,    ssScoreSummaryLabel,
                    pointsTeamTwoLabel,          ssRunningTotalScoreLabel,
                    nil
                    ],
                   nil
                   ];
  }
  
  NSDictionary *bidderLabels = [self.labels objectAtIndex:[bidderSlot intValue]];
  NSDictionary *nonBidderLabels = [self.labels objectAtIndex:[nonBidderSlot intValue]];
  
  NSString *bidderScorePrefix = @"";
  // blank non-bidder's bid attempt labels (since they didn't attempt a bid)
  [[nonBidderLabels valueForKey:ssBidWonOrLostLabel] setText:@""];
  [[nonBidderLabels valueForKey:ssBidAttemptedLabel] setText:@""];
  // show bidding team's bid
  [[bidderLabels valueForKey:ssBidAttemptedLabel] setText:handText];
  
  if (didBidderWin) {
    bidderScorePrefix = @"+";
    [[bidderLabels valueForKey:ssBidWonOrLostLabel] setText:ssSymbolForBidWon];
    [[bidderLabels valueForKey:ssBidWonOrLostLabel] setColor:[UIColor greenColor]];
  }
  else {
    [[bidderLabels valueForKey:ssBidWonOrLostLabel] setText:ssSymbolForBidLost];
    [[bidderLabels valueForKey:ssBidWonOrLostLabel] setColor:[UIColor redColor]];
  }
  
  [[bidderLabels valueForKey:ssScoreSummaryLabel] setText:[NSString stringWithFormat:@"Won %@, %@%@ pts", bidderTricksWon, bidderScorePrefix, bidderPoints]];
  
  [[nonBidderLabels valueForKey:ssScoreSummaryLabel] setText:[NSString stringWithFormat:@"Won %@, %@%@ pts", nonBidderTricksWon, nonBidderPoints < 0 ? @"" : @"+", nonBidderPoints]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
}


@end
