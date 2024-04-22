class LocationModel {
  final String description;
  final List<MatchedSubstring> matchedSubstrings;
  final String placeId;
  final String reference;
  final StructuredFormatting structuredFormatting;
  final List<Term> terms;
  final List<String> types;

  LocationModel({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      description: json['description'],
      matchedSubstrings: (json['matched_substrings'] as List)
          .map((item) => MatchedSubstring.fromJson(item))
          .toList(),
      placeId: json['place_id'],
      reference: json['reference'],
      structuredFormatting:
      StructuredFormatting.fromJson(json['structured_formatting']),
      terms: (json['terms'] as List).map((item) => Term.fromJson(item)).toList(),
      types: List<String>.from(json['types']),
    );
  }
}

class MatchedSubstring {
  final int length;
  final int offset;

  MatchedSubstring({required this.length, required this.offset});

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(
      length: json['length'],
      offset: json['offset'],
    );
  }
}

class StructuredFormatting {
  final String mainText;
  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String secondaryText;

  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'],
      mainTextMatchedSubstrings: (json['main_text_matched_substrings'] as List)
          .map((item) => MatchedSubstring.fromJson(item))
          .toList(),
      secondaryText: json['secondary_text'],
    );
  }
}

class Term {
  final int offset;
  final String value;

  Term({required this.offset,required  this.value});

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      offset: json['offset'],
      value: json['value'],
    );
  }
}



class PlaceDetails {
  final List<dynamic> htmlAttributions;
  final PlaceResult result;
  final String status;

  PlaceDetails({required this.htmlAttributions, required this.result, required this.status});

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      htmlAttributions: json['html_attributions'],
      result: PlaceResult.fromJson(json['result']),
      status: json['status'],
    );
  }
}

class PlaceResult {
  final List<AddressComponent> addressComponents;
  final String formattedAddress;
  final Geometry geometry;
  final String name;
  final String placeId;


  PlaceResult({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.name,
    required this.placeId,

  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    return PlaceResult(
      addressComponents: (json['address_components'] as List)
          .map((item) => AddressComponent.fromJson(item))
          .toList(),
      formattedAddress: json['formatted_address'],
      geometry: Geometry.fromJson(json['geometry']),
      name: json['name'],
      placeId: json['place_id'],
    );
  }
}

class AddressComponent {
  final String longName;
  final String shortName;
  final List<String> types;

  AddressComponent({required this.longName, required this.shortName, required this.types});

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longName: json['long_name'],
      shortName: json['short_name'],
      types: List<String>.from(json['types']),
    );
  }
}

class Geometry {
  final LocationData location;
  final Viewport viewport;

  Geometry({required this.location, required this.viewport});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: LocationData.fromJson(json['location']),
      viewport: Viewport.fromJson(json['viewport']),
    );
  }
}

class LocationData {
  final double lat;
  final double lng;

  LocationData({required this.lat, required this.lng});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Viewport {
  final LocationData northeast;
  final LocationData southwest;

  Viewport({required this.northeast, required this.southwest});

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: LocationData.fromJson(json['northeast']),
      southwest: LocationData.fromJson(json['southwest']),
    );
  }
}

class OpeningHours {
  final bool openNow;
  final List<Period> periods;
  final List<String> weekdayText;

  OpeningHours({required this.openNow, required this.periods, required this.weekdayText});

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      openNow: json['open_now'],
      periods: (json['periods'] as List)
          .map((item) => Period.fromJson(item))
          .toList(),
      weekdayText: List<String>.from(json['weekday_text']),
    );
  }
}

class Period {
  final DayTime close;
  final DayTime open;

  Period({required this.close, required this.open});

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      close: DayTime.fromJson(json['close']),
      open: DayTime.fromJson(json['open']),
    );
  }
}

class DayTime {
  final int day;
  final String time;

  DayTime({required this.day, required this.time});

  factory DayTime.fromJson(Map<String, dynamic> json) {
    return DayTime(
      day: json['day'],
      time: json['time'],
    );
  }
}

class Photo {
  final int height;
  final List<String> htmlAttributions;
  final String photoReference;
  final int width;

  Photo({required this.height, required this.htmlAttributions, required this.photoReference, required this.width});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      height: json['height'],
      htmlAttributions: List<String>.from(json['html_attributions']),
      photoReference: json['photo_reference'],
      width: json['width'],
    );
  }
}

class PlusCode {
  final String compoundCode;
  final String globalCode;

  PlusCode({required this.compoundCode, required this.globalCode});

  factory PlusCode.fromJson(Map<String, dynamic> json) {
    return PlusCode(
      compoundCode: json['compound_code'],
      globalCode: json['global_code'],
    );
  }
}

class Review {
  final String authorName;
  final String authorUrl;
  final String language;
  final String profilePhotoUrl;
  final int rating;
  final String relativeTimeDescription;
  final String text;
  final int time;

  Review({
    required this.authorName,
    required this.authorUrl,
    required this.language,
    required this.profilePhotoUrl,
    required this.rating,
    required this.relativeTimeDescription,
    required this.text,
    required this.time,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      authorName: json['author_name'],
      authorUrl: json['author_url'],
      language: json['language'],
      profilePhotoUrl: json['profile_photo_url'],
      rating: json['rating'],
      relativeTimeDescription: json['relative_time_description'],
      text: json['text'],
      time: json['time'],
    );
  }
}

