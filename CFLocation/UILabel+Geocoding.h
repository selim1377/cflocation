//
//  UILabel+Geocoding.h
//  GeltaksiSurucu
//
//  Created by Selim Bakdemir on 20.08.13.
//  Copyright (c) 2013 Concept Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UILabel (Geocoding)

-(void)findAddressOfLocation:(CLLocation *)location;
-(void)findAddressOfLocation:(CLLocation *)location withLoadingText:(NSString *)loadingText;
@end
