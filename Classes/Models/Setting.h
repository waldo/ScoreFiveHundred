#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Setting : NSManagedObject

@property NSString *mode;
@property NSNumber *tournament;
@property NSNumber *firstToCross;
@property NSNumber *nonBidderScoresTen;
@property NSNumber *noOneBid;
@property NSNumber *onlySuccessfulDefendersScore;
@property NSNumber *capDefendersScore;
@property Game *game;
@property NSArray *modeOptions;

- (void)setToMatch:(Setting *)recent;
- (NSString *)textForCurrentTournament;
- (NSString *)textForTournament:(NSUInteger)ix;
- (NSInteger)numberOfTeams;
- (BOOL)isPlayOnNoOneBid;
- (void)consistentForMode;

@end
