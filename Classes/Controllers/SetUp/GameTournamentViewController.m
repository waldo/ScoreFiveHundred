#import "GameTournamentViewController.h"


@interface GameTournamentViewController ()

@property Setting *setting;
@property NSArray *tournamentOptions;

@end

@implementation GameTournamentViewController

#pragma mark Public

- (void)initWithSetting:(Setting *)s {
  self.setting = s;
  self.tournamentOptions = @[@0, @1, @2, @3, @4, @5, @10, @15, @20];
}

#pragma mark View

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

#pragma mark Tableview delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

  if ([_tournamentOptions indexOfObject:_setting.tournament] == indexPath.row) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  _setting.tournament = _tournamentOptions[indexPath.row];

  [self.navigationController popViewControllerAnimated:YES];
}

@end
