//
//  POI.h
//  CFAround
//
//  Created by Selim Bakdemir on 13.05.13.
//  Copyright (c) 2013 Concept Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface POI : NSObject


@property (strong, nonatomic) CLLocation *poiLocation;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *shortAddress;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *cid;
@property (assign, nonatomic) CGFloat distance;


-(id)initWithDictionary:(NSMutableDictionary *)dictionary;
-(NSString *)distanceFromLocation:(CLLocation *)location;


@end
