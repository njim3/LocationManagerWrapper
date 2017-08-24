//
//  Singleton.h
//  LocationManagerWrapper
//
//  Created by njim3 on 24/08/2017.
//  Copyright © 2017 cnbmsmart. All rights reserved.
//

#define SingleInterface(name) +(instancetype)share##name

#if __has_feature(objc_arc)
// ARC
#define SingleImplementation(name)  +(instancetype)share##name \
{                                                               \
return [[self alloc] init];                                 \
}                                                               \
static id _instance;                                            \
+ (instancetype)allocWithZone:(struct _NSZone *)zone            \
{                                                               \
static dispatch_once_t onceToken;                           \
dispatch_once(&onceToken, ^{                                \
_instance = [super allocWithZone:zone];                 \
});                                                         \
return _instance;                                           \
}                                                               \
- (id)copyWithZone:(NSZone *)zone                               \
{                                                               \
return self;                                                \
}                                                               \
- (id)mutableCopyWithZone:(NSZone *)zone                        \
{                                                               \
return self;                                                \
}

#else

// MRC
#define SingleImplementation(name)  +(instancetype)share##name  \
{                                                               \
return [[self alloc] init];                                 \
}                                                               \
static id _instance;                                            \
+ (instancetype)allocWithZone:(struct _NSZone *)zone            \
{                                                               \
static dispatch_once_t onceToken;                           \
dispatch_once(&onceToken, ^{                                \
_instance = [super allocWithZone:zone];                 \
});                                                         \
return _instance;                                           \
}                                                               \
- (id)copyWithZone:(NSZone *)zone                               \
{                                                               \
return self;                                                \
}                                                               \
- (id)mutableCopyWithZone:(NSZone *)zone                        \
{                                                               \
return self;                                                \
}                                                               \
- (oneway void)release                                          \
{}                                                              \
- (instancetype)retain                                          \
{                                                               \
return self;                                                \
}                                                               \
- (NSUInteger)retainCount                                       \
{                                                               \
return MAXFLOAT;                                            \
}
#endif
