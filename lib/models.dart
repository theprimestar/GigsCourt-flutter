// ========================================
// GigsCourt - All Data Models
// ========================================

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final String? phone;
  final String? bio;
  final String? addressText;
  final List<String> services;
  final List<String> portfolio;
  final int credits;
  final int gigCount;
  final double rating;
  final int reviewCount;
  final int gigsLast7Days;
  final int gigsLast30Days;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String? fcmToken;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.phone,
    this.bio,
    this.addressText,
    required this.services,
    required this.portfolio,
    required this.credits,
    required this.gigCount,
    required this.rating,
    required this.reviewCount,
    required this.gigsLast7Days,
    required this.gigsLast30Days,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = false,
    this.fcmToken,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? 'User',
      photoURL: data['photoURL'],
      phone: data['phone'],
      bio: data['bio'],
      addressText: data['addressText'],
      services: List<String>.from(data['services'] ?? []),
      portfolio: List<String>.from(data['portfolio'] ?? []),
      credits: data['credits'] ?? 5,
      gigCount: data['gigCount'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      gigsLast7Days: data['gigsLast7Days'] ?? 0,
      gigsLast30Days: data['gigsLast30Days'] ?? 0,
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(data['updatedAt'] ?? DateTime.now().toIso8601String()),
      isActive: data['isActive'] ?? false,
      fcmToken: data['fcmToken'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phone': phone,
      'bio': bio,
      'addressText': addressText,
      'services': services,
      'portfolio': portfolio,
      'credits': credits,
      'gigCount': gigCount,
      'rating': rating,
      'reviewCount': reviewCount,
      'gigsLast7Days': gigsLast7Days,
      'gigsLast30Days': gigsLast30Days,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'fcmToken': fcmToken,
    };
  }

  bool get hasCompletedGigs => gigCount > 0;
  bool get isCurrentlyActive => hasCompletedGigs && (gigsLast7Days >= 1 || gigsLast30Days >= 3);
}

class ProviderLocation {
  final String userId;
  final double lat;
  final double lng;
  final String services;
  final double rating;
  final int gigCount;
  final DateTime? lastGigDate;
  final double distanceMeters;

  ProviderLocation({
    required this.userId,
    required this.lat,
    required this.lng,
    required this.services,
    required this.rating,
    required this.gigCount,
    this.lastGigDate,
    this.distanceMeters = 0,
  });

  factory ProviderLocation.fromSupabase(Map<String, dynamic> data) {
    return ProviderLocation(
      userId: data['user_id'] ?? '',
      lat: (data['lat'] ?? 0).toDouble(),
      lng: (data['lng'] ?? 0).toDouble(),
      services: data['services'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      gigCount: data['gig_count'] ?? 0,
      lastGigDate: data['last_gig_date'] != null 
          ? DateTime.parse(data['last_gig_date']) 
          : null,
      distanceMeters: (data['distance_meters'] ?? 0).toDouble(),
    );
  }

  List<String> get servicesList => services.split(',').map((s) => s.trim()).toList();
}

class ChatModel {
  final String id;
  final List<String> participants;
  final Map<String, ParticipantInfo> participantInfo;
  final String lastMessage;
  final DateTime lastMessageTime;
  final Map<String, int> unreadCount;
  final bool pendingReview;
  final String? pendingGigId;
  final DateTime createdAt;

  ChatModel({
    required this.id,
    required this.participants,
    required this.participantInfo,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.pendingReview = false,
    this.pendingGigId,
    required this.createdAt,
  });

