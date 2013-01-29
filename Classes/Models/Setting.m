#import "Setting.h"
#import "Game.h"

@implementation Setting

@dynamic mode,
  tournament,
  firstToCross,
  nonBidderScoresTen,
  onlySuccessfulDefendersScore,
  capDefendersScore,
  noOneBid,
  game;

@synthesize modeOptions;

- (void) didTurnIntoFault {  
  [super didTurnIntoFault];
}


- (void) awakeFromInsert {
  [super awakeFromInsert];

  self.modeOptions = [NSOrderedSet orderedSetWithObjects:
                      @{@"text": @"2 teams", @"detail": @"4 or 6 players"},
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"3 players", @"text", @"", @"detail", nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"5 players", @"text", @"", @"detail", nil],
                      @{@"text": @"Quebec mode", @"detail": @"Play to 1000 points"},
                      nil];
}

- (void) setToMatch:(Setting*)recent {
  self.mode = recent.mode;
  self.tournament = recent.tournament;
  self.firstToCross = recent.firstToCross;
  self.nonBidderScoresTen = recent.nonBidderScoresTen;
  self.noOneBid = recent.noOneBid;
}

- (NSString*) textForCurrentTournament {
  return [self textForTournament:[self.tournament intValue]];
}

- (NSString*) textForTournament:(NSUInteger)rounds {
  if (rounds == 0) {
    return @"Off";
  }
  else if (rounds == 1) {
    return @"1 round";
  }
  
  return [NSString stringWithFormat:@"%d rounds", rounds];
}

- (NSIndexPath*) indexPathOfCurrentMode {
  int row = [self.modeOptions indexOfObject:self.mode];
  
  if (row == 1) {
    return [NSIndexPath indexPathForRow:0 inSection:1];
  }

  return [NSIndexPath indexPathForRow:row inSection:0];
}

- (NSInteger) numberOfTeams {
  if ([self.mode isEqualToString:@"3 players"]) {
    return 3;
  }
  else if ([self.mode isEqualToString:@"5 players"]) {
    return 5;
  }
  
  return 2;
}

- (BOOL) isPlayOnNoOneBid {
  return [self.noOneBid boolValue];
}

- (void) consistentForMode {
  if ([self.mode isEqualToString:@"Quebec mode"]) {
    self.noOneBid = @NO;
    self.nonBidderScoresTen = @NO;
    self.firstToCross = @YES;
  }
}

@end
