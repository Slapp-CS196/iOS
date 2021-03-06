#import "MainScene.h"
#import "NewUser.h"
#import <CoreMotion/CoreMotion.h>
@implementation MainScene
{
    CCTextField *newFullName;
    CCTextField *enteredUsername;
    CCTextField *enteredPassword;
    NSString *profileName;
    CCTextField * newUsername;
    CCTextField * newPassword;
     CMMotionManager *_motionManager;
CCButton *locator;
CLLocationManager * _locationManager;
    CLGeocoder*geocoder;
    CLPlacemark*placemark;
    CCLabelTTF *longitude;
CCLabelTTF *lat;
    CCButton *slapper;
    BOOL *slapped;
    double initialAccel;
    NSTimer *myTimer;
    NSTimer *yourTimer;
    CCLabelTTF *status;
    NSString *localDateString;

}
-(void)captureSlap
{
    status.string=[NSString stringWithFormat:@""];
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    NSLog(theLocation);
    longitude.string = [NSString stringWithFormat:@"%.8f", self.locationManager.location.coordinate.longitude];
    lat.string = [NSString stringWithFormat:@"%.8f", self.locationManager.location.coordinate.latitude];

    NSLog(@"slapping");
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    initialAccel=acceleration.z;

    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(determineIfSlaped) userInfo:nil repeats:YES];}

-(void)determineIfSlaped
{
    NSLog(@"test");
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    double currentAccel = acceleration.z;
    NSLog(@"%f",acceleration.z);
    if(fabs(currentAccel-initialAccel)>1)
    {
        NSLog(@"slapp activated");
        
        yourTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(determineBackSlap) userInfo:nil repeats:YES];
        [myTimer invalidate];
    }

        
    }

    

-(void)determineBackSlap
{
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration2 = accelerometerData.acceleration;
    double currentAccel2 = acceleration2.z;
    if((currentAccel2-initialAccel)>0)
    {
        NSLog(@"Actually slapped");
        status.string=[NSString stringWithFormat:@"Slap Detected!"];
        [yourTimer invalidate];
        NSString *url = [NSString stringWithFormat:@"https://api.slapp.xyz/api/new?user_id=briansbutthole&latitude=%@&longitude=%@&radius=20&time=%@",lat.string,longitude.string,localDateString];
        NSLog(url);
        NSURL *newURL = [NSURL URLWithString:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:newURL];
        [request setHTTPMethod:@"GET"];
               NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString *strData = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding ];
        NSLog(@"%@",strData);
        NSLog(@"done");

    
    }
}
-(id)init
{
    if (self = [super init])
    {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (void)onEnter
{
    
    [super onEnter];
    slapped=false;
    //getting timestamp in UTC
    NSDate *currentDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    localDateString = [dateFormatter stringFromDate:currentDate];
    NSLog(localDateString);
    //locationManager initilization
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    [_motionManager startAccelerometerUpdates];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations called");
    NSLog(@"%@", [locations lastObject]);
}
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
    NSLog(@"error%@",error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"user has denied to use current Location " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
           
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"unknown network error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
          
        }
            break;
    }
}



- (void)update:(CCTime)delta {
        if (slapped)
    {
        
        CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
        CMAcceleration acceleration = accelerometerData.acceleration;
        double currentAccel = acceleration.z;
            NSLog(@"%f",acceleration.z);
        if(fabs(currentAccel-initialAccel)>0.5)
        {
            NSLog(@"slapp activated");
            //generate timestamp or something
            
        }
        slapped=false;
    }
    
   
}

-(void)sendLocation
{
  NSString *url = [NSString stringWithFormat:@"https://api.slapp.xyz/api/new?user_id=briansbutthole&latitude=%@&longitude=%@&radius=20&time=%@",lat.string,longitude.string,localDateString];
    NSLog(url);
    NSURL *newURL = [NSURL URLWithString:url];
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:newURL];
  [request setHTTPMethod:@"GET"];
     NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *strData = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding ];
    NSLog(@"%@",strData);
    NSLog(@"done");
    
}


-(void)startSlappin
{
    SlapPage *newUse = (SlapPage *)[CCBReader loadAsScene:@"SlapPage"];
    [[CCDirector sharedDirector] replaceScene:newUse];
    
}
-(void)signUp
{
    CUser *cu = (CUser *)[CCBReader loadAsScene:@"CUser"];
    [self addChild:cu];
    [[CCDirector sharedDirector] replaceScene:cu];

}
///////////////////SIGNUP/////////////////

-(void)create
{
    NSLog(newUsername.string);
    if(![newUsername isEqual:@"NULL"]&&![newPassword isEqual:@"NULL"]&&![newFullName isEqual:@"NULL"])
    {
        profileName=newFullName.string;
    }
    
}






////////////////////LOGIN/////////////////
-(void)logIn
{
    if(![ enteredUsername isEqual:@"NULL"] && ![ enteredPassword isEqual:@"NULL"])
    {
        profileName=newUsername.string;
    }

}
@end

