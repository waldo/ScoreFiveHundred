#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Round, Setting, Team;

@interface Game : NSManagedObject

@property (nonatomic, retain, getter = isComplete) NSNumber * complete;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSDate * lastPlayed;
@property (nonatomic, retain) NSOrderedSet *rounds;
@property (nonatomic, retain) NSOrderedSet *teams;
@property (nonatomic, retain) Team *winningTeam;
@property (nonatomic, retain) Setting *setting;

- (NSString*) nameForPosition:(int)pos;
- (NSString*) scoreForPosition:(int)pos;
- (BOOL) isVictorInPosition:(int)pos;
- (void) setTeamsByNames:(NSMutableOrderedSet*)names;
- (void) buildRoundWithBiddingTeams:(NSOrderedSet*)biddingTeams hand:(NSString*)h andTricksAndScoreDict:(NSOrderedSet*)tricksAndScore;
- (void) checkForGameOver;
- (Game*) duplicate;
- (void) save;

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
@end
