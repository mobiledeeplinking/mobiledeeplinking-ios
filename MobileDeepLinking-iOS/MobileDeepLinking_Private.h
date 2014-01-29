/**
* Private interface for unit testing.
*/

#import "MobileDeepLinking.h"

@interface MobileDeepLinking ()

- (NSDictionary *)getConfiguration:(NSError **)error;

- (void)routeToDefault;

- (bool)handleRouteWithOptions:(NSDictionary *)routeOptions params:(NSDictionary *)routeParams storyboard:(NSString *)storyboardName error:(NSError **)error;

- (BOOL)executeHandlers:(NSDictionary *)routeOptions routeParams:(NSDictionary *)routeParams error:(NSError **)error;

- (id)buildViewController:(NSDictionary *)routeOptions storyboard:(NSString *)storyboardName;

- (BOOL)displayView:(NSDictionary *)routeOptions routeParams:(NSDictionary *)routeParams storyboard:(NSString *)storyboardName error:(NSError **)error;

- (BOOL)setPropertiesOnViewController:(UIViewController *)viewController routeParams:(NSDictionary *)routeParams;

- (BOOL)matchDeeplink:(NSString *)route routeOptions:(NSDictionary *)routeOptions deeplink:(NSURL *)deeplink results:(NSMutableDictionary *)results error:(NSError **)error;

- (BOOL)matchPathParameters:(NSString *)route routeOptions:(NSDictionary *)routeOptions deeplink:(NSURL *)deeplink results:(NSMutableDictionary *)results error:(NSError **)error;

- (BOOL)matchQueryParameters:(NSString *)queryString routeOptions:(NSDictionary *)routeOptions result:(NSMutableDictionary *)routeParameterValues error:(NSError **)error;

- (NSMutableDictionary *)getRequiredRouteParameterValues:(NSDictionary *)routeOptions;

- (BOOL)validateRouteComponent:(NSString *)name value:(NSString *)value routeOptions:(NSDictionary *)routeOptions;

- (BOOL)checkForRequiredRouteParameters:(NSDictionary *)routeOptions extractedResults:(NSDictionary *)results error:(NSError **)error;

- (NSURL *)trimDeeplink:(NSURL *)deeplink;

@end