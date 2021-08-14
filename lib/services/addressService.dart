import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';

class AddressService {

  AddressService._();
  factory AddressService() => _instance;
  static final AddressService _instance = AddressService._();
  var addresses = [];

  final places =
      GoogleMapsPlaces(apiKey: '<<== YOUR API KEY GOES HERE ==>>');


  /*
   * Get the Google Places suggestions for an address 
   */
  Future placesAutocomplete(place) async {
  
    var res = await places.autocomplete(place);
    if (res.isOkay) {
      for (var i = 0; i < res.predictions.length; i++) {
        addresses.add(res.predictions[i].description);
      }
      return addresses;
    } else {
      addresses[0] = "no response";
      return addresses;
    }

  }
  /*
   * Get the exact lat / lng from a give address  
   */
  Future geolocator(address) async {

    List<Placemark> place = await Geolocator().placemarkFromAddress(address);

    Placemark newPlace = place[0];
    String lat = newPlace.position.latitude.toString();
    String lng = newPlace.position.longitude.toString();

    var geolocation = [];
    geolocation.add(address);
    geolocation.add(lat);
    geolocation.add(lng);

    return geolocation;

  }
}
