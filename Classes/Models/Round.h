#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, RoundScore, Team;

@interface Round : NSManagedObject

@property (nonatomic, retain) NSString * bid;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * ordinal;
@property (nonatomic, retain) Team *biddingTeam;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) NSOrderedSet *scores;

- (NSString*) bidForPosition:(int)pos;
- (NSString*) bidAchievedForPosition:(int)pos;
- (NSString*) scoreForPosition:(int)pos;
- (NSString*) tricksWonForPosition:(int)pos;

+ (NSString*) uniqueId;

@end

@interface Round (CoreDataGeneratedAccessors)

- (void)insertObject:(RoundScore *)value inScoresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromScoresAtIndex:(NSUInteger)idx;
- (void)insertScores:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeScoresAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInScoresAtIndex:(NSUInteger)idx withObject:(RoundScore *)value;
- (void)replaceScoresAtIndexes:(NSIndexSet *)indexes withScores:(NSArray *)values;
- (void)addScoresObject:(RoundScore *)value;
- (void)removeScoresObject:(RoundScore *)value;
- (void)addScores:(NSOrderedSet *)values;
- (void)removeScores:(NSOrderedSet *)values;
@end
