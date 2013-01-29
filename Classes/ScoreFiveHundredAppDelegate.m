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

  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
  [self saveContext];
}

- (void) applicationWillTerminate:(UIApplication*)application {
  [self saveContext];
}

- (void) saveContext {
  NSError *err = nil;
  if (![self.managedObjectContext save:&err]) {
    NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
  }
}

// MARK: Core Data stack
- (NSManagedObjectContext*) managedObjectContext {
  if (__managedObjectContext != nil) {
    return __managedObjectContext;
  }
  
  NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];

  if (coordinator != nil) {
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  
  NSUndoManager* undoManager = [[[NSUndoManager alloc] init] autorelease];
  [__managedObjectContext setUndoManager:undoManager];
  
  return __managedObjectContext;
}

- (NSManagedObjectModel*) managedObjectModel {
  if (__managedObjectModel != nil) {
    return __managedObjectModel;
  }

  NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"GameModel" withExtension:@"momd"];
  __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

  return __managedObjectModel;
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator {
  if (__persistentStoreCoordinator != nil) {
    return __persistentStoreCoordinator;
  }
  
  NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"s500.sqlite"];
  
  NSError* err = nil;
  __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

  if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&err]) {
//    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
  }    
  
  return __persistentStoreCoordinator;
}

// MARK: Application's Documents directory
- (NSURL*) applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end