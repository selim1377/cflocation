//
//  Config.m
//  GoThere
//
//  Created by Johannes Lumpe on 18.01.12.
//  Copyright (c) 2012 Conceptfactory. All rights reserved.
//

#import "Config.h"

NSString *const kAppIdTomTom = @"326068192";


@implementation Config

@synthesize queryLang = _queryLang;
@synthesize actualRegion = _actualRegion;
@synthesize phoneLanguage = _phoneLanguage;
@synthesize uiLanguage = _uiLanguage;
@synthesize region = _region;
@synthesize regionLanguage = _regionLanguage;
@synthesize keyMap = _keyMap;
@synthesize webserviceUrl = _webserviceUrl;
@synthesize strings = _strings;
@synthesize locationManager = _locationManager;
@synthesize userLocation = _userLocation;
@synthesize userHeading = _userHeading;
@synthesize configData = _configData;
@synthesize networkAvailable;
@synthesize unitSystem;
@synthesize received = _received;
@synthesize preciseRegion = _preciseRegion;
@synthesize dbk = _dbk;

static Config *sharedInstance = nil;

+(Config *) sharedInstance
{
	if (!sharedInstance)
    {
		sharedInstance = [[Config alloc] init];
		
	}
	
	return sharedInstance;
}

-(void)startUpdateLocations
{
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
}

-(void)stopUpdateLocations
{
    [_locationManager stopUpdatingLocation];
    [_locationManager stopUpdatingHeading];
}

