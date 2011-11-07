#import "Round.h"
#import "Game.h"
#import "RoundScore.h"
#import "Team.h"
#import "BidType.h"

@implementation Round

@dynamic bid;
@dynamic id;
@dynamic ordinal;
@dynamic biddingTeam;
@dynamic game;
@dynamic scores;


- (NSString*) bidForPosition:(int)pos {
  NSString* theBid = nil;

  if ([self.game nameForPosition:pos] == self.biddingTeam.name) {
    theBid = self.bid;
  }

  return theBid;
}

- (NSString*) bidAchievedForPosition:(int)pos {
  NSString* bidAchieved = nil;
  NSString* theBid = [self bidForPosition:pos];
  NSNumber* tricksWon = [[self.scores objectAtIndex:pos] tricksWon];

  if (theBid) {
    bidAchieved = [NSString stringWithFormat:@"%d", [BidType bidderWonHand:theBid WithTricksWon:tricksWon]];
  }
  
  return bidAchieved;
}

- (NSString*) scoreForPosition:(int)pos {
  return [[[self.scores objectAtIndex:pos] score] stringValue];
}

- (NSString*) tricksWonForPosition:(int)pos {
  return [[[self.scores objectAtIndex:pos] tricksWon] stringValue];
}

// MARK: set core data defaults
- (void) awakeFromInsert {
  [super awakeFromInsert];
  [self setValue:[Round uniqueId] forKey:@"id"];
}

// MARK: class methods
+ (NSString*) uniqueId {
  CFUUIDRef uniqueId = CFUUIDCreate(NULL);
  NSString* sUniqueId = (NSString*)CFUUIDCreateString(NULL, uniqueId); // convert to string
  CFRelease(uniqueId);
  
  return [sUniqueId autorelease];
}

// MARK: override buggy coredata code
- (void)addScoresObject:(Round*)value {
  NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.scores];
  [tempSet addObject:value];
  self.scores = tempSet;
}

@end
