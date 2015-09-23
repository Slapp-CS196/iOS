#import "MainScene.h"

@implementation MainScene
{
CCButton *locator;
CLLocationManager * locationManager;
    CLGeocoder*geocoder;
    CLPlacemark*placemark;
    CCLabelTTF *longitude;
CCLabelTTF *lat;
}

- (void)onEnter
{
    [super onEnter];
    NSLog(@"sup");
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];}

-(void)sendLocation
{
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    NSLog(theLocation);
    longitude.string = [NSString stringWithFormat:@"Longitude: %.8f", self.locationManager.location.coordinate.longitude];
    lat.string = [NSString stringWithFormat:@"Latitude: %.8f", self.locationManager.location.coordinate.latitude];        NSLog(theLocation);
  

    NSLog(@"working");

    
}

-(void)motionEnded: (UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion==UIEventSubtypeMotionShake)
    {
        [self sendLocation];
    }
}
@end

