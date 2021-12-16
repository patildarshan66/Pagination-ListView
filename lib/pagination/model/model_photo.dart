import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<ModelPhoto> modelPhotoFromJson(var map) =>
    List<ModelPhoto>.from(map.map((x) => ModelPhoto.fromJson(x)));

class ModelPhoto with ChangeNotifier {
  ModelPhoto({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.promotedAt,
    this.width,
    this.height,
    this.color,
    this.blurHash,
    this.description,
    this.altDescription,
    this.urls,
    this.links,
    this.categories,
    this.likes,
    this.likedByUser,
    this.currentUserCollections,
    this.sponsorship,
    this.topicSubmissions,
    this.user,
  });

  String id;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime promotedAt;
  int width;
  int height;
  String color;
  String blurHash;
  String description;
  String altDescription;
  Urls urls;
  ModelPhotoLinks links;
  List<dynamic> categories;
  int likes;
  bool likedByUser;
  List<dynamic> currentUserCollections;
  Sponsorship sponsorship;
  TopicSubmissions topicSubmissions;
  User user;

  factory ModelPhoto.fromJson(Map<String, dynamic> json) => ModelPhoto(
        id: json["id"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        promotedAt: json["promoted_at"] == null
            ? null
            : DateTime.parse(json["promoted_at"]),
        width: json["width"],
        height: json["height"],
        color: json["color"],
        blurHash: json["blur_hash"],
        description: json["description"],
        altDescription: json["alt_description"],
        urls: json["urls"] != null ? Urls.fromJson(json["urls"]) : null,
        links: json["links"] != null
            ? ModelPhotoLinks.fromJson(json["links"])
            : null,
        categories: json["categories"] != null
            ? List<dynamic>.from(json["categories"].map((x) => x))
            : null,
        likes: json["likes"],
        likedByUser: json["liked_by_user"],
        currentUserCollections: json["current_user_collections"] != null
            ? List<dynamic>.from(json["current_user_collections"].map((x) => x))
            : null,
        sponsorship: json["sponsorship"] == null
            ? null
            : Sponsorship.fromJson(json["sponsorship"]),
        topicSubmissions: json["topic_submissions"] != null
            ? TopicSubmissions.fromJson(json["topic_submissions"])
            : null,
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
      );
}

class ModelPhotoLinks {
  ModelPhotoLinks({
    this.self,
    this.html,
    this.download,
    this.downloadLocation,
  });

  String self;
  String html;
  String download;
  String downloadLocation;

  factory ModelPhotoLinks.fromJson(Map<String, dynamic> json) =>
      ModelPhotoLinks(
        self: json["self"],
        html: json["html"],
        download: json["download"],
        downloadLocation: json["download_location"],
      );
}

class Sponsorship {
  Sponsorship({
    this.impressionUrls,
    this.tagline,
    this.taglineUrl,
    this.sponsor,
  });

  List<String> impressionUrls;
  String tagline;
  String taglineUrl;
  User sponsor;

  factory Sponsorship.fromJson(Map<String, dynamic> json) => Sponsorship(
        impressionUrls:
        json["impression_urls"]!=null? List<String>.from(json["impression_urls"].map((x) => x)):null,
        tagline: json["tagline"],
        taglineUrl: json["tagline_url"],
        sponsor: json["sponsor"]!=null?User.fromJson(json["sponsor"]):null,
      );
}

class User {
  User({
    this.id,
    this.updatedAt,
    this.username,
    this.name,
    this.firstName,
    this.lastName,
    this.twitterUsername,
    this.portfolioUrl,
    this.bio,
    this.location,
    this.links,
    this.profileImage,
    this.instagramUsername,
    this.totalCollections,
    this.totalLikes,
    this.totalPhotos,
    this.acceptedTos,
    this.forHire,
    this.social,
  });

