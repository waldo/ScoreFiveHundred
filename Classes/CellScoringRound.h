//
//  CellScoringRound.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 23/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BidType.h"


@interface CellScoringRound : UITableViewCell {
  UILabel* bidAttemptedTeamOne;
  UILabel* bidAttemptedTeamTwo;
  UILabel* pointsTeamOne;
  UILabel* pointsTeamTwo;
  UILabel* symbolBidResultTeamOne;
  UILabel* symbolBidResultTeamTwo;
  UILabel* scoreSummaryTeamOne;
  UILabel* scoreSummaryTeamTwo;
}

@property (nonatomic, retain) IBOutlet UILabel* bidAttemptedTeamOne;
@property (nonatomic, retain) IBOutlet UILabel* bidAttemptedTeamTwo;
@property (nonatomic, retain) IBOutlet UILabel* pointsTeamOne;
@property (nonatomic, retain) IBOutlet UILabel* pointsTeamTwo;
@property (nonatomic, retain) IBOutlet UILabel* symbolBidResultTeamOne;
@property (nonatomic, retain) IBOutlet UILabel* symbolBidResultTeamTwo;
@property (nonatomic, retain) IBOutlet UILabel* scoreSummaryTeamOne;
@property (nonatomic, retain) IBOutlet UILabel* scoreSummaryTeamTwo;

- (void) setStyleForTeamOneBidAttempted:(NSString*)teamOneBidAttempted AndTeamOneBidAchieved:(BOOL)teamOneBidAchieved WithTeamTwoBidAttempted:(NSString*)teamTwoBidAttempted AndTeamTwoBidAchieved:(BOOL)teamTwoBidAchieved;

- (void) descriptionForTeamSlot:(NSNumber*)teamSlot FromTricksWon:(NSNumber*)tricksWon AndPoints:(NSNumber*)points;

- (NSString*) prettyStringForHand:(NSString*)hand;

@end