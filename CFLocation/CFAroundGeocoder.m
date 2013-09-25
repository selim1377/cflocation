//
//  CFAroundGeocoder.m
//  LocationTest
//
//  Created by Selim Bakdemir on 14.05.13.
//  Copyright (c) 2013 Concept Factory. All rights reserved.
//

#import "CFAroundGeocoder.h"
#define GOOGLE_GEOCODE_SERVICE @"http://maps.googleapis.com/maps/api/geocode/json"

@implementation CFAroundGeocoder

-(void)reverseGeocode:(CLLocationCoordinate2D)coodToGeocode completion:(completion)block
{
    
    self.completionBlock = block;
    
    NSString *urlString = [NSString stringWithFormat:@"%@?latlng=%f,%f&sensor=false",GOOGLE_GEOCODE_SERVICE,coodToGeocode.latitude,coodToGeocode.longitude];
    NSLog(@"%@",urlString);
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    self.theConnection = [NSURLConnection connectionWithRequest:request delegate:self]; 
}

-(NSString *)extractAddressFromData:(id)data
{
    NSMutableDictionary *d = (NSMutableDictionary *)data;
    NSMutableArray *results = [d objectForKey:@"results"];
    
    NSString *formatted_address = @"";
    
    if (results.count > 0) {
        NSMutableDictionary *result = [results objectAtIndex:0];
        formatted_address = [result objectForKey:@"formatted_address"];
    }
    
    return formatted_address;
}

#pragma mark - NSURLConnectionDataDelegate

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.received = [[[NSMutableData alloc] init] autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.received appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * response = [[[NSString alloc] initWithData:self.received encoding:NSUTF8StringEncoding] autorelease];
    id data = [response JSONValue];
    self.completionBlock(YES , data , self);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.completionBlock(NO , [error description] , self);
}


-(void)dealloc
{
    [_theConnection release];
    [_received release];
    [super dealloc];
}

@end
