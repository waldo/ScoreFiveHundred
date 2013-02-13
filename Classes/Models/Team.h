#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Round, RoundScore;

@interface Team : NSManagedObject

@property NSString *id;
@property NSString *name;
@property NSOrderedSet *games;
@property NSSet *gameWinners;
@property Round *roundBidder;
@property RoundScore *roundScores;

@end

@interface Team (CoreDataGeneratedAccessors)

- (void)insertObject:(Game *)value inGamesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromGamesAtIndex:(NSUInteger)idx;
- (void)insertGames:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeGamesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInGamesAtIndex:(NSUInteger)idx withObject:(Game *)value;
- (void)replaceGamesAtIndexes:(NSIndexSet *)indexes withGames:(NSArray *)values;
- (void)addGamesObject:(Game *)value;
- (void)removeGamesObject:(Game *)value;
- (void)addGames:(NSOrderedSet *)values;
- (void)removeGames:(NSOrderedSet *)values;
- (void)addGameWinnersObject:(Game *)value;
- (void)removeGameWinnersObject:(Game *)value;
- (void)addGameWinners:(NSSet *)values;
- (void)removeGameWinners:(NSSet *)values;

- (void)addRoundBidderObject:(Round *)value;
- (void)removeRoundBidderObject:(Round *)value;
- (void)addRoundBidder:(NSSet *)values;
- (void)removeRoundBidder:(NSSet *)values;

- (void)addRoundScoresObject:(RoundScore *)value;
- (void)removeRoundScoresObject:(RoundScore *)value;
- (void)addRoundScores:(NSSet *)values;
- (void)removeRoundScores:(NSSet *)values;

@end
