#import "CellScoringRound.h"

@implementation CellScoringRound

@synthesize bidAttempted;
@synthesize points;
@synthesize bidSucceeded;
@synthesize bidFailed;
@synthesize tricksWon;

@synthesize round;

- (void) dealloc {
  [bidAttempted release];
  [points release];
  [bidSucceeded release];
  [bidFailed release];
  [tricksWon release];

  [round release];

  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
  }
  return self;
}

- (void) setStyleForRound:(Round*)r {
  self.round = r;
  [self setStyleForPosition:0];
  [self setStyleForPosition:1];
}

- (void) setStyleForPosition:(int)pos {
  [[self.bidAttempted objectAtIndex:pos] setText:[self prettyStringForHand:[self.round bidForPosition:pos]]];
  [[self.bidAttempted objectAtIndex:pos] setHidden:([self.round bidForPosition:pos] == nil)];
  [[self.bidSucceeded objectAtIndex:pos] setHidden:([self.round bidAchievedForPosition:pos] == nil || [[self.round bidAchievedForPosition:pos] boolValue] == NO)];
  [[self.bidFailed objectAtIndex:pos] setHidden:([self.round bidAchievedForPosition:pos] == nil || [[self.round bidAchievedForPosition:pos] boolValue] == YES)];
  [[self.tricksWon objectAtIndex:pos] setText:[@"Won " stringByAppendingString:[self.round tricksWonForPosition:pos]]];
  [[self.points objectAtIndex:pos] setText:[self.round scoreForPosition:pos]];
}

- (NSString*) prettyStringForHand:(NSString*)hand {
  return [BidType tricksAndSymbolForHand:hand];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
