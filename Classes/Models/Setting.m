#import "Setting.h"
#import "Game.h"


@implementation Setting

#pragma mark Dynamic

@dynamic mode,
  tournament,
  firstToCross,
  nonBidderScoresTen,
  onlySuccessfulDefendersScore,
  capDefendersScore,
  noOneBid,
  game;

#pragma mark Synthesize

@synthesize modeOptions=_modeOptions;

#pragma mark Public

- (void)setToMatch:(Setting *)recent {
  self.mode = recent.mode;
  self.tournament = recent.tournament;
  self.firstToCross = recent.firstToCross;
  self.nonBidderScoresTen = recent.nonBidderScoresTen;
  self.onlySuccessfulDefendersScore = recent.onlySuccessfulDefendersScore;
  self.capDefendersScore = recent.capDefendersScore;
  self.noOneBid = recent.noOneBid;
}

- (NSString *)textForDefendersScoring {
  NSString *text = @"Off";
  if (self.nonBidderScoresTen.boolValue) {
    text = @"10 per trick";
    if (self.onlySuccessfulDefendersScore.boolValue) {
      text = [text stringByAppendingString:@" if bid fails"];
    }
    if (self.capDefendersScore.intValue > 0) {
      text = [NSString stringWithFormat:@"%@ (capped at %@)", text, self.capDefendersScore];
    }
  }

  return text;
}

- (NSString *)textForCurrentTournament {
  return [self textForTournament:[self.tournament intValue]];
}

- (NSString *)textForTournament:(NSUInteger)rounds {
  if (rounds == 0) {
    return @"Off";
  }
  else if (rounds == 1) {
    return @"1 round";
  }
  
  return [NSString stringWithFormat:@"%d rounds", rounds];
}

- (NSInteger)numberOfTeams {
  if ([self.mode isEqualToString:@"3 players"]) {
    return 3;
  }
  else if ([self.mode isEqualToString:@"5 players"]) {
    return 5;
  }
  
  return 2;
}

- (BOOL)isPlayOnNoOneBid {
  return [self.noOneBid boolValue];
}

- (void)consistentForMode {
  if ([self.mode isEqualToString:@"Quebec mode"]) {
    self.noOneBid = @NO;
    self.nonBidderScoresTen = @NO;
    self.firstToCross = @YES;
  }
}

#pragma mark Core data

- (void)didTurnIntoFault {
  [super didTurnIntoFault];
}


- (void)awakeFromInsert {
  [super awakeFromInsert];

  self.modeOptions = @[@"2 teams", @"Quebec mode"];
}

@end
