#import "TricksWonViewController.h"


@implementation TricksWonViewController

#pragma mark Static

static int siMaximumTricks = 10;

#pragma mark Public

- (void)initWithGame:(Game *)g andTeam:(Team *)t {
  self.game = g;
  self.round = g.currentRound;
  self.team = t;

  self.title = [NSString stringWithFormat:@"%@", _team.name];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ScoreSummary"]) {
    [((ScoreMiniViewController *)segue.destinationViewController) initWithGame:_game];
  }
}

#pragma mark View

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.tableView reloadData];
}

#pragma mark Tableview delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
  int tricksWon = (siMaximumTricks - indexPath.row);
  int score = [BidType pointsForTeam:_team game:_game andTricksWon:tricksWon];
    
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%i pts", score];
  if (score < 0) {
    [cell.detailTextLabel setTextColor:[UIColor redColor]];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  int tricksWon = (siMaximumTricks - indexPath.row);

  [self.round setTricksWon:tricksWon forTeam:_team];
  [self.game finaliseRound];
  [self.delegate applyRoundForGame:_game fromController:self];
}

@end
