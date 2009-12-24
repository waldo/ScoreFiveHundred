//
//  CellScoringRound.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 23/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CellScoringRound : UITableViewCell {
  UILabel *bidAttemptedTeamOneLabel;
  UILabel *bidAttemptedTeamTwoLabel;
  UILabel *pointsTeamOneLabel;
  UILabel *pointsTeamTwoLabel;
  UILabel *symbolBidResultTeamOneLabel;
  UILabel *symbolBidResultTeamTwoLabel;
  UILabel *scoreSummaryTeamOneLabel;
  UILabel *scoreSummaryTeamTwoLabel;
  
  NSArray *labels;
}

@property (nonatomic, retain) IBOutlet UILabel *bidAttemptedTeamOneLabel;
@property (nonatomic, retain) IBOutlet UILabel *bidAttemptedTeamTwoLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointsTeamOneLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointsTeamTwoLabel;
@property (nonatomic, retain) IBOutlet UILabel *symbolBidResultTeamOneLabel;
@property (nonatomic, retain) IBOutlet UILabel *symbolBidResultTeamTwoLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreSummaryTeamOneLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreSummaryTeamTwoLabel;

@property (nonatomic, retain) NSArray *labels;

- (void) setStyleForBidderSlot:(NSNumber *)bidderSlot NonBidderSlot:(NSNumber *)nonBidderSlot WhenBidderWon:(BOOL)didBidderWin AndHandText:(NSString *)handText WithBidderTricksWon:(NSNumber *)bidderTricksWon AndNonBidderTricksWon:(NSNumber *)nonBidderTricksWon AndBidderPoints:(NSNumber *)bidderPoints AndNonBidderPoints:(NSNumber *)nonBidderPoints;

@end
