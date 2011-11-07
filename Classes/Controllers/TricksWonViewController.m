#import "TricksWonViewController.h"
#import "GameViewController.h"


@implementation TricksWonViewController

static NSString* ssBidVariationRegular = @"regular";
static int siMaximumTricks = 10;

// MARK: synthesize
@synthesize gameController;
@synthesize tricksWonTableView;
@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize scoreTeamOne;
@synthesize scoreTeamTwo;

@synthesize game;
@synthesize biddingTeam;
@synthesize hand;
@synthesize bidVariation;
@synthesize regularList;
@synthesize misereList;


- (void) dealloc {
  [gameController release];
  [tricksWonTableView release];
  [nameTeamOne release];
  [nameTeamTwo release];
  [scoreTeamOne release];
  [scoreTeamTwo release];

  [game release];
  [biddingTeam release];
  [hand release];
  [bidVariation release];
  [regularList release];
  [misereList release];
  
  [super dealloc];
}

- (void) didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (NSArray*) tricksWonList {
  NSArray* list = nil;
  
  if (self.bidVariation == ssBidVariationRegular) {
    list = self.regularList;
  }
  else {
    list = self.misereList;
  }

  return list;
}

- (void) initWithGame:(Game*)g team:(Team *)t andBid:(NSString *)bid {
  self.game = g;
  self.biddingTeam = t;
  self.hand = bid;
  self.bidVariation = [BidType variation:self.hand];

  self.title = [BidType tricksAndDescriptionForHand:self.hand];
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];

  self.regularList = [NSArray arrayWithObjects:
                      @"10 tricks",
                      @"9 tricks",
                      @"8 tricks",
                      @"7 tricks",
                      @"6 tricks",
                      @"5 tricks",
                      @"4 tricks",
                      @"3 tricks",
                      @"2 tricks",
                      @"1 trick",
                      @"0 tricks", 
                      nil
                      ];
  
  self.misereList = [NSArray arrayWithObjects:
                     @"Won by losing every trick",
                     @"Got one or more tricks",
                     nil
                     ];

  self.nameTeamOne.text = [self.game nameForPosition:0];
  self.nameTeamTwo.text = [self.game nameForPosition:1];
  self.scoreTeamOne.text = [NSString stringWithFormat:@"%i pts", [self.game scoreForPosition:0]];
  self.scoreTeamTwo.text = [NSString stringWithFormat:@"%i pts", [self.game scoreForPosition:1]];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  NSLog(@"self.bidVariation: %@", self.bidVariation);
  NSLog(@"[self tricksWonList: %@", [self tricksWonList]);
  
  [self.tricksWonTableView reloadData];
}


// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
	return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  return [NSString stringWithFormat:@"How many tricks did %@ win?", [self.biddingTeam name]];
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self tricksWonList] count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellIdentifier = @"CellTricksWon";
  
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
  }

  int score = 0;
  int tricksWon = 0;
  
  if (self.bidVariation == ssBidVariationRegular) {
    tricksWon = (siMaximumTricks - indexPath.row);
  }
  else {
    tricksWon = indexPath.row;
  }

  score = [[BidType biddersPointsForHand:self.hand AndBiddersTricksWon:[NSNumber numberWithInt:tricksWon]] intValue];
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = [[self tricksWonList] objectAtIndex:indexPath.row];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%i pts", score];
  [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
  if (score > 0) {
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:53.0/255.0 green:102.0/255.0 blue:201.0/255.0 alpha:1.0]];
  }
  else {
    [cell.detailTextLabel setTextColor:[UIColor redColor]];
  }
  
  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  int tricksWon = 0;
  
  if (self.bidVariation == @"regular") {
    tricksWon = 10 - indexPath.row;
  }
  else {
    tricksWon = indexPath.row; 
  }

  NSNumber* teamOneTricksWon = nil;
  NSNumber* teamTwoTricksWon = nil;

  NSNumber* teamOneScore = nil;
  NSNumber* teamTwoScore = nil;
  
  if ([self.game.teams objectAtIndex:0] == self.biddingTeam) {
    teamOneTricksWon = [NSNumber numberWithInt:tricksWon];
    teamOneScore = [BidType biddersPointsForHand:self.hand AndBiddersTricksWon:teamOneTricksWon];
    teamTwoTricksWon = [NSNumber numberWithInt:(10 - tricksWon)];
    teamTwoScore = [BidType nonBiddersPointsForHand:self.hand AndBiddersTricksWon:teamOneTricksWon];
  }
  else {
    teamTwoTricksWon = [NSNumber numberWithInt:tricksWon];
    teamTwoScore = [BidType biddersPointsForHand:self.hand AndBiddersTricksWon:teamTwoTricksWon];
    teamOneTricksWon = [NSNumber numberWithInt:(10 - tricksWon)];
    teamOneScore = [BidType nonBiddersPointsForHand:self.hand AndBiddersTricksWon:teamTwoTricksWon];
  }

  NSDictionary* teamOneScores = [NSDictionary dictionaryWithObjectsAndKeys:teamOneTricksWon, @"tricksWon", teamOneScore, @"score", nil];
  NSDictionary* teamTwoScores = [NSDictionary dictionaryWithObjectsAndKeys:teamTwoTricksWon, @"tricksWon", teamTwoScore, @"score", nil];

  NSOrderedSet* tricksAndScore = [NSOrderedSet orderedSetWithObjects:teamOneScores, teamTwoScores, nil];
  
  [self.game buildRoundWithBiddingTeam:self.biddingTeam hand:self.hand andTricksAndScoreDict:(NSOrderedSet*)tricksAndScore];
  

  UINavigationController *navController = self.navigationController;
  [navController popViewControllerAnimated:NO];
  [navController popViewControllerAnimated:NO];
  [navController popViewControllerAnimated:YES];
}

@end
