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
    NSDate *currentDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    NSString *localDateString = [dateFormatter stringFromDate:currentDate];
        NSLog(localDateString);
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    [_motionManager startAccelerometerUpdates];
}
- (void)update:(CCTime)delta {
    if (slapped)
    {
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
        NSLog(@"%f",acceleration.z);
        if(acceleration.z>1.0)
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

    NSLog(@"working");

    
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        NSLog(@"shook");
    }
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
@end

