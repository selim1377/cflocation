//
//  Config.h
//  GoThere
//
//  Created by Johannes Lumpe on 18.01.12.
//  Copyright (c) 2012 Conceptfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NotificationConstants.h"
#import "TTTLocationFormatter.h"

typedef enum
{
    kNavigationTypeMaps = 0,
    kNavigationTypeTomTom
} NavigationTypes;

typedef enum
{
    kMapTypeInternal = 0,
    kMapTypeMaps
} MapTypes;

typedef enum
{
    kActionSheetTypeNavigation = 0,
    kActionSheetTypeMap
} ActionsheetTypes;

extern NSString *const kAppIdTomTom;

@interface Config : NSObject <CLLocationManagerDelegate>
{
    NSString * queryLang;
    NSString * actualRegion;
    NSString * preciseRegion;
    NSString * phoneLanguage;
    NSString * uiLanguage;
    NSString * region;
    NSString * regionLanguage;
    NSString * webserviceUrl;
    
    NSMutableDictionary * keyMap;
    NSMutableDictionary * strings;
    NSMutableDictionary * configData;
    
    CLLocationManager * locationManager;
    CLLocation * userLocation;
    CLHeading * userHeading;
    
    NSMutableData * received;

    BOOL didInit;
    BOOL networkAvailable;
    BOOL regionLookup;
    
    TTTLocationUnitSystem unitSystem;
    
    NSString * dbk;
    
}
@property (nonatomic,assign) TTTLocationUnitSystem unitSystem;
@property (nonatomic,retain) NSString * queryLang;
@property (nonatomic,retain) NSString * preciseRegion;
@property (nonatomic,retain) NSString * actualRegion;
@property (nonatomic,retain) NSString * phoneLanguage;
@property (nonatomic,retain) NSString * uiLanguage;
@property (nonatomic,retain) NSString * region;
@property (nonatomic,retain) NSString * regionLanguage;
@property (nonatomic,retain) NSString * webserviceUrl;

@property (nonatomic,retain) NSMutableDictionary * keyMap;
@property (nonatomic,retain) NSMutableDictionary * configData;
@property (nonatomic,readonly) NSMutableDictionary * strings;

@property (nonatomic,retain) CLLocationManager * locationManager;
@property (nonatomic,retain) CLLocation * userLocation;
@property (nonatomic,retain) CLHeading * userHeading;


@property (nonatomic,assign,readonly) BOOL networkAvailable;
@property (nonatomic,retain) NSMutableData * received;
@property (nonatomic,retain) NSString * dbk;

+(Config *)sharedInstance;     
//- (void) detectCountry;
- (void) detectPreciseRegion;
//- (void) determineSearchLanguage;

-(void)startUpdateLocations;
-(void)stopUpdateLocations;

@end