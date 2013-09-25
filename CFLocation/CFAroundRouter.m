//
//  CFAroundRouter.m
//  CFAround
//
//  Created by Selim Bakdemir on 29.05.13.
//  Copyright (c) 2013 Concept Factory. All rights reserved.
//

#import "CFAroundRouter.h"

@implementation CFAroundRouter

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D)t
{
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
    
    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    //NSLog(@"api url: %@", apiUrl);
    NSError* error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSASCIIStringEncoding error:&error];
    NSString *encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
    return [self decodePolyLine:[encodedPoints mutableCopy]];
}

@end