  String id;
  DateTime updatedAt;
  String username;
  String name;
  String firstName;
  String lastName;
  String twitterUsername;
  String portfolioUrl;
  String bio;
  String location;
  UserLinks links;
  ProfileImage profileImage;
  String instagramUsername;
  int totalCollections;
  int totalLikes;
  int totalPhotos;
  bool acceptedTos;
  bool forHire;
  Social social;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        updatedAt: json["updated_at"]!=null? DateTime.parse(json["updated_at"]):null,
        username: json["username"],
        name: json["name"],
        firstName: json["first_name"],
        lastName:  json["last_name"],
        twitterUsername:
             json["twitter_username"],
        portfolioUrl:
           json["portfolio_url"],
        bio: json["bio"],
        location:  json["location"],
        links: json["links"]!=null?UserLinks.fromJson(json["links"]):null,
        profileImage: json["profile_image"]!=null?ProfileImage.fromJson(json["profile_image"]):null,
        instagramUsername: json["instagram_username"] ,
        totalCollections: json["total_collections"],
        totalLikes: json["total_likes"],
        totalPhotos: json["total_photos"],
        acceptedTos: json["accepted_tos"],
        forHire: json["for_hire"],
        social: json["social"]!=null?Social.fromJson(json["social"]):null,
      );
}

class UserLinks {
  UserLinks({
    this.self,
    this.html,
    this.photos,
    this.likes,
    this.portfolio,
    this.following,
    this.followers,
  });

  String self;
  String html;
  String photos;
  String likes;
  String portfolio;
  String following;
  String followers;

  factory UserLinks.fromJson(Map<String, dynamic> json) => UserLinks(
        self: json["self"],
        html: json["html"],
        photos: json["photos"],
        likes: json["likes"],
        portfolio: json["portfolio"],
        following: json["following"],
        followers: json["followers"],
      );
}

class ProfileImage {
  ProfileImage({
    this.small,
    this.medium,
    this.large,
  });

  String small;
  String medium;
  String large;

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        small: json["small"],
        medium: json["medium"],
        large: json["large"],
      );
}

class Social {
  Social({
    this.instagramUsername,
    this.portfolioUrl,
    this.twitterUsername,
    this.paypalEmail,
  });

  String instagramUsername;
  String portfolioUrl;
  String twitterUsername;
  dynamic paypalEmail;

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        instagramUsername: json["instagram_username"],
        portfolioUrl: json["portfolio_url"],
        twitterUsername: json["twitter_username"],
        paypalEmail: json["paypal_email"],
      );

}

class TopicSubmissions {
  TopicSubmissions({
    this.technology,
    this.artsCulture,
    this.film,
    this.businessWork,
    this.texturesPatterns,
    this.history,
  });

  BusinessWork technology;
  ArtsCulture artsCulture;
  BusinessWork film;
  BusinessWork businessWork;
  ArtsCulture texturesPatterns;
  ArtsCulture history;

  factory TopicSubmissions.fromJson(Map<String, dynamic> json) =>
      TopicSubmissions(
        technology: json["technology"] == null
            ? null
            : BusinessWork.fromJson(json["technology"]),
        artsCulture: json["arts-culture"] == null
            ? null
            : ArtsCulture.fromJson(json["arts-culture"]),
        film: json["film"] == null ? null : BusinessWork.fromJson(json["film"]),
        businessWork: json["business-work"] == null
            ? null
            : BusinessWork.fromJson(json["business-work"]),
        texturesPatterns: json["textures-patterns"] == null
            ? null
            : ArtsCulture.fromJson(json["textures-patterns"]),
        history: json["history"] == null
            ? null
            : ArtsCulture.fromJson(json["history"]),
      );
}

class ArtsCulture {
  ArtsCulture({
    this.status,
  });

  String status;

  factory ArtsCulture.fromJson(Map<String, dynamic> json) => ArtsCulture(
        status: json["status"],
      );
}

class BusinessWork {
  BusinessWork({
    this.status,
    this.approvedOn,
  });

  String status;
  DateTime approvedOn;

  factory BusinessWork.fromJson(Map<String, dynamic> json) => BusinessWork(
        status: json["status"],
        approvedOn: json["approved_on"]!=null?DateTime.parse(json["approved_on"]):null,
      );
}

class Urls {
  Urls({
    this.raw,
    this.full,
    this.regular,
    this.small,
    this.thumb,
  });

  String raw;
  String full;
  String regular;
  String small;
  String thumb;

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"],
      );
}
