#import <UIKit/UIKit.h>
#import "GameListViewController.h"

@interface ScoreFiveHundredAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow* window;
  
  IBOutlet UINavigationController* navigationController;
  
  IBOutlet GameListViewController* gameListController;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;

@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;

@property (nonatomic, retain) IBOutlet GameListViewController* gameListController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void) saveContext;

@end