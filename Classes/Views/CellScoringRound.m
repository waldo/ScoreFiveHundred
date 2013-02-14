#import "CellScoringRound.h"


@interface CellScoringRound ()

@property IBOutletCollection(UILabel) NSArray *tickCrossLabels;
@property IBOutletCollection(UILabel) NSArray *bidLabels;
@property IBOutletCollection(UILabel) NSArray *pointsLabels;
@property Round *round;

- (void)setStyleForPosition:(int)pos;
- (NSString *)formattedTricksWonForPosition:(int)pos;
- (NSString *)prettyStringForHand:(NSString *)hand;

@end

@implementation CellScoringRound

#pragma mark Public

- (void)setStyleForRound:(Round *)r {
  self.round = r;
  [self setStyleForPosition:0];
  [self setStyleForPosition:1];
}

#pragma mark Private

- (void)setStyleForPosition:(int)pos {
  UILabel *tickCrossLabel = _tickCrossLabels[pos];
  UILabel *bidLabel = _bidLabels[pos];
  UILabel *pointsLabel = _pointsLabels[pos];
  NSString *bid = [_round bidForPosition:pos];
  NSString *tricksWonString = [self formattedTricksWonForPosition:pos];
  BOOL isBidder = (bid != nil);
  BOOL bidAchieved = [_round bidAchievedForPosition:pos].boolValue;

  tickCrossLabel.text = isBidder ? (bidAchieved ? @"✅" : @"❌") : @"";
  bidLabel.text = isBidder ? [self prettyStringForHand:bid] : tricksWonString;
  pointsLabel.text = [_round scoreForPosition:pos];
  if ([_round isEqual:_round.game.currentRound]) {
    pointsLabel.font = [UIFont boldSystemFontOfSize:18];
  }
  else {
    pointsLabel.font = [UIFont systemFontOfSize:18];
  }
}

- (NSString *)formattedTricksWonForPosition:(int)pos {
  NSString *formatted = @"";

  if ([[BidType variation:_round.bid] isEqualToString:@"no bid"]) {
    formatted = [NSString stringWithFormat:@"(%@ tricks)", [_round tricksWonForPosition:pos]];
  }

  return formatted;
}

- (NSString *)prettyStringForHand:(NSString *)hand {
  return [BidType tricksAndSymbolForHand:hand];
}

@end
