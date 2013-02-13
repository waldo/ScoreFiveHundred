#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Team;

@interface Player : NSManagedObject

@property NSString *name;
@property Team *team;
@property NSSet *initialDealerForGame;

@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addInitialDealerForGameObject:(Game *)value;
- (void)removeInitialDealerForGameObject:(Game *)value;
- (void)addInitialDealerForGame:(NSSet *)values;
- (void)removeInitialDealerForGame:(NSSet *)values;

@end
