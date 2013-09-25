//
//  CFAroundGeocoder.h
//  LocationTest
//
//  Created by Selim Bakdemir on 14.05.13.
//  Copyright (c) 2013 Concept Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



@interface CFAroundGeocoder : NSObject <NSURLConnectionDelegate>

typedef void(^completion)(BOOL success, id data, CFAroundGeocoder *geocoder);

@property (strong, nonatomic) NSURLConnection *theConnection;
@property (strong, nonatomic) NSMutableData *received;
@property (strong, nonatomic) completion completionBlock;

-(void)reverseGeocode:(CLLocationCoordinate2D)coodToGeocode completion:(completion)block;

//utility
-(NSString *)extractAddressFromData:(id)data;
@end
