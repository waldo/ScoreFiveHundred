#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Round, RoundScore;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *games;
@property (nonatomic, retain) Game *gameWinner;
@property (nonatomic, retain) Round *roundBidder;
@property (nonatomic, retain) RoundScore *roundScores;
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
@end