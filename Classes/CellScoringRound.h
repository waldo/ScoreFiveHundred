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
  UILabel *bidAttemptedTeamOneLabel;
  UILabel *bidAttemptedTeamTwoLabel;
  UILabel *pointsTeamOneLabel;
  UILabel *pointsTeamTwoLabel;
  UILabel *symbolBidResultTeamOneLabel;
  UILabel *symbolBidResultTeamTwoLabel;
  UILabel *scoreSummaryTeamOneLabel;
  UILabel *scoreSummaryTeamTwoLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *bidAttemptedTeamOneLabel;
@property (nonatomic, retain) IBOutlet UILabel *bidAttemptedTeamTwoLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointsTeamOneLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointsTeamTwoLabel;
@property (nonatomic, retain) IBOutlet UILabel *symbolBidResultTeamOneLabel;
@property (nonatomic, retain) IBOutlet UILabel *symbolBidResultTeamTwoLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreSummaryTeamOneLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreSummaryTeamTwoLabel;

- (void) setStyleForTeamOneBidAttempted:(NSString*)teamOneBidAttempted AndTeamOneBidAchieved:(BOOL)teamOneBidAchieved WithTeamTwoBidAttempted:(NSString*)teamTwoBidAttempted AndTeamTwoBidAchieved:(BOOL)teamTwoBidAchieved;

- (void) descriptionForTeamSlot:(NSNumber*)teamSlot FromTricksWon:(NSNumber*)tricksWon AndPoints:(NSNumber*)points;

- (NSString*) prettyStringForHand:(NSString*)hand;

@end