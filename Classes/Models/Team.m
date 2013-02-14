#import "Team.h"
#import "Game.h"
#import "Round.h"
#import "RoundScore.h"


@implementation Team

#pragma mark Dynamic

@dynamic id,
  name,
  games,
  gameWinners,
  roundBidder,
  roundScores;

#pragma mark Core data
- (void) awakeFromInsert {
  [super awakeFromInsert];

  [self setValue:[Round uniqueId] forKey:@"id"];
}

@end
