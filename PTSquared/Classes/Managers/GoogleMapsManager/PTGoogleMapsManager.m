//
//  SingletonMaps.m
//  
//
//  Created by Admin on 12.11.14.
//
//

#import "PTGoogleMapsManager.h"

@implementation PTGoogleMapsManager

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public

- (void)findMap:(GMSMapView*)mapView Latitube:(CLLocationDegrees)latitube Longitube:(CLLocationDegrees)longitube
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitube longitude:longitube zoom:16];
        
    mapView.camera = camera;
    mapView.mapType = kGMSTypeNormal;
    [mapView clear];
        
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitube, longitube);
    marker.appearAnimation = kGMSMarkerAnimationNone;
    marker.map = mapView;
}


- (void)geolocationLatitube:(CLLocationDegrees)latitube Longitube:(CLLocationDegrees)longitube locality:(localityBlock)locality
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitube longitude:longitube];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error) {
            NSLog(@"Error");
            return;
        }
        if(placemarks) {
            CLPlacemark *placemark = placemarks[0];
            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
            locality([lines componentsJoinedByString:@" "]);
        }
    }];
}


@end
