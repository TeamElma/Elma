import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? aboutMe;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final bool isServiceProvider;
  final String? fcmToken;
  final LocationModel? location;
  final int? totalBookingsMade;
  final int? totalReviewsWritten;
  final String? providerName;
  final String? providerBio;
  final List<String>? specialties;
  final LocationModel? providerLocation;
  final int? experienceMonths;
  final List<String>? portfolioImageUrls;
  final double? overallRating;
  final int? totalServiceReviews;
  final bool? isVerified;
  final String? phoneNumber;

  UserModel({
    required this.userId,
    this.email,
    this.displayName,
    this.photoUrl,
    this.aboutMe,
    this.createdAt,
    this.updatedAt,
    this.isServiceProvider = false,
    this.fcmToken,
    this.location,
    this.totalBookingsMade,
    this.totalReviewsWritten,
    this.providerName,
    this.providerBio,
    this.specialties,
    this.providerLocation,
    this.experienceMonths,
    this.portfolioImageUrls,
    this.overallRating,
    this.totalServiceReviews,
    this.isVerified,
    this.phoneNumber,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>; 
    return UserModel(
      userId: doc.id,
      email: data['email'] as String?,
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
      aboutMe: data['aboutMe'] as String?,
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
      isServiceProvider: data['isServiceProvider'] as bool? ?? false,
      fcmToken: data['fcmToken'] as String?,
      location: data['location'] != null 
          ? LocationModel.fromMap(data['location'] as Map<String, dynamic>)
          : null,
      totalBookingsMade: data['totalBookingsMade'] as int?,
      totalReviewsWritten: data['totalReviewsWritten'] as int?,
      providerName: data['providerName'] as String?,
      providerBio: data['providerBio'] as String?,
      specialties: (data['specialties'] as List<dynamic>?)?.map((e) => e as String).toList(),
      providerLocation: data['providerLocation'] != null
          ? LocationModel.fromMap(data['providerLocation'] as Map<String, dynamic>)
          : null,
      experienceMonths: data['experienceMonths'] as int?,
      portfolioImageUrls: (data['portfolioImageUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
      overallRating: (data['overallRating'] as num?)?.toDouble(),
      totalServiceReviews: data['totalServiceReviews'] as int?,
      isVerified: data['isVerified'] as bool?,
      phoneNumber: data['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'aboutMe': aboutMe,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isServiceProvider': isServiceProvider,
      if (fcmToken != null) 'fcmToken': fcmToken,
      if (location != null) 'location': location!.toMap(),
      if (totalBookingsMade != null) 'totalBookingsMade': totalBookingsMade,
      if (totalReviewsWritten != null) 'totalReviewsWritten': totalReviewsWritten,
      if (isServiceProvider) ...{
        if (providerName != null) 'providerName': providerName,
        if (providerBio != null) 'providerBio': providerBio,
        if (specialties != null) 'specialties': specialties,
        if (providerLocation != null) 'providerLocation': providerLocation!.toMap(),
        if (experienceMonths != null) 'experienceMonths': experienceMonths,
        if (portfolioImageUrls != null) 'portfolioImageUrls': portfolioImageUrls,
        if (overallRating != null) 'overallRating': overallRating,
        if (totalServiceReviews != null) 'totalServiceReviews': totalServiceReviews,
        if (isVerified != null) 'isVerified': isVerified,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      },
    };
  }
}

class LocationModel {
  final String? addressString;
  final String? city;
  final GeoPoint? geopoint;
  final String? country;
  final String? postalCode;

  LocationModel({
    this.addressString,
    this.city,
    this.geopoint,
    this.country,
    this.postalCode,
  });

  Map<String, dynamic> toMap() {
    return {
      if (addressString != null) 'addressString': addressString,
      if (city != null) 'city': city,
      if (geopoint != null) 'geopoint': geopoint,
      if (country != null) 'country': country,
      if (postalCode != null) 'postalCode': postalCode,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      addressString: map['addressString'] as String?,
      city: map['city'] as String?,
      geopoint: map['geopoint'] as GeoPoint?,
      country: map['country'] as String?,
      postalCode: map['postalCode'] as String?,
    );
  }
} 