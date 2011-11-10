#import "TricksWonViewController.h"
#import "GameViewController.h"


@implementation TricksWonViewController

static NSString* ssBidVariationRegular = @"regular";
static NSString* ssBidVariationMisere = @"misére";
static NSString* ssBidVariationNoBid = @"no bid";
static int siMaximumTricks = 10;

// MARK: synthesize
@synthesize gameController;
@synthesize tricksWonTableView;
@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize scoreTeamOne;
@synthesize scoreTeamTwo;

@synthesize game;
@synthesize currentTeam;
@synthesize biddingTeams;
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
  [currentTeam release];
  [biddingTeams release];
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
  
  if ([self.bidVariation isEqualToString:ssBidVariationMisere]) {
    list = self.misereList;
  }
  else {
    list = self.regularList;
  }

  return list;
}

- (void) initWithGame:(Game*)g biddingTeams:(NSOrderedSet*)teams currentTeam:(Team *)t andBid:(NSString *)bid {
  self.game = g;
  self.biddingTeams = teams;
  self.currentTeam = t;
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
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  NSLog(@"self.bidVariation: %@", self.bidVariation);
  NSLog(@"[self tricksWonList: %@", [self tricksWonList]);
  
  self.nameTeamOne.text = [self.game nameForPosition:0];
  self.nameTeamTwo.text = [self.game nameForPosition:1];
  self.scoreTeamOne.text = [NSString stringWithFormat:@"%d pts", [[self.game scoreForPosition:0] intValue]];
  self.scoreTeamTwo.text = [NSString stringWithFormat:@"%d pts", [[self.game scoreForPosition:1] intValue]];
  [self.tricksWonTableView reloadData];
}


// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
	return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  return [NSString stringWithFormat:@"How many tricks did %@ win?", [self.currentTeam name]];
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
  
  if ([self.bidVariation isEqualToString:ssBidVariationMisere]) {
    tricksWon = indexPath.row;
  }
  else {
    tricksWon = (siMaximumTricks - indexPath.row);
  }

  score = [[BidType pointsForTeam:self.currentTeam biddingTeams:self.biddingTeams withHand:self.hand andTricksWon:[NSNumber numberWithInt:tricksWon]] intValue];
  
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
  
  if (![self.bidVariation isEqual:@"misére"]) {
    tricksWon = 10 - indexPath.row;
  }
  else {
    tricksWon = indexPath.row; 
  }
  
  NSMutableOrderedSet* tricksAndScores = [NSMutableOrderedSet orderedSetWithObjects:nil];

  for (Team* t in self.game.teams) {
    int tricks = tricksWon;
    NSNumber* score = nil;

    if (![self.currentTeam isEqual:t]) {
      tricks = 10 - tricksWon;
    }

    score = [BidType pointsForTeam:t biddingTeams:self.biddingTeams withHand:self.hand andTricksWon:[NSNumber numberWithInt:tricks]];
    
    NSDictionary* someTricksAndScores = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:tricks], @"tricksWon", score, @"score", nil];
    [tricksAndScores addObject:someTricksAndScores];
  }

  [self.game buildRoundWithBiddingTeams:self.biddingTeams hand:self.hand andTricksAndScoreDict:(NSOrderedSet*)tricksAndScores];

  UINavigationController *navController = self.navigationController;
  [navController popViewControllerAnimated:NO];
  if (![self.bidVariation isEqual:ssBidVariationNoBid]) {
    [navController popViewControllerAnimated:NO];
  }
  [navController popViewControllerAnimated:YES];
}

@end
