#import <UIKit/UIKit.h>
#import "BidType.h"
#import "Round.h"
#import "RoundScore.h"

@interface CellScoringRound : UITableViewCell

@property IBOutletCollection(UILabel) NSArray *tickCrossLabels;
@property IBOutletCollection(UILabel) NSArray *bidLabels;
@property IBOutletCollection(UILabel) NSArray *pointsLabels;
@property Round *round;

- (void)setStyleForRound:(Round *)r;

@end