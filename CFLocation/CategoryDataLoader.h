//
//  CategoryDataLoader.h
//  GoThere
//
//  Created by Johannes Lumpe on 19.01.12.
//  Copyright (c) 2012 Conceptfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "POI.h"


#define JSON_STRING @"<script type=\"text/javascript\"> function parseEntry(entry) { var obj = {}; obj.cid = entry.cid; obj.deleted = entry.ss.deleted; obj.countryCode = entry.sxcn; obj.city = entry.sxct; obj.zipCode = entry.sxpo; obj.street = entry.sxst; obj.streetNo = entry.sxsn; obj.state = entry.sxpr; var info = entry.infoWindow; obj.address = info.addressLines.join(\"\n\"); obj.phones = info.phones; if(info.hp) { if(info.hp.actual_url) { obj.url = info.hp.actual_url; } if(info.hp.domain) { obj.domain = info.hp.domain; } } obj.coordinate = entry.latlng; obj.rating = info.stars; obj.poiName = entry.name; obj.reviewCount = info.reviews; return obj; } window.parent = window; window.loadVPage = function(data) { var results = Array(); for(var obj in data.overlays.markers) { results.push(parseEntry(data.overlays.markers[obj])); } document.body.innerHTML = ""; document.body.innerHTML = JSON.stringify(results); } </script>"

@protocol CategoryDataLoaderDelegate <NSObject>
- (void) dataHasBeenLoaded:(id)data;
@end

@interface CategoryDataLoader : NSObject <UIWebViewDelegate>
{
    NSMutableData * received;
    id <CategoryDataLoaderDelegate> delegate;
    UIWebView * proxyView;
    NSURLConnection * theConnection;
}
@property(nonatomic,retain) NSURLConnection * theConnection;
@property(nonatomic,retain) UIWebView * proxyView;
@property(nonatomic,retain) NSMutableData * received;
@property(nonatomic,assign) id <CategoryDataLoaderDelegate> delegate;

- (void)loadDataForSearchTerm:(NSString*)searchTerm WithStart:(int)start aroundLocation:(CLLocation *)location;
- (void)loadDataOnlyForSearchTerm:(NSString*)searchTerm WithStart:(int)start aroundLocation:(CLLocation *)location;
- (void)prepareData;

@end