- (id) init
{
    self = [super init];
    if(self)
    {
        didInit = NO;
        unitSystem = TTTMetricSystem;
        
        self.dbk = @"Ravanelli";
       // self.userLocation = [[[CLLocation alloc] initWithLatitude:36.900215 longitude:30.672398] autorelease];
        /*
         * get the users location
         */
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDistanceFilter:1];
        [_locationManager setHeadingFilter:1];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        [_locationManager setDelegate:self];
                   
                
        NSString * locale = [[NSLocale currentLocale] localeIdentifier];
        NSArray * split = [locale componentsSeparatedByString:@"_"];
        self.regionLanguage = [[split objectAtIndex:0] lowercaseString];
        self.region = [[split objectAtIndex:1] lowercaseString];
        self.phoneLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];        
        
        //NSLog(@"region: %@ - regionlang: %@ - userlang: %@",_region,_regionLanguage,_phoneLanguage);
        
        self.uiLanguage = NSLocalizedString(@"en",@"language for user interface, defaults to en");
        
        //self.uiLanguage = @"en";
        // fixed query lang for now
        //self.queryLang = @"en";
        
        
        /*
         * create the keymap for remapping first letters of categories
         */
        _keyMap = [[NSMutableDictionary alloc] init];
        [_keyMap setObject:@"A" forKey:@"Ä"];
        [_keyMap setObject:@"O" forKey:@"Ö"];
        [_keyMap setObject:@"U" forKey:@"Ü"];
        
        [_keyMap setObject:@"E" forKey:@"É"];
        [_keyMap setObject:@"E" forKey:@"È"];        
        [_keyMap setObject:@"A" forKey:@"Á"];
        [_keyMap setObject:@"A" forKey:@"À"];
        [_keyMap setObject:@"O" forKey:@"Ó"];
        [_keyMap setObject:@"O" forKey:@"Ò"];        

        /*
         * Store all strings we need to localize in a dictionary, so we can later search for them in one place
         */
        
        _strings = [[NSMutableDictionary alloc] init];
        
        [_strings setObject:NSLocalizedString(@"Please select a category",@"initial display message") forKey:@"selectCategory"];
        [_strings setObject:NSLocalizedString(@"No results",@"Alertbox title for no results") forKey:@"titleNoResult"];
        [_strings setObject:NSLocalizedString(@"We could not find any results near you",@"Text for alertbox") forKey:@"messageNoResult"];
        [_strings setObject:NSLocalizedString(@"Ok",@"alertbox ok buton") forKey:@"alertViewOk"];
        [_strings setObject:NSLocalizedString(@"Detail",@"headline for detail controller") forKey:@"poiDetailControllerHeadline"];
        [_strings setObject:NSLocalizedString(@"Reviews for %@",@"headline for review controller") forKey:@"poiReviewsHeadline"];
        [_strings setObject:NSLocalizedString(@"Within %@",@"format for distance categories") forKey:@"poiListRangeHeadline"];
        [_strings setObject:NSLocalizedString(@"Initializing System,\nplease stand by",@"initial message displayed while loading the user location") forKey:@"displayLoadingMessage"];
        
        [_strings setObject:NSLocalizedString(@"Phone",@"label for poi phone property") forKey:@"detailHeadlinePhone"];
        [_strings setObject:NSLocalizedString(@"Address",@"label for poi address property") forKey:@"detailHeadlineAddress"];
        [_strings setObject:NSLocalizedString(@"Rating: %@",@"label for poi rating") forKey:@"detailTextRating"];
        [_strings setObject:NSLocalizedString(@"Homepage",@"label for poi homepage") forKey:@"detailHeadlineWeb"];
        [_strings setObject:NSLocalizedString(@"%d reviews",@"label for poi reviews") forKey:@"detailTextReviewCount"];
        
        [_strings setObject:NSLocalizedString(@"Explore the area",@"explore area button") forKey:@"detailButtonExplore"];
        [_strings setObject:NSLocalizedString(@"Add to contacts",@"add to contacts button") forKey:@"detailButtonAddToContacts"];        
        [_strings setObject:NSLocalizedString(@"Show map",@"show map button") forKey:@"detailButtonMap"];        
        [_strings setObject:NSLocalizedString(@"Show route",@"show route button") forKey:@"detailButtonRoute"];        

        [_strings setObject:NSLocalizedString(@"Cancel",@"actionsheet cancel button") forKey:@"cancelActionsheet"];
        [_strings setObject:NSLocalizedString(@"Add %@",@"'add to contacts' headline") forKey:@"addToContactsHeadline"];
        
        [_strings setObject:NSLocalizedString(@"show more",@"label for 'more reviews' button") forKey:@"moreReviews"];
        
        /*
         * navigation actionsheet related
         */
        [_strings setObject:NSLocalizedString(@"Show route in",@"navigation actionsheet headline") forKey:@"selectNavigationType"];
        [_strings setObject:[NSArray arrayWithObjects:NSLocalizedString(@"Maps",@"apple maps app name"),/*@"TomTom",*/ nil] forKey:@"navigationOptions"];
        /*
         * map actionsheet related
         */
        [_strings setObject:NSLocalizedString(@"Show position in",@"map actionsheet headline") forKey:@"selectMapType"];
        [_strings setObject:[NSArray arrayWithObjects:NSLocalizedString(@"Go There",@" Go there app name"),NSLocalizedString(@"Maps",@"apple maps app name"), nil] forKey:@"mapOptions"];        
        
        [_strings setObject:NSLocalizedString(@"Photos provided by Panoramio. Photos are under the copyright of their owners.",@"Panoramio copyright") forKey:@"panoramioCopyright"];
        
        [_strings setObject:NSLocalizedString(@"Panoramio detail page",@"label for panoramio detail page (external)") forKey:@"panoramioExternalLink"];
        
        [_strings setObject:NSLocalizedString(@"Select your action",@"actionsheet headline for explore area (geoimage)") forKey:@"exploreAreaActionsheet"];
        
        [_strings setObject:NSLocalizedString(@"Added by GoThere on %@", @"address book note") forKey:@"addedByGoThere"];
        
        [_strings setObject:NSLocalizedString(@"Area around %@", @"headline for explore area") forKey:@"exploreAreaHeadline"];
        
        [_strings setObject:NSLocalizedString(@"Favorites", @"headline for favorites") forKey:@"favoritesHeadline"];
        
        [_strings setObject:NSLocalizedString(@"Bağlantı Hatası",@"no network headline") forKey:@"noNetwork"];
        
        [_strings setObject:NSLocalizedString(@"Lütfen internet bağlantınızı kontrol ediniz",@"no network message") forKey:@"checkConnection"];
        
        /*
         * config data
         */
        
        _configData = [[NSMutableDictionary alloc] init];
        // query, start, coordinates, zoom
        [_configData setObject:@"http://maps.google.com/maps?q=%@&f=q&mrt=yp&output=js&start=%d&num=10&oe=UTF8&sll=%@&sspn=%@&filter=0&hl=%@" forKey:@"poiRequestURL"];
        
        
        // needs query and location
        [_configData setObject:@"https://maps.google.com/maps/suggest?output=json&q=%@&cp=10&hl=tr&gl=&v=2&clid=1&json=b&ll=%@&spn=0.033447,0.617294&src=1,2&num=5" forKey:@"poiSuggestUrl"];
        
        [_configData setObject:@"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A537a Safari/419.3" forKey:@"poiRequestUserAgent"];

        [_configData setObject:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50" forKey:@"poiDetailUserAgent"];
        [_configData setObject:@"http://maps.google.com/m/place?%@" forKey:@"poiDetailURL"];
        [_configData setObject:@"cid=%@" forKey:@"poiDetailURLParams"];        
        [_configData setObject:@"http://maps.google.com/m/place/ipd?mode=pp&ppmode=review&%@" forKey:@"poiReviewsURL"];
        [_configData setObject:@"cid=%@&start=%d" forKey:@"poiReviewsURLParams"];        
        

        // NAVIGATION URL SCHEMAS
        // latitude, longitude, name
        [_configData setObject:@"tomtomhome:geo:action=show&lat=%f&long=%f&name=%@" forKey:@"navigationTomTomLink"];
        
        // links to call apple maps app
        [_configData setObject:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@" forKey:@"navigationMapsLink"];
        [_configData setObject:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f" forKey:@"navigationMapsLinkPointToPoint"];

        [_configData setObject:@"http://maps.google.com/maps?ll=%f,%f&q=%@" forKey:@"navigationMapsShowLocationLink"];
        
        // review config
        NSDictionary * ratings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"msd1rh",
                                  [NSNumber numberWithFloat:1.5],@"o0g8lj",
                                  [NSNumber numberWithInt:2],@"fyc9vj",
                                  [NSNumber numberWithInt:2.5],@"ljiopr",
                                  [NSNumber numberWithInt:3],@"um7k4a",
                                  [NSNumber numberWithInt:3.5],@"ndnvqn",
                                  [NSNumber numberWithInt:4],@"h3uczs",
                                  [NSNumber numberWithInt:4.5],@"zy2f2o",
                                  [NSNumber numberWithInt:5],@"vckb3o",
                                  nil];
        [_configData setObject:ratings forKey:@"googleReviewRatings"];
        
        // explore area, PANORAMIO
        // longitude, latitude, longitude max, latitude max, size
        [_configData setObject:@"http://www.panoramio.com/map/get_panoramas.php?set=public&from=0&to=49&minx=%f&miny=%f&maxx=%f&maxy=%f&size=%@&mapfilter=true" forKey:@"panoramioAPIUrl"];
        
        
    }
    return self;
}

