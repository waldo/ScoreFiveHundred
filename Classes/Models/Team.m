#import "Team.h"
#import "Game.h"
#import "Round.h"
#import "RoundScore.h"


@implementation Team

@dynamic id,
  name,
  games,
  gameWinners,
  roundBidder,
  roundScores;

// MARK: set core data defaults
- (void) awakeFromInsert {
  [super awakeFromInsert];

  [self setValue:[Round uniqueId] forKey:@"id"];
}

@end
