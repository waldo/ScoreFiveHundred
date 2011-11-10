#import "Game.h"
#import "Round.h"
#import "RoundScore.h"
#import "Team.h"

@implementation Game

@dynamic complete;
@dynamic id;
@dynamic lastPlayed;
@dynamic rounds;
@dynamic teams;
@dynamic winningTeam;

- (NSNumber*) isComplete {
  return [NSNumber numberWithBool:(self.winningTeam != nil)];
}

- (NSString*) nameForPosition:(int)pos {
  if ([self.teams count] > pos) {
    return [[self.teams objectAtIndex:pos] name];
  }

  return nil;
}

- (NSString*) scoreForPosition:(int)pos {
  Round* r = [self.rounds firstObject];
  if (r == nil) {
    return nil;
  }
  else {
    return [r scoreForPosition:pos];
  }
}

- (BOOL) isVictorInPosition:(int)pos {
  if (self.winningTeam == nil) {
    return false;
  }
  else {
    return [self nameForPosition:pos] == self.winningTeam.name;
  }
}

- (void) setTeamsByNames:(NSMutableOrderedSet*)names {
  for (NSString* name in names) {
    Team* t = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.managedObjectContext];
    t.name = name;
    [self addTeamsObject:t];
  }
}

- (void) buildRoundWithBiddingTeams:(NSOrderedSet*)biddingTeams hand:(NSString*)h andTricksAndScoreDict:(NSOrderedSet*)tricksAndScore {
  Round* r = [NSEntityDescription insertNewObjectForEntityForName:@"Round" inManagedObjectContext:self.managedObjectContext];
  RoundScore* scoreTeamOne = [NSEntityDescription insertNewObjectForEntityForName:@"RoundScore" inManagedObjectContext:self.managedObjectContext];
  RoundScore* scoreTeamTwo = [NSEntityDescription insertNewObjectForEntityForName:@"RoundScore" inManagedObjectContext:self.managedObjectContext];
  int oldScoreTeamOne = [self scoreForPosition:0] == nil ? 0 : [[self scoreForPosition:0] intValue];
  int oldScoreTeamTwo = [self scoreForPosition:1] == nil ? 0 : [[self scoreForPosition:1] intValue];
  int thisRoundScoreTeamOne = [[[tricksAndScore objectAtIndex:0] objectForKey:@"score"] intValue];
  int thisRoundScoreTeamTwo = [[[tricksAndScore objectAtIndex:1] objectForKey:@"score"] intValue];

  [r addBiddingTeams:[biddingTeams set]];
  r.bid = h;
  
  scoreTeamOne.team = [[self.teams objectAtIndex:0] retain];
  scoreTeamTwo.team = [[self.teams objectAtIndex:1] retain];
  
  scoreTeamOne.round = r;
  scoreTeamTwo.round = r;
  
  scoreTeamOne.tricksWon = [[tricksAndScore objectAtIndex:0] objectForKey:@"tricksWon"];
  scoreTeamTwo.tricksWon = [[tricksAndScore objectAtIndex:1] objectForKey:@"tricksWon"];
  scoreTeamOne.score = [NSNumber numberWithInt:(oldScoreTeamOne + thisRoundScoreTeamOne)];
  scoreTeamTwo.score = [NSNumber numberWithInt:(oldScoreTeamTwo + thisRoundScoreTeamTwo)];
  
  [r addScoresObject:scoreTeamOne];
  [r addScoresObject:scoreTeamTwo];

  [self insertObject:r inRoundsAtIndex:0];
  self.lastPlayed = [NSDate date];

  [self checkForGameOver];
  [self save];
}

- (void) checkForGameOver {
  self.winningTeam = nil;

  if ([self.rounds count] > 0) {
    Round* r = [self.rounds objectAtIndex:0];

    if (([[r scoreForPosition:0] intValue] >= 500 && [r bidAchievedForPosition:0]) || [[r scoreForPosition:1] intValue] <= -500) {
      self.winningTeam = [self.teams objectAtIndex:0];
    }
    else if (([[r scoreForPosition:1] intValue] >= 500 && [r bidAchievedForPosition:1]) || [[r scoreForPosition:0] intValue] <= -500) {
      self.winningTeam = [self.teams objectAtIndex:1];
    }
  }
}

- (Game*) duplicate {
  Game* clone = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
  
  clone.teams = self.teams;
  // TODO: copy settings (when they exist)
  
  [clone save];

  return clone;
}

- (void) save {
  NSError *error = nil;
  NSManagedObjectContext *moc = self.managedObjectContext;
  if (moc != nil) {
    if ([moc hasChanges] && ![moc save:&error]) {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}

// MARK: set core data defaults
- (void) awakeFromInsert {
  [super awakeFromInsert];
  [self setValue:[Round uniqueId] forKey:@"id"];
  [self setValue:[NSDate date] forKey:@"lastPlayed"];
}

// MARK: override buggy coredata code
- (void) addTeamsObject:(Team*)value {
  NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.teams];
  [tempSet addObject:value];
  self.teams = tempSet;
}

- (void) addRoundsObject:(Round*)value {
  NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.rounds];
  [tempSet addObject:value];
  self.rounds = tempSet;
}

- (void) insertObject:(Round *)value inRoundsAtIndex:(NSUInteger)idx {
  NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.rounds];
  [tempSet insertObject:value atIndex:idx];
  self.rounds = tempSet;
}

- (void)removeObjectFromRoundsAtIndex:(NSUInteger)idx {
  NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.rounds];
  Round* r = [tempSet objectAtIndex:idx];
  [tempSet removeObjectAtIndex:idx];
  self.rounds = tempSet;
  [self.managedObjectContext deleteObject:r];
  [self checkForGameOver];
}

@end