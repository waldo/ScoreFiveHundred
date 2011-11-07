#import "ScoreFiveHundredAppDelegate.h"

@implementation ScoreFiveHundredAppDelegate

// MARK: synthesize
@synthesize window;
@synthesize navigationController;
@synthesize gameListController;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


- (void) dealloc {
  [window release];
  [navigationController release];
  [gameListController release];
  
  [super dealloc];
}

- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  self.gameListController.managedObjectContext = self.managedObjectContext;

  [self.window addSubview:[self.navigationController view]];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"applicationDidEnterBackground...");
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

- (void) applicationWillTerminate:(UIApplication*)application {
  NSLog(@"applicationWillTerminate...");
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

- (void) saveContext {
  NSError *error = nil;
  NSManagedObjectContext *moc = self.managedObjectContext;
  if (moc != nil) {
    if ([moc hasChanges] && ![moc save:&error]) {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}

//- (void) setUpComplete:(Game*)game {
//  
//}
//
//- (void) rematch:(Game*)originalGame {
//  // because we are pushing and popping the same view controller viewDisappear won't be called - thus we need to save first
////  [originalGame save];
////  [self.navigationController popViewControllerAnimated:NO];
////  [self.gameController rematchOfGameKey:originalGame.key];
////  [self.navigationController pushViewController:self.gameController animated:YES];
//}

//- (void) viewGameWithKey:(NSString*)key AndIsNewGame:(BOOL)newGame {
//  [self.gameController openGameWithKey:key isNewGame:newGame];
//  [self.navigationController pushViewController:self.gameController animated:YES];
//}

//- (void) addRoundForGameKey:(NSString *)key {
////  [self.navigationController pushViewController:self.highestBiddingTeamController animated:YES];
////
////  [self.highestBiddingTeamController initWithGameKey:key];
//}
//
//- (void) bidForTeamName:(NSString*)teamName {
//  [self.biddingController setTitleUsingTeamName:teamName];
//
//  [self.navigationController pushViewController:self.biddingController animated:YES];
//
//  self.biddingController.nameTeamOne.text = [self.gameController.game nameForPosition:0];
//  self.biddingController.nameTeamTwo.text = [self.gameController.game nameForPosition:1];
//  self.biddingController.scoreTeamOne.text = [NSString stringWithFormat:@"%i pts", [self.gameController.game scoreForPosition:0]];
//  self.biddingController.scoreTeamTwo.text = [NSString stringWithFormat:@"%i pts", [self.gameController.game scoreForPosition:1]];
//}
//
//- (void) bidSelected:(NSString*)hand forTeamName:(NSString*)teamName {
//  [self.tricksWonController styleWithHand:hand teamName:teamName];
//  
//  [self.navigationController pushViewController:self.tricksWonController animated:YES];
//
//  self.tricksWonController.nameTeamOne.text = [self.gameController.game nameForPosition:0];
//  self.tricksWonController.nameTeamTwo.text = [self.gameController.game nameForPosition:1];
//  self.tricksWonController.scoreTeamOne.text = [NSString stringWithFormat:@"%i pts", [self.gameController.game scoreForPosition:0]];
//  self.tricksWonController.scoreTeamTwo.text = [NSString stringWithFormat:@"%i pts", [self.gameController.game scoreForPosition:1]];  
//}
//
//- (void) saveScoreWithTricksWon:(NSInteger)tricksWon {
//  NSString* team = [self.highestBiddingTeamController selectedTeam];
//  NSString* hand = [self.biddingController hand];
//  NSNumber* tricks = [NSNumber numberWithInt:tricksWon];
//  
//  [self.gameController updateRoundWithTeam:team hand:hand tricksWon:tricks];
//  
//  [self.navigationController popViewControllerAnimated:NO];
//  [self.navigationController popViewControllerAnimated:NO];
//  [self.navigationController popViewControllerAnimated:YES];
//}

// MARK: Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext*) managedObjectContext
{
  if (__managedObjectContext != nil)
  {
    return __managedObjectContext;
  }
  
  NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil)
  {
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel*) managedObjectModel {
  if (__managedObjectModel != nil) {
    return __managedObjectModel;
  }
  NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"GameModel" withExtension:@"momd"];
  __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator*) persistentStoreCoordinator {
  if (__persistentStoreCoordinator != nil) {
    return __persistentStoreCoordinator;
  }
  
  NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"s500.sqlite"];
  
  NSError* error = nil;
  __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
     
     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.
     
     
     If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
     
     If you encounter schema incompatibility errors during development, you can reduce their frequency by:
     * Simply deleting the existing store:
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
     
     * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
     [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
     
     Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
     
     */
//    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  return __persistentStoreCoordinator;
}

// MARK: Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL*) applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end