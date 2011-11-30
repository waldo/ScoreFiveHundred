#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, RoundScore, Team;

@interface Round : NSManagedObject

@property (nonatomic, retain) NSString* bid;
@property (nonatomic, retain) NSString* id;
@property (nonatomic, retain) NSNumber* ordinal;
@property (nonatomic, retain) NSSet* biddingTeams;
@property (nonatomic, retain) Game* game;
@property (nonatomic, retain) NSOrderedSet* scores;

- (NSString*) bidForPosition:(NSUInteger)pos;
- (NSString*) bidAchievedForPosition:(NSUInteger)pos;
- (NSString*) scoreForPosition:(NSUInteger)pos;
- (NSString*) tricksWonForPosition:(NSUInteger)pos;

- (RoundScore*) getScoreForPosition:(NSUInteger)pos;
- (void) updateAndSetTricksWon:(NSUInteger)tricksWon forTeam:(Team*)t;

+ (NSString*) uniqueId;

@end

@interface Round (CoreDataGeneratedAccessors)

- (void)addBiddingTeamsObject:(Team*)value;
- (void)removeBiddingTeamsObject:(Team*)value;
- (void)addBiddingTeams:(NSSet*)values;
- (void)removeBiddingTeams:(NSSet*)values;

- (void)insertObject:(RoundScore*)value inScoresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromScoresAtIndex:(NSUInteger)idx;
- (void)insertScores:(NSArray*)value atIndexes:(NSIndexSet*)indexes;
- (void)removeScoresAtIndexes:(NSIndexSet*)indexes;
- (void)replaceObjectInScoresAtIndex:(NSUInteger)idx withObject:(RoundScore*)value;
- (void)replaceScoresAtIndexes:(NSIndexSet*)indexes withScores:(NSArray*)values;
- (void)addScoresObject:(RoundScore*)value;
- (void)removeScoresObject:(RoundScore*)value;
- (void)addScores:(NSOrderedSet*)values;
- (void)removeScores:(NSOrderedSet*)values;
@end
