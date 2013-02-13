#import "GameTournamentViewController.h"


@implementation GameTournamentViewController

- (void)initWithSetting:(Setting *)s {
  self.setting = s;
  self.tournamentOptions = @[@0, @1, @2, @3, @4, @5, @10, @15, @20];
}

// MARK: view
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// MARK: tableview delegate
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
