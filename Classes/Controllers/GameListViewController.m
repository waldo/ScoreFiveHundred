#import "GameListViewController.h"
#import "Game.h"
#import "Setting.h"


@implementation GameListViewController

- (void)loadGames {
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:_managedObjectContext];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  [request setIncludesSubentities:YES];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastPlayed" ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error;
  NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
  
  if ([mutableFetchResults count] > 0) {
    self.mostRecentGame = mutableFetchResults[0];
  }
  else {
    self.mostRecentGame = nil;
  }

  [self setGames:mutableFetchResults];

  [self.tableView reloadData];
}

- (void)fixOldGames {
  float oldVersion = 1.2f;
  float bundleVersion = [[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"] floatValue];
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

  if (![userDefaults valueForKey:@"version"]) {
    [userDefaults setFloat:bundleVersion forKey:@"version"];
  }
  else {
    oldVersion = [userDefaults floatForKey:@"version"];
    [userDefaults setFloat:bundleVersion forKey:@"version"];
  }
  
  if (oldVersion == 1.2f) {
    [self fixForVersion_1_2];
  }

  [self.tableView reloadData];
}

- (void)fixForVersion_1_2 {
  for (Game *game in self.games) {
    [game checkForGameOver];
    [game save];
  }
}

- (NSMutableArray *)gamesInProgress {
  NSPredicate *inProgress = [NSPredicate predicateWithFormat:@"winningTeams.@count == 0"];

  return [NSMutableArray arrayWithArray:[self.games filteredArrayUsingPredicate:inProgress]];
}

- (NSMutableArray *)gamesComplete {
  NSPredicate *complete = [NSPredicate predicateWithFormat:@"winningTeams.@count > 0"];
  
  return [NSMutableArray arrayWithArray:[self.games filteredArrayUsingPredicate:complete]];
}

- (Game *)gameForIndexPath:(NSIndexPath *)index {
  if (index.section == 0) {
    return (self.gamesInProgress)[index.row];
  }
  else if (index.section == 1) {
    return (self.gamesComplete)[index.row];
  }
  
  return nil;
}

- (id)valueForSection:(NSInteger)section valueInProgress:(id)valueInProgress valueCompleted:(id)valueCompleted {
  id val = nil;
  
  if ([self.gamesInProgress count] == 0 && [self.gamesComplete count] > 0) {
    val = valueCompleted;
  }
  else {
    if (section == 0) {
      val = valueInProgress;
    }
    else {
      val = valueCompleted;
    }
  }  
  
  return val;
}

// MARK: SettingDelegate
- (void)cancelSettingsForGame:(Game *)g fromController:(UIViewController *)controller {
  [g undo];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)applySettingsForGame:(Game *)g fromController:(UIViewController *)controller {
  [g save];
  [self dismissViewControllerAnimated:NO completion:nil];

  [self performSegueWithIdentifier:@"StartGame" sender:self];
}

// MARK: RematchDelegate
- (void)rematchForGame:(Game *)g fromController:(UIViewController *)controller {
  [self.navigationController popToViewController:self animated:NO];

  [g duplicate];
  [self loadGames];

  [self performSegueWithIdentifier:@"StartGame" sender:self];
}

// MARK: Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier rangeOfString:@"SetUp"].location == 0) {
    Game *g = [Game buildGameWithContext:_managedObjectContext];
    GameSetUpViewController *controller = [segue.destinationViewController viewControllers][0];
    [controller initWithGame:g mostRecentSettings:self.mostRecentGame.setting];
    controller.delegate = self;
  }
  else if ([segue.identifier isEqualToString:@"StartGame"]) {
    GameViewController* controller = segue.destinationViewController;
    [controller initWithGame:_mostRecentGame];
    controller.delegate = self;
  }
  else {
    GameViewController* controller = segue.destinationViewController;
    [controller initWithGame:[self gameForIndexPath:self.tableView.indexPathForSelectedRow]];
    controller.delegate = self;
  }
}

// MARK: View
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self loadGames];
  [self fixOldGames];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

// MARK: tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0 && [self.gamesInProgress count] > 0) {
    return @"In progress";
  }
  else if (section == 1 && [self.gamesComplete count] > 0) {
    return @"Complete";
  }

  return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return self.gamesInProgress.count;
  }
  else if (section == 1) {
    return self.gamesComplete.count;
  }
  
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Game"];
  Game *g = [self gameForIndexPath:indexPath];

  cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@) to %@ (%@)", [g nameForPosition:0], [g scoreForPosition:0], [g nameForPosition:1], [g scoreForPosition:1]];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self setEditing:NO animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [_managedObjectContext deleteObject:[self gameForIndexPath:indexPath]];
    NSError *err = nil;

    if (![_managedObjectContext save:&err]) {
      NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
    }

    [self loadGames];
  }
}

@end
