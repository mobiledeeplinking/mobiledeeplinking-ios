/**
* Private interface for unit testing.
*/

#import "MobileDeepLinking.h"
#import <UIKit/UIKit.h>

@interface MobileDeepLinking ()

- (NSDictionary *)getConfiguration:(NSError **)error;

- (void)handleRouteWithOptions:(NSDictionary *)routeOptions params:(NSDictionary *)routeParams storyboard:(NSString *)storyboardName;

- (id)buildViewController:(NSDictionary *)routeOptions storyboard:(NSString *)storyboardName;

- (BOOL)matchDeeplink:(NSString *)route routeOptions:(NSDictionary *)routeOptions deeplink:(NSURL *)deeplink results:(NSMutableDictionary *)results error:(NSError **)error;

- (BOOL)matchPathParameters:(NSString *)route routeOptions:(NSDictionary *)routeOptions deeplink:(NSURL *)deeplink results:(NSMutableDictionary *)results error:(NSError **)error;

- (BOOL)validateRouteComponent:(NSString *)routeComponent deeplink:(NSString *)deeplinkComponent routeOptions:(NSDictionary *)routeOptions;

- (void)routeToDefault;

- (BOOL)executeHandlers:(NSDictionary *)routeOptions routeParams:(NSDictionary *)routeParams;

- (BOOL)displayView:(NSDictionary *)routeOptions routeParams:(NSDictionary *)routeParams storyboard:(NSString *)storyboardName;

- (NSURL *)trimDeeplink:(NSURL *)deeplink;

- (NSDictionary *)getRequiredRouteParameterValues:(NSDictionary *)routeOptions;

- (BOOL)matchQueryParameters:(NSString *)queryString routeOptions:(NSDictionary *)routeOptions intoDictionary:(NSMutableDictionary *)routeParameterValues error:(NSError **)error;

@end