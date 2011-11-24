#import "Game.h"
#import "Round.h"
#import "RoundScore.h"
#import "Setting.h"
#import "Team.h"

@interface Game()
- (BOOL) guardForRoundIndex:(NSUInteger)ix;
- (NSString*) scoreForPosition:(NSUInteger)pos andIndex:(NSUInteger)ix;
@end

@implementation Game

@dynamic complete;
@dynamic id;
@dynamic lastPlayed;
@dynamic rounds;
@dynamic teams;
@dynamic winningTeam;
@dynamic setting;

- (NSNumber*) isComplete {
  return [NSNumber numberWithBool:(self.winningTeam != nil)];
}

- (NSString*) nameForPosition:(NSUInteger)pos {
  if ([self.teams count] > pos) {
    return [[self.teams objectAtIndex:pos] name];
  }

  return nil;
}

- (NSString*) scoreForPosition:(NSUInteger)pos {
  return [self scoreForPosition:pos andIndex:0];
}

- (NSString*) oldScoreForPosition:(NSUInteger)pos {
  return [self scoreForPosition:pos andIndex:1];
}

- (BOOL) isVictorInPosition:(NSUInteger)pos {
  if (self.winningTeam == nil) {
    return false;
  }
  else {
    return [self nameForPosition:pos] == self.winningTeam.name;
  }
}

- (Round*) buildRound {
  [self.managedObjectContext.undoManager beginUndoGrouping];
  [self.managedObjectContext.undoManager setActionName:@"new round"];
  Round* r = [NSEntityDescription insertNewObjectForEntityForName:@"Round" inManagedObjectContext:self.managedObjectContext];
  [self insertObject:r inRoundsAtIndex:0];

  for (Team* t in self.teams) {
    RoundScore* rs = [NSEntityDescription insertNewObjectForEntityForName:@"RoundScore" inManagedObjectContext:self.managedObjectContext];
    rs.round = r;
    rs.team = t;
    [r addScoresObject:rs];
  }

  [r updateAndSetTricksWon:10 forPosition:0];
  
  return r;
}

- (void) finaliseRound {
  if ([self.managedObjectContext.undoManager.undoActionName isEqualToString:@"new round"]) {
    [self.managedObjectContext.undoManager endUndoGrouping];
    [self.managedObjectContext.undoManager setActionName:@""];
    self.lastPlayed = [NSDate date];

    [self checkForGameOver];
    [self save];
  }
}

- (void) setTeamsByNames:(NSMutableOrderedSet*)names {
  for (NSString* name in names) {
    Team* t = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.managedObjectContext];
    t.name = name;
    [self addTeamsObject:t];
  }
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

// MARK: hidden
- (BOOL) guardForRoundIndex:(NSUInteger)ix {
  return (self.rounds == nil || [self.rounds count] <= ix);
}

- (NSString*) scoreForPosition:(NSUInteger)pos andIndex:(NSUInteger)ix {
  if ([self guardForRoundIndex:ix]) {
    return nil;
  }
  
  return [[self.rounds objectAtIndex:ix] scoreForPosition:pos];
}

@end