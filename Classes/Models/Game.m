#import "Game.h"
#import "Round.h"
#import "RoundScore.h"
#import "Setting.h"
#import "Team.h"


@interface Game ()

- (void)scoresForRound:(Round *)r min:(int *)minScore andMax:(int *)maxScore;
- (void)checkWithNormalRules:(Round *)r;
- (void)checkWithFirstToCross:(Round *)r;
- (void)checkWithTournament:(Round *)r;
- (void)checkWithQuebec:(Round *)r;

@end

@implementation Game

#pragma mark Static

static int scoreToWin = 500;
static int scoreToLose = -500;
static int scoreToWinQuebec = 1000;
static NSManagedObjectContext *staticManagedObjectContext;

#pragma mark Dynamic
@dynamic complete,
  id,
  lastPlayed,
  rounds,
  teams,
  winningTeams,
  setting;

#pragma mark Public
- (NSNumber *)isComplete {
  return @(self.winningTeams.count > 0);
}

- (NSString *)nameForPosition:(NSUInteger)pos {
  if ([self.teams count] > pos) {
    return [(self.teams)[pos] name];
  }

  return nil;
}

- (NSString *)scoreForTeam:(Team *)team {
  return [self scoreForPosition:[self.teams indexOfObject:team]];
}

- (NSString *)scoreForPosition:(NSUInteger)pos {
  if ((self.rounds == nil || self.latestCompleteRound == nil)) {
    return @"0";
  }

  return [self.latestCompleteRound scoreForPosition:pos];
}


- (BOOL)isVictorInPosition:(NSUInteger)pos {
  if (self.winningTeams == nil) {
    return false;
  }
  else {
    for (Team *t in self.winningTeams) {
      if ([t isEqual:(self.teams)[pos]]) {
        return true;
      }
    }
  }

  return false;
}

- (Round *)buildRound {
  [self.managedObjectContext.undoManager beginUndoGrouping];
  [self.managedObjectContext.undoManager setActionName:@"new round"];
  Round *r = [NSEntityDescription insertNewObjectForEntityForName:@"Round" inManagedObjectContext:self.managedObjectContext];
  r.complete = [NSNumber numberWithBool:NO];
  [self insertObject:r inRoundsAtIndex:0];

  for (Team *t in self.teams) {
    RoundScore *rs = [NSEntityDescription insertNewObjectForEntityForName:@"RoundScore" inManagedObjectContext:self.managedObjectContext];
    rs.round = r;
    rs.team = t;
    [r addScoresObject:rs];
  }

  [r setTricksWon:10 forTeam:(self.teams)[0]];

  return r;
}

- (void)finaliseRound {
  if ([self.managedObjectContext.undoManager.undoActionName isEqualToString:@"new round"]) {
    [self.managedObjectContext.undoManager endUndoGrouping];
    [self.managedObjectContext.undoManager setActionName:@""];
    self.lastPlayed = [NSDate date];

    [self checkForGameOver];
    [self save];
  }
}

- (void)undoRound {
  if ([self.managedObjectContext.undoManager.undoActionName isEqualToString:@"new round"]) {
    [self.managedObjectContext.undoManager endUndoGrouping];
    [self.managedObjectContext.undoManager undo];
  }
}

- (Round *)latestCompleteRound {
  Round *round = nil;

  if (self.rounds.count == 1) {
    if ([((Round *)self.rounds[0]) complete]) {
      round = self.rounds[0];
    }
  }
  else if (self.rounds.count > 1) {
    round = [((Round*)self.rounds[0]) complete] ? self.rounds[0] : self.rounds[1];
  }

  return round;
}

- (Round *)currentRound {
  return self.rounds.firstObject;
}

- (void)setTeamsByNames:(NSMutableOrderedSet *)names {
  for (NSString *name in names) {
    Team *t = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.managedObjectContext];
    t.name = name;
    [self addTeamsObject:t];
  }
}

- (NSString *)teamNames:(NSSet *)teams {
  if (teams == nil || [teams count] == 0) {
    return nil;
  }
  NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:[teams count]];
  for (Team *t in teams) {
    [names addObject:t.name];
  }

  return [names componentsJoinedByString:@" and "];
}

- (void) checkForGameOver {
  self.winningTeams = nil;

  if ([self.rounds count] > 0) {
    Round *r = (self.rounds)[0];

    if ([self.setting.mode isEqualToString:@"Quebec mode"]) {
      [self checkWithQuebec:r];
    }
    else if ([self.setting.tournament intValue] > 0) {
      [self checkWithTournament:r];
    }
    else if ([self.setting.firstToCross boolValue]) {
      [self checkWithFirstToCross:r];
    }
    else {
      [self checkWithNormalRules:r];
    }
  }
}

- (Game *)duplicate {
  Game *clone = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
  
  clone.teams = self.teams;
  clone.setting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:self.managedObjectContext];
  
  clone.setting.mode = [self.setting.mode copy];
  clone.setting.tournament = [self.setting.tournament copy];
  clone.setting.firstToCross = [self.setting.firstToCross copy];
  clone.setting.nonBidderScoresTen = [self.setting.nonBidderScoresTen copy];
  clone.setting.noOneBid = [self.setting.noOneBid copy];

  clone.lastPlayed = [NSDate date];
  
  [clone save];

  return clone;
}

