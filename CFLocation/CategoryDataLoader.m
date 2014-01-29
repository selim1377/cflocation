//
//  CategoryDataLoader.m
//  GoThere
//
//  Created by Johannes Lumpe on 19.01.12.
//  Copyright (c) 2012 Conceptfactory. All rights reserved.
//

#import "CategoryDataLoader.h"
#import "Config.h"


@implementation CategoryDataLoader

@synthesize received = _received;
@synthesize delegate = _delegate;
@synthesize proxyView = _proxyView;
@synthesize theConnection = _theConnection;

- (id) init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)loadDataForSearchTerm:(NSString *)searchTerm WithStart:(int)start aroundLocation:(CLLocation *)location
{
    
    if (self.theConnection) {
        [self.theConnection cancel];
    }
    
    Config * cfg = [Config sharedInstance];
	NSString *userPos = @"";
	if (location) {
		userPos = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
	}
    

    NSString *urlString = [NSString stringWithFormat:[[cfg configData] objectForKey:@"poiRequestURL"],searchTerm,start,userPos,@"0.10000,0.10000",[cfg.uiLanguage lowercaseString]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[cfg.configData objectForKey:@"poiRequestUserAgent"] forHTTPHeaderField:@"User-Agent"];
    self.theConnection = [NSURLConnection connectionWithRequest:request delegate:self];    

}

- (void)loadDataOnlyForSearchTerm:(NSString *)searchTerm WithStart:(int)start aroundLocation:(CLLocation *)location
{   
    
    Config * cfg = [Config sharedInstance];
	NSString *userPos = @"";
		
    NSString *urlString = [NSString stringWithFormat:[[cfg configData] objectForKey:@"poiRequestURL"],searchTerm,start,userPos,@"0.50000,0.50000",[cfg.uiLanguage lowercaseString]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * url = [NSURL URLWithString:urlString];
    //NSURL * url = [NSURL URLWithString:[[NSString stringWithFormat:cfg.webserviceUrl,searchTerm,userPos] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[cfg.configData objectForKey:@"poiRequestUserAgent"] forHTTPHeaderField:@"User-Agent"];
    self.theConnection = [NSURLConnection connectionWithRequest:request delegate:self];    
	
}

#pragma mark - data processing

- (void) prepareData
{
    NSError * error;
    NSString * response = [[[NSString alloc] initWithData:_received encoding:NSUTF8StringEncoding] autorelease];

    NSString * js = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jsonfix" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    
    NSString * stringWithJs = [js stringByAppendingString:response];
    
    self.proxyView = [[[UIWebView alloc] init] autorelease];
    _proxyView.delegate = self;
    _proxyView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [_proxyView loadHTMLString:stringWithJs baseURL:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString * json = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    if ([_delegate respondsToSelector:@selector(dataHasBeenLoaded:)])
    {
       // NSLog(@"notifying delegate of data");
        
        NSMutableArray *arr = (NSMutableArray *)[json JSONValue];
        NSMutableArray *result = [NSMutableArray new] ;
        for (NSMutableDictionary *item in arr) {
            
            POI *poi = [[POI alloc] initWithDictionary:item];
            [result addObject:poi];
        }
        
        [_delegate dataHasBeenLoaded:result];
    }
     
    
}

#pragma mark - NSURLConnectionDataDelegate

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"i received a response my master");
    self.received = [[[NSMutableData alloc] init] autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"master, i received data. I will append it to the dataobject now");
    [_received appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"master, i gathered all information. we can terminate the connection now");
    [self prepareData];
    
    self.theConnection = nil;
}

#pragma mark - misc

-(void) dealloc
{
    //NSLog(@"deallocating category data loader");
    _delegate = nil;
    [_theConnection cancel];
    [_theConnection release];
    [_proxyView release];
    [_received release];
    
    [super dealloc];
}

@end
