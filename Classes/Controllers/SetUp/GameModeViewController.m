#import "GameModeViewController.h"


@interface GameModeViewController ()

- (NSUInteger)indexFromIndexPath:(NSIndexPath *)path;

@end

@implementation GameModeViewController

#pragma mark Public

- (void)initWithSetting:(Setting *)s {
  self.setting = s;
}

#pragma mark Private

- (NSUInteger)indexFromIndexPath:(NSIndexPath *)path {
  return path.section * 1 + path.row;
}

#pragma mark View

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

#pragma mark Tableview delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

  if ([cell.textLabel.text isEqualToString:_setting.mode]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  long ix = [self indexFromIndexPath:indexPath];
  _setting.mode = _setting.modeOptions[ix];
  [_setting consistentForMode];

  [self.navigationController popViewControllerAnimated:YES];
}

@end
