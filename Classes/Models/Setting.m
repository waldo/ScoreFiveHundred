#import "Setting.h"
#import "Game.h"

@implementation Setting

@dynamic mode;
@dynamic tournament;
@dynamic firstToCross;
@dynamic nonBidderScoresTen;
@dynamic noOneBid;
@dynamic game;

@synthesize tournamentOptions;
@synthesize modeOptions;

- (void) didTurnIntoFault {
  [tournamentOptions release];
  [modeOptions release];
  
  [super didTurnIntoFault];
}


- (void) initOptions {
  self.modeOptions = [NSOrderedSet orderedSetWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"2 teams", @"text", @"4 or 6 players", @"detail", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"3 players", @"text", @"", @"detail", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"5 players", @"text", @"", @"detail", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Quebec mode", @"text", @"Play to 1000 points", @"detail", nil],
                      nil];
  
  self.tournamentOptions = [NSOrderedSet orderedSetWithObjects:
                            [NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],
                            [NSNumber numberWithInt:2],
                            [NSNumber numberWithInt:3],
                            [NSNumber numberWithInt:4],
                            [NSNumber numberWithInt:5],
                            [NSNumber numberWithInt:6],
                            [NSNumber numberWithInt:7],
                            [NSNumber numberWithInt:8],
                            [NSNumber numberWithInt:9],
                            [NSNumber numberWithInt:10],
                            [NSNumber numberWithInt:15],
                            [NSNumber numberWithInt:20],
                            nil];
}

- (NSString*) textForCurrentTournament {
  return [self textForTournament:[self.tournamentOptions indexOfObject:self.tournament]];
}

- (NSString*) textForTournament:(NSUInteger)ix {
  if (ix == 0) {
    return @"Off";
  }
  else if (ix == 1) {
    return [NSString stringWithFormat:@"%@ round", [self.tournamentOptions objectAtIndex:ix]];
  }
  
  return [NSString stringWithFormat:@"%@ rounds", [self.tournamentOptions objectAtIndex:ix]];
}

- (NSIndexPath*) indexPathOfCurrentMode {
  int row = [self.modeOptions indexOfObject:self.mode];
  
  if (row == 3) {
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

@end
