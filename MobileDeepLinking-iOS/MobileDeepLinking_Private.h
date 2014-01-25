/**
* Private interface for unit testing.
*/

#import "MobileDeepLinking.h"
#import <UIKit/UIKit.h>

@interface MobileDeepLinking ()

- (NSDictionary *) getConfiguration;

- (void)handleRouteWithOptions:(NSDictionary *)routeOptions params:(NSDictionary *)routeParams storyboard:(NSString *)storyboardName;
- (NSDictionary *)getRouteParameterValuesWithRoute:(id)routeDefinition routeOptions:(NSDictionary *)routeOptions url:(NSURL *)customUrl;
- (id)buildViewControllerWithRouteOptions:(NSDictionary *)routeOptions storyboard:(NSString *) storyboardName;
- (BOOL)matchCustomUrlWithRoute:(NSString *)routeDefinition url: (NSURL *)customUrl;
- (void)routeToDefaultRoute;
- (NSURL *)getTrimmedCustomUrl:(NSURL *)customUrl;
- (NSDictionary *)getRequiredRouteParameterValuesFromRouteOptions:(NSDictionary *)routeOptions;
- (BOOL)parsePathParametersWithRouteDefinition:(NSString *)routeDefinition routeOptions:(NSDictionary *)routeOptions url:(NSURL *)customUrl intoDictionary:routeParameterValues error:(NSError **)error;
- (BOOL)parseQueryParameters:(NSString *)queryString routeOptions:(NSDictionary *)routeOptions intoDictionary:(NSMutableDictionary *)routeParameterValues  error:(NSError **)error;

@end