  factory ChatModel.fromFirestore(Map<String, dynamic> data, String id) {
    Map<String, ParticipantInfo> infoMap = {};
    if (data['participantInfo'] != null) {
      (data['participantInfo'] as Map).forEach((key, value) {
        infoMap[key] = ParticipantInfo.fromMap(value);
      });
    }

    Map<String, int> unreadMap = {};
    if (data['unreadCount'] != null) {
      (data['unreadCount'] as Map).forEach((key, value) {
        unreadMap[key] = value ?? 0;
      });
    }

    return ChatModel(
      id: id,
      participants: List<String>.from(data['participants'] ?? []),
      participantInfo: infoMap,
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: DateTime.parse(data['lastMessageTime'] ?? DateTime.now().toIso8601String()),
      unreadCount: unreadMap,
      pendingReview: data['pendingReview'] ?? false,
      pendingGigId: data['pendingGigId'],
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  String getOtherUserId(String currentUserId) {
    return participants.firstWhere((id) => id != currentUserId, orElse: () => '');
  }

  ParticipantInfo? getOtherUserInfo(String currentUserId) {
    final otherId = getOtherUserId(currentUserId);
    return participantInfo[otherId];
  }

  int getUnreadCount(String userId) => unreadCount[userId] ?? 0;
}

class ParticipantInfo {
  final String displayName;
  final String? photoURL;

  ParticipantInfo({required this.displayName, this.photoURL});

  factory ParticipantInfo.fromMap(Map<String, dynamic> data) {
    return ParticipantInfo(
      displayName: data['displayName'] ?? 'User',
      photoURL: data['photoURL'],
    );
  }
}

class MessageModel {
  final String id;
  final String senderId;
  final String? text;
  final String? imageUrl;
  final DateTime timestamp;
  final bool edited;
  final DateTime? editedAt;

  MessageModel({
    required this.id,
    required this.senderId,
    this.text,
    this.imageUrl,
    required this.timestamp,
    this.edited = false,
    this.editedAt,
  });

  factory MessageModel.fromFirestore(Map<String, dynamic> data, String id) {
    return MessageModel(
      id: id,
      senderId: data['senderId'] ?? '',
      text: data['text'],
      imageUrl: data['imageUrl'],
      timestamp: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
      edited: data['edited'] ?? false,
      editedAt: data['editedAt'] != null ? DateTime.parse(data['editedAt']) : null,
    );
  }
}

class GigModel {
  final String id;
  final String providerId;
  final String clientId;
  final String status; // 'pending_review', 'completed', 'cancelled'
  final DateTime registeredAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final ReviewModel? review;

  GigModel({
    required this.id,
    required this.providerId,
    required this.clientId,
    required this.status,
    required this.registeredAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelledBy,
    this.review,
  });

  factory GigModel.fromFirestore(Map<String, dynamic> data, String id) {
    return GigModel(
      id: id,
      providerId: data['providerId'] ?? '',
      clientId: data['clientId'] ?? '',
      status: data['status'] ?? 'pending_review',
      registeredAt: DateTime.parse(data['registeredAt'] ?? DateTime.now().toIso8601String()),
      completedAt: data['completedAt'] != null ? DateTime.parse(data['completedAt']) : null,
      cancelledAt: data['cancelledAt'] != null ? DateTime.parse(data['cancelledAt']) : null,
      cancelledBy: data['cancelledBy'],
      review: data['review'] != null ? ReviewModel.fromMap(data['review']) : null,
    );
  }

  bool get isPending => status == 'pending_review';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}

class ReviewModel {
  final double rating;
  final String comment;
  final DateTime submittedAt;

  ReviewModel({
    required this.rating,
    required this.comment,
    required this.submittedAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    return ReviewModel(
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      submittedAt: DateTime.parse(data['submittedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ServiceCategory {
  final String id;
  final String name;
  final String emoji;
  final int displayOrder;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.displayOrder,
  });

  factory ServiceCategory.fromSupabase(Map<String, dynamic> data) {
    return ServiceCategory(
      id: data['id'] ?? '',
      name: data['category_name'] ?? '',
      emoji: data['emoji'] ?? '',
      displayOrder: data['display_order'] ?? 0,
    );
  }
}

class PresetService {
  final String id;
  final String categoryId;
  final String serviceName;
  final String displayName;
  final bool isActive;

  PresetService({
    required this.id,
    required this.categoryId,
    required this.serviceName,
    required this.displayName,
    required this.isActive,
  });

  factory PresetService.fromSupabase(Map<String, dynamic> data) {
    return PresetService(
      id: data['id'] ?? '',
      categoryId: data['category_id'] ?? '',
      serviceName: data['service_name'] ?? '',
      displayName: data['display_name'] ?? '',
      isActive: data['is_active'] ?? true,
    );
  }
}

class TransactionModel {
  final String id;
  final String userId;
  final String type; // 'credit_purchase', 'admin_gift', 'gig_used'
  final int credits;
  final double amount;
  final String reference;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.credits,
    required this.amount,
    required this.reference,
    required this.createdAt,
  });

  factory TransactionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TransactionModel(
      id: id,
      userId: data['userId'] ?? '',
      type: data['type'] ?? '',
      credits: data['credits'] ?? 0,
      amount: (data['amount'] ?? 0).toDouble(),
      reference: data['reference'] ?? '',
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? link;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.link,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromFirestore(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      link: data['link'],
      read: data['read'] ?? false,
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
