#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Setting : NSManagedObject {

  NSOrderedSet* tournamentOptions;
  NSOrderedSet* modeOptions;  
  
}

@property (nonatomic, retain) NSString* mode;
@property (nonatomic, retain) NSNumber* tournament;
@property (nonatomic, retain) NSNumber* firstToCross;
@property (nonatomic, retain) NSNumber* nonBidderScoresTen;
@property (nonatomic, retain) NSNumber* noOneBid;
@property (nonatomic, retain) Game* game;

@property (nonatomic, retain) NSOrderedSet* tournamentOptions;
@property (nonatomic, retain) NSOrderedSet* modeOptions;

//- (void) initOptions;
- (void) setToMatch:(Setting*)recent;
- (NSString*) textForCurrentTournament;
- (NSString*) textForTournament:(NSUInteger)ix;
- (NSIndexPath*) indexPathOfCurrentMode;
- (NSInteger) numberOfTeams;
- (BOOL) isPlayOnNoOneBid;

@end
