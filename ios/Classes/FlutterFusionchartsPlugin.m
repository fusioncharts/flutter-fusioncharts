#import "FlutterFusionchartsPlugin.h"
#if __has_include(<flutter_fusioncharts/flutter_fusioncharts-Swift.h>)
#import <flutter_fusioncharts/flutter_fusioncharts-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_fusioncharts-Swift.h"
#endif

@implementation FlutterFusionchartsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFusionchartsPlugin registerWithRegistrar:registrar];
}
@end
