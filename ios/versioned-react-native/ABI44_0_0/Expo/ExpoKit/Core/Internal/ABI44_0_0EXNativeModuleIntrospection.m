// Copyright 2015-present 650 Industries. All rights reserved.

#import "ABI44_0_0EXNativeModuleIntrospection.h"

#import <ABI44_0_0React/ABI44_0_0RCTBridge.h>
#import <ABI44_0_0React/ABI44_0_0RCTBridgeMethod.h>
#import <ABI44_0_0React/ABI44_0_0RCTModuleData.h>

@implementation ABI44_0_0EXNativeModuleIntrospection

@synthesize bridge = _bridge;

ABI44_0_0RCT_EXPORT_MODULE(ExpoNativeModuleIntrospection)

ABI44_0_0RCT_REMAP_METHOD(getNativeModuleNamesAsync,
                 nativeModuleNamesWithResolver:(ABI44_0_0RCTPromiseResolveBlock)resolve
                 rejecter:(ABI44_0_0RCTPromiseRejectBlock)reject) {
  NSError *error;
  NSDictionary<NSString *, ABI44_0_0RCTModuleData *> *moduleDataByName = [self _moduleDataFromBridge:&error];
  if (!moduleDataByName) {
    reject(error.domain, error.userInfo[NSLocalizedDescriptionKey], error);
    return;
  }

  NSArray<NSString *> *moduleNames = moduleDataByName.allKeys;
  resolve(moduleNames);
}

ABI44_0_0RCT_REMAP_METHOD(introspectNativeModuleAsync,
                 introspectNativeModule:(NSString *)name
                 resolver:(ABI44_0_0RCTPromiseResolveBlock)resolve
                 rejecter:(ABI44_0_0RCTPromiseRejectBlock)reject) {
  NSError *error;
  NSDictionary<NSString *, ABI44_0_0RCTModuleData *> *moduleDataByName = [self _moduleDataFromBridge:&error];
  if (!moduleDataByName) {
    reject(error.domain, error.userInfo[NSLocalizedDescriptionKey], error);
    return;
  }
  
  ABI44_0_0RCTModuleData *moduleData = moduleDataByName[name];
  if (!moduleData) {
    resolve(nil);
    return;
  }
  
  NSArray<id<ABI44_0_0RCTBridgeMethod>> *moduleMethods = moduleData.methods;
  NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *> *methodDescriptions = [NSMutableDictionary dictionaryWithCapacity:moduleMethods.count];
  for (id<ABI44_0_0RCTBridgeMethod> method in moduleMethods) {
    NSString *methodName = [NSString stringWithCString:method.JSMethodName encoding:NSASCIIStringEncoding];
    NSString *functionType = [NSString stringWithCString:ABI44_0_0RCTFunctionDescriptorFromType(method.functionType)
                                                encoding:NSASCIIStringEncoding];
    methodDescriptions[methodName] = @{ @"type": functionType };
  }

  resolve(@{ @"methods": methodDescriptions });
}

- (NSDictionary<NSString *, ABI44_0_0RCTModuleData *> *)_moduleDataFromBridge:(NSError **)error {
  ABI44_0_0RCTBridge *bridge = _bridge;
  if (![NSStringFromClass(bridge.class) isEqualToString:@"ABI44_0_0RCTCxxBridge"]) {
    if (error) {
      *error = [NSError errorWithDomain:@"E_NATIVEMODULEINTROSPECTION_INCOMPATIBLE_BRIDGE" code:0 userInfo:@{
         NSLocalizedDescriptionKey: @"Native module introspection is compatible only with the C++ bridge",
      }];
    }
    return nil;
  }
  
  NSDictionary<NSString *, ABI44_0_0RCTModuleData *> *moduleDataByName;
  @try {
    moduleDataByName = [bridge valueForKey:@"_moduleDataByName"];
  }
  @catch (NSException *e) {
    if (![e.name isEqualToString:NSUndefinedKeyException]) {
      @throw;
    }
    
    if (error) {
      NSString *variableName = e.userInfo[@"NSUnknownUserInfoKey"];
      *error = [NSError errorWithDomain:@"E_NATIVEMODULEINTROSPECTION_INCOMPATIBLE_BRIDGE" code:0 userInfo:@{
        NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Bridge does not define expected variable: %@", variableName],
      }];
    }
    return nil;
  }
  
  return moduleDataByName;
}

@end

