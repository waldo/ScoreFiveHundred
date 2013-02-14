#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Round, Setting, Team;

@interface Game : NSManagedObject

@property (getter = isComplete) NSNumber *complete;
@property NSString *id;
@property NSDate *lastPlayed;
@property NSOrderedSet *rounds;
@property NSOrderedSet *teams;
@property NSSet *winningTeams;
@property Setting *setting;

- (NSString *)nameForPosition:(NSUInteger)pos;
- (NSString *)scoreForTeam:(Team *)team;
- (NSString *)scoreForPosition:(NSUInteger)pos;
- (BOOL)isVictorInPosition:(NSUInteger)pos;
- (NSString *)teamNames:(NSSet *)teams;
- (Round *)buildRound;
- (void)finaliseRound;
- (void)undoRound;
- (Round *)latestCompleteRound;
- (Round *)currentRound;
- (void)setTeamsByNames:(NSMutableOrderedSet *)names;
- (void)checkForGameOver;
- (Game *)duplicate;
- (void)save;
- (void)undo;

+ (void)setManagedObjectContext:(NSManagedObjectContext *)moc;
+ (NSArray *)getAll;
+ (Game *)buildGame;
+ (void)deleteGame:(Game *)game;

@end

@interface Game (CoreDataGeneratedAccessors)

- (void)insertObject:(Round *)value inRoundsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRoundsAtIndex:(NSUInteger)idx;
- (void)insertRounds:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRoundsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRoundsAtIndex:(NSUInteger)idx withObject:(Round *)value;
- (void)replaceRoundsAtIndexes:(NSIndexSet *)indexes withRounds:(NSArray *)values;
- (void)addRoundsObject:(Round *)value;
- (void)removeRoundsObject:(Round *)value;
- (void)addRounds:(NSOrderedSet *)values;
- (void)removeRounds:(NSOrderedSet *)values;
- (void)insertObject:(Team *)value inTeamsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTeamsAtIndex:(NSUInteger)idx;
- (void)insertTeams:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTeamsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTeamsAtIndex:(NSUInteger)idx withObject:(Team *)value;
- (void)replaceTeamsAtIndexes:(NSIndexSet *)indexes withTeams:(NSArray *)values;
- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSOrderedSet *)values;
- (void)removeTeams:(NSOrderedSet *)values;
- (void)addWinningTeamsObject:(Team *)value;
- (void)removeWinningTeamsObject:(Team *)value;
- (void)addWinningTeams:(NSSet *)values;
- (void)removeWinningTeams:(NSSet *)values;

@end
