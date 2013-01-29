#import "BidTypeTest.h"


@implementation BidTypeTest

@synthesize errorOut;
@synthesize moc;
@synthesize settings;

- (void) setUp {
  self.errorOut = @"%@. %@, %d tricks. Expected %d pts. Got %d pts.";
  
  NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  STAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
  self.moc = [[NSManagedObjectContext alloc] init];
  self.moc.persistentStoreCoordinator = psc;

  Setting* defaultSetting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:self.moc];

  Setting* nonBidderScoresZeroSetting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:self.moc];
  nonBidderScoresZeroSetting.nonBidderScoresTen = @NO;

  Setting* noOneBidSetting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:self.moc];
  noOneBidSetting.noOneBid = @YES;

  Setting* quebecSetting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:self.moc];
  quebecSetting.mode = @"Quebec mode";

  self.settings = @{@"default": defaultSetting, @"non bidder scores zero": nonBidderScoresZeroSetting, @"no one bid": noOneBidSetting, @"quebec mode": quebecSetting};
}

- (void) tearDown {
}


- (void) checkWithSetting:(Setting*)setting forHand:(NSString*)hand withTeamOneTricksWon:(int)tricks teamOnePoints:(int)bidderExpectedPoints andTeamTwoPoints:(int)nonBidderExpectedPoints {
  Game* g = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:self.moc];
  Round* r = [NSEntityDescription insertNewObjectForEntityForName:@"Round" inManagedObjectContext:self.moc];
  Team* bidder = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.moc];
  Team* nonBidder = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.moc];

  g.setting = setting;
  r.bid = hand;
  if (![hand isEqualToString:@"NB"]) {
    [r addBiddingTeamsObject:bidder];
  }
  [g addTeamsObject:bidder];
  [g addTeamsObject:nonBidder];
  [g addRoundsObject:r];
  
  int bidderTricksWon = tricks;
  int nonBidderTricksWon = 10 - tricks;
  int bidderPoints = bidderExpectedPoints;
  int nonBidderPoints = nonBidderExpectedPoints;
  
  int bidderResult = [BidType pointsForTeam:bidder game:g andTricksWon:bidderTricksWon];
  int nonBidderResult = [BidType pointsForTeam:nonBidder game:g andTricksWon:nonBidderTricksWon];
  
  STAssertTrue(
               (bidderPoints == bidderResult),
               [NSString stringWithFormat:self.errorOut, @"bidder", hand, bidderTricksWon, bidderPoints, bidderResult]
               );
  STAssertTrue(
               (nonBidderPoints == nonBidderResult),
               [NSString stringWithFormat:self.errorOut, @"non-bidder", hand, nonBidderTricksWon, nonBidderPoints, nonBidderResult]
               );
}

- (void) testBiddersLose {
  [self checkWithSetting:(self.settings)[@"default"] forHand:@"CM" withTeamOneTricksWon:1 teamOnePoints:-250 andTeamTwoPoints:0];
  [self checkWithSetting:(self.settings)[@"default"] forHand:@"10H" withTeamOneTricksWon:7 teamOnePoints:-500 andTeamTwoPoints:30];
}

- (void) testBiddersWin {
  [self checkWithSetting:(self.settings)[@"default"] forHand:@"6S" withTeamOneTricksWon:6 teamOnePoints:40 andTeamTwoPoints:40];
  [self checkWithSetting:(self.settings)[@"default"] forHand:@"8NT" withTeamOneTricksWon:9 teamOnePoints:320 andTeamTwoPoints:10];
  [self checkWithSetting:(self.settings)[@"default"] forHand:@"OM" withTeamOneTricksWon:0 teamOnePoints:500 andTeamTwoPoints:0];
}

- (void) testBiddersSlam {
  // when bid lower than 250 pts
  [self checkWithSetting:(self.settings)[@"default"] forHand:@"7D" withTeamOneTricksWon:10 teamOnePoints:250 andTeamTwoPoints:0];

  // when bid higher than 250 pts
  [self checkWithSetting:(self.settings)[@"default"] forHand:@"9C" withTeamOneTricksWon:10 teamOnePoints:360 andTeamTwoPoints:0];
}

- (void) testNoBid {
  [self checkWithSetting:(self.settings)[@"no one bid"] forHand:@"NB" withTeamOneTricksWon:7 teamOnePoints:70 andTeamTwoPoints:30];
}

- (void) testNonBidderScoresZero {
  [self checkWithSetting:(self.settings)[@"non bidder scores zero"] forHand:@"7D" withTeamOneTricksWon:7 teamOnePoints:180 andTeamTwoPoints:0];
}

- (void) testQuebecMode {
  [self checkWithSetting:(self.settings)[@"quebec mode"] forHand:@"8S" withTeamOneTricksWon:8 teamOnePoints:240 andTeamTwoPoints:0];
  [self checkWithSetting:(self.settings)[@"quebec mode"] forHand:@"7NT" withTeamOneTricksWon:6 teamOnePoints:0 andTeamTwoPoints:220];
  [self checkWithSetting:(self.settings)[@"quebec mode"] forHand:@"CM" withTeamOneTricksWon:1 teamOnePoints:0 andTeamTwoPoints:500];
  [self checkWithSetting:(self.settings)[@"quebec mode"] forHand:@"OM" withTeamOneTricksWon:0 teamOnePoints:1000 andTeamTwoPoints:0];
}

@end
