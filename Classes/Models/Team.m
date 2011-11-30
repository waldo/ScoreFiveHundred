#import "Team.h"
#import "Game.h"
#import "Round.h"
#import "RoundScore.h"


@implementation Team

@dynamic id;
@dynamic name;
@dynamic games;
@dynamic gameWinners;
@dynamic roundBidder;
@dynamic roundScores;

// MARK: set core data defaults
- (void) awakeFromInsert {
  [super awakeFromInsert];
  [self setValue:[Round uniqueId] forKey:@"id"];
}

@end