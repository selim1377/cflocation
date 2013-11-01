//
//  Locater.h
//  GeltaksiSurucu
//
//  Created by Selim Bakdemir on 20.06.13.
//  Copyright (c) 2013 Concept Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocaterDelegate <NSObject>
-(void)didUpdateToLocation:(CLLocation *)newLocation;
@end
@interface Locater : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) NSMutableArray *eventListeners;

+(Locater *)shared;
-(void)addOnLocationChangeListener:(id)listener;
@end
 