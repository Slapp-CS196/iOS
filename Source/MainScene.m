#import "MainScene.h"
#import <CoreMotion/CoreMotion.h>
@implementation MainScene
{
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
}
-(void)captureSlap
{
    NSLog(@"slapping");
    [self schedule:@selector(determineIfSlaped) interval:0.4];
}
-(void)determineIfSlaped
{
    NSLog(@"test");
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
    NSString *localDateString = [dateFormatter stringFromDate:currentDate];
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
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    NSLog(theLocation);
    longitude.string = [NSString stringWithFormat:@"Longitude: %.8f", self.locationManager.location.coordinate.longitude];
    lat.string = [NSString stringWithFormat:@"Latitude: %.8f", self.locationManager.location.coordinate.latitude];
    slapped=true;
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
   initialAccel=acceleration.z;

    NSLog(@"working");

    
}
float kUpdateFrequency= 100.0;
float kFilteringFactor=0.1;
float accelZ;
int spikeZCount = 0;

////[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / kUpdateFrequency];
////[[UIAccelerometer sharedAccelerometer] setDelegate:self];
////
////- (void) accelerometer: (UIAccelerometer *) accelerometer didAccelerate: (UIAcceleration *) acceleration
////{
////    accelZ = acceleration.z - ( (acceleration.z * kFilteringFactor) + (accelZ * (1.0 - kFilteringFactor)) );
////    
////    if (accelZ > 0.0f)
////    {
////        if (spikeZCount > 9)
////        {
////            //  NSLog(@"SPIKE!");
////            [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
////            
////            [NSLog(@"BUMPED")];
////        }
////        else
////        {
////            spikeZCount++;
////            //  NSLog(@"spikeZCount %i",spikeZCount);
////        }
////    }
////    else
////    {
////        // NSLog(@"spikeZCount Reset");
////        spikeZCount = 0;
////    }
@end

