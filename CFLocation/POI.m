//
//  POI.m
//  CFAround
//
//  Created by Selim Bakdemir on 13.05.13.
//  Copyright (c) 2013 Concept Factory. All rights reserved.
//

#import "POI.h"
#import "TTTLocationFormatter.h"

@implementation POI

-(id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super init];
    if (self) {
                
        NSMutableDictionary *coord = [dictionary objectForKey:@"coordinate"];
        CGFloat lat = [[coord objectForKey:@"lat"] floatValue];
        CGFloat lng = [[coord objectForKey:@"lng"] floatValue];
        
        
        self.poiLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        self.name        = [dictionary objectForKey:@"poiName"];
        self.address     = [dictionary objectForKey:@"address"];
        self.cid         = [dictionary objectForKey:@"cid"];
        
        NSString *phone = @"-";
        
        NSMutableArray *phones = [dictionary objectForKey:@"phones"];
        if (phones) {
            if (phones.count > 0) {
                NSMutableDictionary *d = [phones objectAtIndex:0];
                phone = [d objectForKey:@"number"];
                //phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
        }
        
        self.phone = phone;
        
        NSArray *addressComponents = [self.address componentsSeparatedByString:@","];
        if (addressComponents.count > 0) {
            self.shortAddress =  [addressComponents objectAtIndex:0];
        }
        else
            self.shortAddress = self.address;
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.poiLocation  forKey:@"location"];
    [encoder encodeObject:self.name         forKey:@"name"];
    [encoder encodeObject:self.address      forKey:@"address"];
    [encoder encodeObject:self.cid          forKey:@"cid"];
    [encoder encodeObject:self.phone        forKey:@"phone"];
    [encoder encodeObject:self.shortAddress        forKey:@"shortAddress"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.poiLocation        = [decoder decodeObjectForKey:@"location"];
        self.name               = [decoder decodeObjectForKey:@"name"];
        self.address            = [decoder decodeObjectForKey:@"address"];
        self.cid                = [decoder decodeObjectForKey:@"cid"];
        self.phone              = [decoder decodeObjectForKey:@"phone"];
        self.shortAddress       = [decoder decodeObjectForKey:@"shortAddress"];
    }
    return self;
}

-(NSString *)distanceFromLocation:(CLLocation *)location
{
    TTTLocationFormatter *formatter = [[[TTTLocationFormatter alloc] init] autorelease];
    self.distance = [location distanceFromLocation:self.poiLocation];
    return [formatter stringFromDistanceFromLocation:location toLocation:self.poiLocation];
}



-(NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"%@ - %@",self.name , self.address];
    return desc;
}
-(void)dealloc
{
    [_shortAddress release];
    [_name release];
    [_address release];
    [_phone release];
    [_cid release];
    [_poiLocation release];
    [super dealloc];
}
@end
