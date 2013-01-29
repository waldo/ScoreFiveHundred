#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Team;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Team *team;
@property (nonatomic, retain) NSSet *initialDealerForGame;
@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addInitialDealerForGameObject:(Game *)value;
- (void)removeInitialDealerForGameObject:(Game *)value;
- (void)addInitialDealerForGame:(NSSet *)values;
- (void)removeInitialDealerForGame:(NSSet *)values;

@end
