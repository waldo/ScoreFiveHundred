#import "HighestBiddingTeamViewController.h"
#import "ScoreFiveHundredAppDelegate.h"


@implementation HighestBiddingTeamViewController

// MARK: static
static NSString* ssTitleTeam      = @"Team that won the bidding";
static NSString* ssTitleNoBid     = @"No-one bid - play a no-trumps round for 10 points per trick";

// MARK: synthesize
@synthesize biddingController;
@synthesize tricksWonController;
@synthesize teamSelectionTableView;
@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize scoreTeamOne;
@synthesize scoreTeamTwo;

@synthesize game;

- (void)dealloc {
  [biddingController release];
  [tricksWonController release];
  [teamSelectionTableView release];
  [nameTeamOne release];
  [nameTeamTwo release];
  [scoreTeamOne release];
  [scoreTeamTwo release];  

  [game release];
  
  [super dealloc];
}

- (void) initWithGame:(Game*)g {
  self.game = g;
}

- (NSString*) selectedTeam {
  return [self.game.teams objectAtIndex:self.teamSelectionTableView.indexPathForSelectedRow.row];
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Team that bid highest";
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.nameTeamOne.text = [self.game nameForPosition:0];
  self.nameTeamTwo.text = [self.game nameForPosition:1];
  self.scoreTeamOne.text = [NSString stringWithFormat:@"%d pts", [[self.game scoreForPosition:0] intValue]];
  self.scoreTeamTwo.text = [NSString stringWithFormat:@"%d pts", [[self.game scoreForPosition:1] intValue]];
  [self.teamSelectionTableView reloadData];
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {
  if ([self.game.setting isPlayOnNoOneBid]) {
    return 2;    
  }

  return 1;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return [self.game.teams count];
  }

  return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return ssTitleTeam;
  }
  
  return ssTitleNoBid;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString *TeamIdentifier = @"TeamSelection";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TeamIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TeamIdentifier] autorelease];
  }
  
  if (indexPath.section == 0) {
    cell.textLabel.text = [self.game nameForPosition:indexPath.row];
  }
  else {
    cell.textLabel.text = @"No bid";
  }

  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  if (indexPath.section == 0) {
    [self.biddingController initWithGame:self.game andTeam:[self.game.teams objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:self.biddingController animated:YES];
  }
  else {
    [self.tricksWonController initWithGame:self.game biddingTeams:nil currentTeam:[self.game.teams objectAtIndex:0] andBid:@"NB"];
    [self.navigationController pushViewController:self.tricksWonController animated:YES];
  }
}

@end