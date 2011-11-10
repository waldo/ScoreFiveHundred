#import "BidTypeTest.h"


@implementation BidTypeTest

@synthesize errorOut;
@synthesize moc;

- (void) setUp {
  self.errorOut = @"%@. %@, %@ tricks. Expected %@ pts. Got %@ pts.";
  
  NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  STAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
  self.moc = [[NSManagedObjectContext alloc] init];
  self.moc.persistentStoreCoordinator = psc;
  
  [mom release];
  [psc release];
}

- (void) tearDown {
  [errorOut release];
  [moc release];
}


- (void) checkForHand:(NSString*)hand withTeamOneTricksWon:(int)tricks teamOnePoints:(int)bidderExpectedPoints andTeamTwoPoints:(int)nonBidderExpectedPoints {
  Team* bidder = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.moc];
  Team* nonBidder = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.moc];
  NSOrderedSet* biddingTeams = [NSOrderedSet orderedSetWithObjects:bidder, nil];

  if ([hand isEqualToString:@"NB"]) {
    biddingTeams = [NSOrderedSet orderedSetWithObjects:nil];
  }

  NSNumber* bidderTricksWon = [NSNumber numberWithInt:tricks];
  NSNumber* nonBidderTricksWon = [NSNumber numberWithInt:(10 - tricks)];
  NSNumber* bidderPoints = [NSNumber numberWithInt:bidderExpectedPoints];
  NSNumber* nonBidderPoints = [NSNumber numberWithInt:nonBidderExpectedPoints];
  
  NSNumber* bidderResult = [BidType pointsForTeam:bidder biddingTeams:biddingTeams withHand:hand andTricksWon:bidderTricksWon];
  NSNumber* nonBidderResult = [BidType pointsForTeam:nonBidder biddingTeams:biddingTeams withHand:hand andTricksWon:nonBidderTricksWon];
  
  STAssertTrue(
               [bidderPoints isEqual:bidderResult],
               [NSString stringWithFormat:self.errorOut, @"bidder", hand, bidderTricksWon, bidderPoints, bidderResult]
               );
  STAssertTrue(
               [nonBidderPoints isEqual:nonBidderResult],
               [NSString stringWithFormat:self.errorOut, @"non-bidder", hand, nonBidderTricksWon, nonBidderPoints, nonBidderResult]
               );
}

- (void) testBiddersLose {
  [self checkForHand:@"CM" withTeamOneTricksWon:1 teamOnePoints:-250 andTeamTwoPoints:0];
  [self checkForHand:@"10H" withTeamOneTricksWon:7 teamOnePoints:-500 andTeamTwoPoints:30];
}

- (void) testBiddersWin {
  [self checkForHand:@"6S" withTeamOneTricksWon:6 teamOnePoints:40 andTeamTwoPoints:40];
  [self checkForHand:@"8NT" withTeamOneTricksWon:9 teamOnePoints:320 andTeamTwoPoints:10];
  [self checkForHand:@"OM" withTeamOneTricksWon:0 teamOnePoints:500 andTeamTwoPoints:0];
}

- (void) testBiddersSlam {
  // when bid lower than 250 pts
  [self checkForHand:@"7D" withTeamOneTricksWon:10 teamOnePoints:250 andTeamTwoPoints:0];

  // when bid higher than 250 pts
  [self checkForHand:@"9C" withTeamOneTricksWon:10 teamOnePoints:360 andTeamTwoPoints:0];
}

- (void) testNoBid {
  [self checkForHand:@"NB" withTeamOneTricksWon:7 teamOnePoints:70 andTeamTwoPoints:30];
}

@end