- (void) dealloc
{
    [_received release];
    [_configData release];
    [_userHeading release];
    [_userLocation release];
    
    [_strings release];
    [_keyMap release];
    [_locationManager release];
    
    [super dealloc];
}

#pragma mark - config functions
/*
- (void) detectCountry
{
    NSURL * lookUp = [NSURL URLWithString:@"http://gsp1.apple.com/pep/gcc"];
    NSURLRequest * request = [NSURLRequest requestWithURL:lookUp];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) getCountryFromResponse
{
    _actualRegion = [[NSString alloc] initWithData:_received encoding:NSUTF8StringEncoding];
    [received release];
    //_actualRegion = @"PT";
    if ([[CountrySQLiteManager sharedInstance] countForCountry:self.actualRegion] > 1)
    {
        [self detectPreciseRegion];
        return;
    }
    NSDictionary * lang = [[CountrySQLiteManager sharedInstance] getLanguageForCountry:self.actualRegion];
    // get the language if we have a database entry
    if ([lang objectForKey:@"language"])
    {
        self.queryLang = [lang objectForKey:@"language"];
    }
    else
    {
        // else we fall back to english
        self.queryLang = @"en";
    }

    NSLog(@"actual region: %@, query language: %@",_actualRegion,self.queryLang);
    didInit = YES;
    if ([_actualRegion isEqualToString:@"US"])
    {
        unitSystem = TTTImperialSystem;
    }

    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGoThereNotificationReceivedUserLocation object:self];
}
*/
/*
- (void) getRegionFromResponse
{
    BOOL found = NO;
    _preciseRegion = @"";
    NSString * data = [[NSString alloc] initWithData:_received encoding:NSUTF8StringEncoding];
    NSDictionary * result = [data JSONValue];

    if ([result objectForKey:@"results"])
    {
        NSArray * results = [result objectForKey:@"results"];
        for (NSDictionary * dict in results)
        {
            NSArray * comp = [dict objectForKey:@"address_components"];
            for (NSDictionary * comps in comp)
            {
                NSArray * types = [comps objectForKey:@"types"];
                for (NSString * type in types)
                {
                    if ([type isEqualToString:@"administrative_area_level_1"])
                    {
                        NSLog(@"precise region: %@",[comps objectForKey:@"short_name"]);
                        self.preciseRegion = [comps objectForKey:@"short_name"];
                        found = YES;
                    }
                    if (found) break;
                }
                if (found) break;
            }
            if (found) break;
        }
    }
    //[self determineSearchLanguage];
}
*/
/*
- (void) determineSearchLanguage
{
    NSDictionary * lang = [[CountrySQLiteManager sharedInstance] getLanguageForCountry:self.actualRegion AndRegion:self.preciseRegion];
    // get the language if we have a database entry
    if ([lang objectForKey:@"language"])
    {
        self.queryLang = [lang objectForKey:@"language"];
    }
    else
    {
        // else we fall back to english
        self.queryLang = @"en";
    }
    
    NSLog(@"actual region: %@, precise region: %@ query language: %@",_actualRegion,_preciseRegion,self.queryLang);
    didInit = YES;
    if ([_actualRegion isEqualToString:@"US"])
    {
        unitSystem = TTTImperialSystem;
    }
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGoThereNotificationReceivedUserLocation object:self];    
}
 */

- (void) detectPreciseRegion
{
    regionLookup = YES;
    
    //float lat,lon;
    //quebec, canada
    //lat = 52.536273;
    //lon = -73.015137;
    
    //fribourg, switzerland
    //lat = 46.801352;
    //lon = 7.144289;
    
    //lat = 51.219357;
    //lon = 4.402771;
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=true&language=en&latlng=%f,%f",self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude]];
    NSLog(@"%@",url);
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}



#pragma mark - NSURLConnectionDataDelegate

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"i received a response my master");
    self.received = [[[NSMutableData alloc] init] autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"master, i received data. I will append it to the dataobject now");
    [_received appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"master, i gathered all information. we can terminate the connection now");
    if (regionLookup)
    {
        //[self getRegionFromResponse];
    }
    else
    {
       // [self getCountryFromResponse];
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    //NSLog(@"new heading: %f",round(newHeading.trueHeading));
    self.userHeading = newHeading;
    [[NSNotificationCenter defaultCenter] postNotificationName:kGoThereNotificationHeadingUpdated object:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"got positiondata");
   
	self.userLocation = newLocation;
	
    [[NSNotificationCenter defaultCenter] postNotificationName:kGoThereNotificationNewPositionData object:self];
    
}




@end
