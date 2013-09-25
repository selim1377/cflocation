//
//  UILabel+Geocoding.m
//  GeltaksiSurucu
//
//  Created by Selim Bakdemir on 20.08.13.
//  Copyright (c) 2013 Concept Factory. All rights reserved.
//

#import "UILabel+Geocoding.h"

@implementation UILabel (Geocoding)

-(void)findAddressOfLocation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    
    if ([geocoder isGeocoding])
        [geocoder cancelGeocode]; 
    
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        NSString *name = [placemark.addressDictionary valueForKey:@"Name"];
        NSString *city = [placemark.addressDictionary valueForKey:@"City"];
        NSString *street = [placemark.addressDictionary valueForKey:@"Street"];
        
        if (!street)
        {
            street = name;
        }
        
        if (city) {
            NSString *locatedAt = [NSString stringWithFormat:@"%@, %@ Mh.",street,city];
            self.text = locatedAt;
        }
    }];
}

-(void)findAddressOfLocation:(CLLocation *)location withLoadingText:(NSString *)loadingText
{
    self.text = loadingText;
    [self findAddressOfLocation:location];
    
}

@end
