#import "HighestBiddingTeamViewController.h"
#import "ScoreFiveHundredAppDelegate.h"


@implementation HighestBiddingTeamViewController

// MARK: synthesize
@synthesize biddingController;
@synthesize teamSelectionTableView;
@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize scoreTeamOne;
@synthesize scoreTeamTwo;

@synthesize game;

- (void)dealloc {
  [biddingController release];
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
  self.scoreTeamOne.text = [NSString stringWithFormat:@"%@ pts", [self.game scoreForPosition:0]];
  self.scoreTeamTwo.text = [NSString stringWithFormat:@"%@ pts", [self.game scoreForPosition:1]];
  [self.teamSelectionTableView reloadData];
}

// MARK: tableview delegate
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.game.teams count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString *TeamIdentifier = @"TeamSelection";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TeamIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TeamIdentifier] autorelease];
  }
  
  cell.textLabel.text = [self.game nameForPosition:indexPath.row];

  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  [self.biddingController initWithGame:self.game andTeam:[self.game.teams objectAtIndex:indexPath.row]];
  [self.navigationController pushViewController:self.biddingController animated:YES];
}

@end