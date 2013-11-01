//
//  Locater.m
//  GeltaksiSurucu
//
//  Created by Selim Bakdemir on 20.06.13.
//  Copyright (c) 2013 Concept Factory. All rights reserved.
//

#import "Locater.h"

static Locater *instance = nil;
@implementation Locater
+(Locater *)shared
{
    if (!instance) {
        
        instance = [Locater new];
    }
    
    return instance;
} 

-(id)init
{
    self = [super init];
    if (self)
    {
        self.manager = [[[CLLocationManager alloc] init] autorelease];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.manager.delegate = self;
        [self.manager startUpdatingLocation];
        
        self.eventListeners = [[NSMutableArray new] autorelease];
        
    }
    
    return self;
}

-(void)addOnLocationChangeListener:(id)listener
{
    [self.eventListeners addObject:listener];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    self.userLocation = newLocation;
    
    
    
    if(self.eventListeners.count > 0)
    {
        for (id<LocaterDelegate> listener in self.eventListeners) {
            
            if ([listener respondsToSelector:@selector(didUpdateToLocation:)]) {
                [listener performSelector:@selector(didUpdateToLocation:) withObject:newLocation];
            }
        }
    }
}

-(void)dealloc
{
    [_userLocation release];
    [_manager release];
    [super dealloc];
}

@end
