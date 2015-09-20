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

- (void)viewDidLoad
{
//    [super viewDidLoad
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc]init];
}

-(void)sendLocation
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    NSLog(@"working");

    
}

#pragma mark CCLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    NSLog(@"calling");
    if (currentLocation != nil) {
        NSString *longitudeLabel = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString* latitudeLabel = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSLog(longitudeLabel);
        NSLog(latitudeLabel);
    }
    
}


@end

