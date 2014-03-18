#import "Round.h"
#import "Game.h"
#import "RoundScore.h"
#import "Team.h"
#import "BidType.h"


@interface Round ()

- (BOOL)guardForScoresOnPosition:(NSUInteger)pos;
- (void)setTricksWon:(NSUInteger)tricksWon forPosition:(NSUInteger)pos;

@end

@implementation Round

#pragma mark Dynamic

@dynamic bid,
  id,
  ordinal,
  biddingTeams,
  game,
  scores;

#pragma mark Public

- (NSString *)bidForPosition:(NSUInteger)pos {
  NSString *theBid = nil;

  if ([self.biddingTeams containsObject:(self.game.teams)[pos]]) {
    theBid = self.bid;
  }

  return theBid;
}

- (NSNumber *)bidAchievedForPosition:(NSUInteger)pos {
  NSNumber *bidAchieved = nil;
  NSString *theBid = [self bidForPosition:pos];
  NSUInteger tricksWon = [[(self.scores)[pos] tricksWon] intValue];

  if (theBid) {
    bidAchieved = @([BidType bidderWonHand:theBid withTricksWon:tricksWon]);
  }
  
  return bidAchieved;
}

- (NSString *)scoreForPosition:(NSUInteger)pos {
  if ([self guardForScoresOnPosition:pos]) {
    return nil;
  }

  return [[(self.scores)[pos] score] stringValue];
}

- (NSString *)tricksWonForPosition:(NSUInteger)pos {
  if ([self guardForScoresOnPosition:pos]) {
    return nil;
  }

  return [[(self.scores)[pos] tricksWon] stringValue];
}

- (RoundScore *)getScoreForPosition:(NSUInteger)pos {
  if ([self guardForScoresOnPosition:pos]) {
    return nil;
  }

  return (self.scores)[pos];
}

- (void)setTricksWon:(NSUInteger)tricksWon forTeam:(Team *)t {
  long pos = [self.game.teams indexOfObject:t];
  [self setTricksWon:tricksWon forPosition:pos];

  // update others
  int newPos = -1;
  
  if ([self.game.teams count] == 2) {
    if (pos == 0) {
      newPos = 1;
    }
    else {
      newPos = 0;
    }

    [self setTricksWon:10-tricksWon forPosition:newPos];      
  }
}

- (BOOL)isNew {
  NSDictionary *vals = [self committedValuesForKeys:nil];
  return (vals.count == 0);
}

+ (NSString *)uniqueId {
  CFUUIDRef uniqueId = CFUUIDCreate(NULL);
  NSString *sUniqueId = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uniqueId));
  CFRelease(uniqueId);

  return sUniqueId;
}

#pragma mark Private
- (BOOL)guardForScoresOnPosition:(NSUInteger)pos {
  return (self.scores == nil || [self.scores count] <= pos);
}

- (void)setTricksWon:(NSUInteger)tricksWon forPosition:(NSUInteger)pos {
  RoundScore *rs = [self getScoreForPosition:pos];
  rs.tricksWon = @(tricksWon);
  rs.score = @([BidType pointsForTeam:(self.game.teams)[pos] game:self.game andTricksWon:tricksWon] + [[self.game scoreForPosition:pos] intValue]);
}

#pragma mark Core data
- (void)awakeFromInsert {
  [super awakeFromInsert];
  [self setValue:[Round uniqueId] forKey:@"id"];
}

#pragma mark Override buggy coredata code
- (void)addScoresObject:(RoundScore *)value {
  NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.scores];
  [tempSet addObject:value];
  self.scores = tempSet;
}

- (void)addBiddingTeamsObject:(Team *)value {
  NSMutableSet *tempSet = [NSMutableSet setWithSet:self.biddingTeams];
  [tempSet addObject:value];
  self.biddingTeams = tempSet;
}

@end
