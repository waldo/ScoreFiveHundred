#import "AppDelegate.h"


@interface AppDelegate ()

@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (readonly) NSManagedObjectModel *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end

@implementation AppDelegate

@synthesize
  managedObjectContext=_managedObjectContext,
  managedObjectModel=_managedObjectModel,
  persistentStoreCoordinator=_persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Game setManagedObjectContext:self.managedObjectContext];

  return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [self saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [self saveContext];
}

- (void)saveContext {
  NSError *err = nil;
  if (![self.managedObjectContext save:&err]) {
    NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
  }
}

#pragma mark Core Data stack
- (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  
  NSUndoManager *undoManager = [[NSUndoManager alloc] init];
  [_managedObjectContext setUndoManager:undoManager];
  
  return _managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }

  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GameModel" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"s500.sqlite"];
  
  NSError *err = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};

  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&err]) {
//    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
  }    
  
  return _persistentStoreCoordinator;
}

#pragma mark Application's Documents directory
- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
