/**
* Private interface for unit testing.
*/

#import "MobileDeepLinking.h"
#import <UIKit/UIKit.h>

@interface MobileDeepLinking ()

- (NSDictionary *)getConfiguration:(NSError **)error;

- (void)routeToDefault;

- (void)handleRouteWithOptions:(NSDictionary *)routeOptions params:(NSDictionary *)routeParams storyboard:(NSString *)storyboardName;

- (BOOL)executeHandlers:(NSDictionary *)routeOptions routeParams:(NSDictionary *)routeParams;

- (id)buildViewController:(NSDictionary *)routeOptions storyboard:(NSString *)storyboardName;

- (BOOL)displayView:(NSDictionary *)routeOptions routeParams:(NSDictionary *)routeParams storyboard:(NSString *)storyboardName;

- (BOOL)matchDeeplink:(NSString *)route routeOptions:(NSDictionary *)routeOptions deeplink:(NSURL *)deeplink results:(NSMutableDictionary *)results error:(NSError **)error;

- (BOOL)matchPathParameters:(NSString *)route routeOptions:(NSDictionary *)routeOptions deeplink:(NSURL *)deeplink results:(NSMutableDictionary *)results error:(NSError **)error;

- (BOOL)matchQueryParameters:(NSString *)queryString routeOptions:(NSDictionary *)routeOptions result:(NSMutableDictionary *)routeParameterValues error:(NSError **)error;

- (NSDictionary *)getRequiredRouteParameterValues:(NSDictionary *)routeOptions;

- (BOOL)validateRouteComponent:(NSString *)routeComponent deeplink:(NSString *)deeplinkComponent routeOptions:(NSDictionary *)routeOptions;

- (NSURL *)trimDeeplink:(NSURL *)deeplink;

@end