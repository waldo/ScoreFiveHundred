#import "Setting.h"
#import "Game.h"

@implementation Setting

@dynamic mode;
@dynamic tournament;
@dynamic firstToCross;
@dynamic nonBidderScoresTen;
@dynamic noOneBid;
@dynamic game;

@synthesize modeOptions;

- (void) didTurnIntoFault {  
  [modeOptions release];

  [super didTurnIntoFault];
}


- (void) awakeFromInsert {
  [super awakeFromInsert];

  self.modeOptions = [NSOrderedSet orderedSetWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"2 teams", @"text", @"4 or 6 players", @"detail", nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"3 players", @"text", @"", @"detail", nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"5 players", @"text", @"", @"detail", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Quebec mode", @"text", @"Play to 1000 points", @"detail", nil],
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
    self.noOneBid = [NSNumber numberWithBool:NO];
    self.nonBidderScoresTen = [NSNumber numberWithBool:NO];
    self.firstToCross = [NSNumber numberWithBool:YES];
  }
}

@end
