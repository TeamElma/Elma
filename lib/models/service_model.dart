import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String serviceId;
  final String providerId;
  final String? providerName; // Denormalized
  final String? providerPhotoUrl; // Denormalized
  final String title;
  final String? description;
  final String category;
  final String? subCategory;
  final PriceInfoModel? priceInfo;
  final List<String>? imageUrls;
  final ServiceLocationModel? serviceLocation; // Can be different from provider's main location
  final String? availability; // e.g., "Mon-Fri, 9am-5pm" or structured data
  final double? averageRating; // Calculated
  final int? totalReviews; // Calculated field
  final List<String>? tags; // For search
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final bool isActive;
  final bool? providerIsVerified;
  final int? providerExperienceMonths;

  ServiceModel({
    required this.serviceId,
    required this.providerId,
    this.providerName,
    this.providerPhotoUrl,
    required this.title,
    this.description,
    required this.category,
    this.subCategory,
    this.priceInfo,
    this.imageUrls,
    this.serviceLocation,
    this.availability,
    this.averageRating,
    this.totalReviews,
    this.tags,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.providerIsVerified,
    this.providerExperienceMonths,
  });

  factory ServiceModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>; // Added ! for safety
    return ServiceModel(
      serviceId: doc.id,
      providerId: data['providerId'] as String,
      providerName: data['providerName'] as String?,
      providerPhotoUrl: data['providerPhotoUrl'] as String?,
      title: data['title'] as String,
      description: data['description'] as String?,
      category: data['category'] as String,
      subCategory: data['subCategory'] as String?,
      priceInfo: data['priceInfo'] != null
          ? PriceInfoModel.fromMap(data['priceInfo'] as Map<String, dynamic>)
          : null,
      imageUrls: (data['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
      serviceLocation: data['serviceLocation'] != null
          ? ServiceLocationModel.fromMap(data['serviceLocation'] as Map<String, dynamic>)
          : null,
      availability: data['availability'] as String?,
      averageRating: (data['averageRating'] as num?)?.toDouble(),
      totalReviews: data['totalReviews'] as int?,
      tags: (data['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
      isActive: data['isActive'] as bool? ?? true,
      providerIsVerified: data['providerIsVerified'] as bool?,
      providerExperienceMonths: data['providerExperienceMonths'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      if (providerName != null) 'providerName': providerName,
      if (providerPhotoUrl != null) 'providerPhotoUrl': providerPhotoUrl,
      'title': title,
      if (description != null) 'description': description,
      'category': category,
      if (subCategory != null) 'subCategory': subCategory,
      if (priceInfo != null) 'priceInfo': priceInfo!.toMap(),
      if (imageUrls != null) 'imageUrls': imageUrls,
      if (serviceLocation != null) 'serviceLocation': serviceLocation!.toMap(),
      if (availability != null) 'availability': availability,
      if (averageRating != null) 'averageRating': averageRating,
      if (totalReviews != null) 'totalReviews': totalReviews,
      if (tags != null) 'tags': tags,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(), // Always set on update
      'isActive': isActive,
      if (providerIsVerified != null) 'providerIsVerified': providerIsVerified,
      if (providerExperienceMonths != null) 'providerExperienceMonths': providerExperienceMonths,
    };
  }
}

class PriceInfoModel {
  final double amount;
  final String currency;
  final String basis; // e.g., "per hour", "fixed"

  PriceInfoModel({
    required this.amount,
    required this.currency,
    required this.basis,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': currency,
      'basis': basis,
    };
  }

  factory PriceInfoModel.fromMap(Map<String, dynamic> map) {
    return PriceInfoModel(
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      basis: map['basis'] as String,
    );
  }
}

// Using a generic LocationModel might be better if structure is identical to user_model's LocationModel
// For now, defining separately for potential distinct fields or future divergence.
class ServiceLocationModel {
  final String? addressString;
  final String? city;
  final GeoPoint? geopoint;
  final String? country;
  final String? postalCode;

  ServiceLocationModel({
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

  factory ServiceLocationModel.fromMap(Map<String, dynamic> map) {
    return ServiceLocationModel(
      addressString: map['addressString'] as String?,
      city: map['city'] as String?,
      geopoint: map['geopoint'] as GeoPoint?,
      country: map['country'] as String?,
      postalCode: map['postalCode'] as String?,
    );
  }
} 