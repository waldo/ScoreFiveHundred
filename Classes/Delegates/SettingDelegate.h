#import <Foundation/Foundation.h>

@protocol SettingDelegate <NSObject>

- (void)cancelSettingsForGame:(Game *)g fromController:(UIViewController *)controller;
- (void)applySettingsForGame:(Game *)g fromController:(UIViewController *)controller;

@end