- (void)save {
  // remove undo marker before save
  if ([self.managedObjectContext.undoManager.undoActionName isEqualToString:@"set up game"]) {
    [self.managedObjectContext.undoManager endUndoGrouping];
    [self.managedObjectContext.undoManager removeAllActions];
  }

  NSError *err = nil;
  if (![self.managedObjectContext save:&err]) {
    NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
  }
}

- (void)undo {
  if ([self.managedObjectContext.undoManager.undoActionName isEqualToString:@"set up game"]) {
    [self.managedObjectContext.undoManager endUndoGrouping];
    [self.managedObjectContext.undoManager undo];
  }
}

+ (void)setManagedObjectContext:(NSManagedObjectContext *)moc {
  staticManagedObjectContext = moc;
}

+ (NSArray *)getAll {
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:staticManagedObjectContext];

  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  [request setIncludesSubentities:YES];

  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastPlayed" ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [request setSortDescriptors:sortDescriptors];

  NSError *error;
  return [staticManagedObjectContext executeFetchRequest:request error:&error];
}

+ (Game *)buildGame {
  [[staticManagedObjectContext undoManager] beginUndoGrouping];
  [[staticManagedObjectContext undoManager] setActionName:@"set up game"];

  Game *g = (Game *)[NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:staticManagedObjectContext];
  Setting *s = (Setting *)[NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:staticManagedObjectContext];
  g.setting = s;

  return g;
}

+ (void)deleteGame:(Game *)game {
  [staticManagedObjectContext deleteObject:game];
  NSError *err = nil;

  if (![staticManagedObjectContext save:&err]) {
    NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
  }
}

#pragma mark Private
- (void)checkWithNormalRules:(Round *)r {
  int maxScore, minScore;
  [self scoresForRound:r min:&minScore andMax:&maxScore];

  if (minScore <= scoreToLose) {
    for (int i = 0; i < [self.teams count]; ++i) {
      int score = [[r scoreForPosition:i] intValue];

      if (score != minScore) {
        [self addWinningTeamsObject:(self.teams)[i]];
      }
    }
  }
  else if (maxScore >= scoreToWin) {
    for (int i = 0; i < [self.teams count]; ++i) {
      int score = [[r scoreForPosition:i] intValue];

      if (score >= scoreToWin && [r bidAchievedForPosition:i]) {
        [self addWinningTeamsObject:(self.teams)[i]];
      }
    }
  }
}

- (void)checkWithFirstToCross:(Round *)r {
  int maxScore, minScore;
  [self scoresForRound:r min:&minScore andMax:&maxScore];

  if (maxScore >= scoreToWin) {
    for (int i = 0; i < [self.teams count]; ++i) {
      int score = [[r scoreForPosition:i] intValue];

      if (score >= maxScore) {
        [self addWinningTeamsObject:(self.teams)[i]];
      }
    }
  }
  else if (minScore <= scoreToLose) {
    for (int i = 0; i < [self.teams count]; ++i) {
      int score = [[r scoreForPosition:i] intValue];

      if (score != minScore) {
        [self addWinningTeamsObject:(self.teams)[i]];
      }
    }
  }
}

- (void)checkWithTournament:(Round *)r {
  int maxScore, minScore;
  [self scoresForRound:r min:&minScore andMax:&maxScore];

  if ([self.rounds count] >= [self.setting.tournament intValue]) {
    for (int i = 0; i < [self.teams count]; ++i) {
      int score = [[r scoreForPosition:i] intValue];

      if (score == maxScore) {
        [self addWinningTeamsObject:(self.teams)[i]];
      }
    }
  }
}

- (void)checkWithQuebec:(Round *)r {
  int maxScore, minScore;
  [self scoresForRound:r min:&minScore andMax:&maxScore];

  if (maxScore >= scoreToWinQuebec) {
    for (int i = 0; i < [self.teams count]; ++i) {
      int score = [[r scoreForPosition:i] intValue];

      if (score >= maxScore) {
        [self addWinningTeamsObject:(self.teams)[i]];
      }
    }
  }
}

- (void)scoresForRound:(Round *)r min:(int *)minScore andMax:(int *)maxScore {
  *maxScore = scoreToLose;
  *minScore = scoreToWin;

  for (int i = 0; i < [self.teams count]; ++i) {
    int score = [[r scoreForPosition:i] intValue];
    if (score > *maxScore) {
      *maxScore = score;
    }
    else if (score < *minScore) {
      *minScore = score;
    }
  }
}

#pragma mark Core data defaults
- (void)awakeFromInsert {
  [super awakeFromInsert];
  [self setValue:[Round uniqueId] forKey:@"id"];
  [self setValue:[NSDate date] forKey:@"lastPlayed"];
}

- (void)didTurnIntoFault {
  [super didTurnIntoFault];
}

#pragma mark Override buggy coredata code
- (void)addTeamsObject:(Team *)value {
  NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.teams];
  [tempSet addObject:value];
  self.teams = tempSet;
}

- (void)addRoundsObject:(Round *)value {
  NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.rounds];
  [tempSet addObject:value];
  self.rounds = tempSet;
}

- (void)insertObject:(Round *)value inRoundsAtIndex:(NSUInteger)idx {
  NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.rounds];
  [tempSet insertObject:value atIndex:idx];
  self.rounds = tempSet;
}

- (void)removeObjectFromRoundsAtIndex:(NSUInteger)idx {
  NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.rounds];
  Round *r = tempSet[idx];
  [tempSet removeObjectAtIndex:idx];
  self.rounds = tempSet;
  [self.managedObjectContext deleteObject:r];
  [self checkForGameOver];
}

@end
