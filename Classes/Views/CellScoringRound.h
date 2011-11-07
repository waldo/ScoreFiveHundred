#import <UIKit/UIKit.h>
#import "BidType.h"
#import "Round.h"
#import "RoundScore.h"

@interface CellScoringRound : UITableViewCell {
  NSArray* bidAttempted;
  NSArray* points;
  NSArray* bidSucceeded;
  NSArray* bidFailed;
  NSArray* tricksWon;

  Round* round;
}

@property (nonatomic, retain) IBOutletCollection(UILabel) NSArray* bidAttempted;
@property (nonatomic, retain) IBOutletCollection(UILabel) NSArray* points;
@property (nonatomic, retain) IBOutletCollection(UILabel) NSArray* bidSucceeded;
@property (nonatomic, retain) IBOutletCollection(UILabel) NSArray* bidFailed;
@property (nonatomic, retain) IBOutletCollection(UILabel) NSArray* tricksWon;

@property (nonatomic, retain) Round* round;

- (void) setStyleForRound:(Round*)r;
- (void) setStyleForPosition:(int)pos;
- (NSString*) prettyStringForHand:(NSString*)hand;

@end