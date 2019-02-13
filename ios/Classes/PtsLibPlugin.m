#import "PtsLibPlugin.h"
#import <pts_lib/pts_lib-Swift.h>

@implementation PtsLibPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPtsLibPlugin registerWithRegistrar:registrar];
}
@end
