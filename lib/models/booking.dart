import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String providerName;
  final String serviceType;
  final String status; // 'In Progress', 'Confirmed', 'Completed', 'Canceled'
  final String date;
  final String time;
  final String location;
  final double price;
  final String imageUrl;

  // Firestore / marketplace fields
  final String clientId;
  final String providerId;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Booking({
    required this.id,
    required this.providerName,
    required this.serviceType,
    required this.status,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.imageUrl,
    this.clientId = '',
    this.providerId = '',
    this.notes = '',
    this.createdAt,
    this.updatedAt,
  });

  bool get isActive =>
      status == 'In Progress' || status == 'Confirmed' || status == 'Pending';

  bool get isCompleted => status == 'Completed';

  bool get isCanceled => status == 'Canceled';

  factory Booking.fromFirestore(DocumentSnapshot snapshot) {
    final data =
        (snapshot.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    return Booking(
      id: data['id'] as String? ?? snapshot.id,
      providerName: data['providerName'] as String? ?? '',
      serviceType: data['serviceType'] as String? ?? '',
      status: data['status'] as String? ?? 'Pending',
      date: data['date'] as String? ?? '',
      time: data['time'] as String? ?? '',
      location: data['location'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] as String? ?? '',
      clientId: data['clientId'] as String? ?? '',
      providerId: data['providerId'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
      createdAt: _toDateTime(data['createdAt']),
      updatedAt: _toDateTime(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'providerName': providerName,
      'serviceType': serviceType,
      'status': status,
      'date': date,
      'time': time,
      'location': location,
      'price': price,
      'imageUrl': imageUrl,
      'clientId': clientId,
      'providerId': providerId,
      'notes': notes,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerName': providerName,
      'serviceType': serviceType,
      'status': status,
      'date': date,
      'time': time,
      'location': location,
      'price': price,
      'imageUrl': imageUrl,
      'clientId': clientId,
      'providerId': providerId,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String? ?? '',
      providerName: json['providerName'] as String? ?? '',
      serviceType: json['serviceType'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      location: json['location'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? '',
      clientId: json['clientId'] as String? ?? '',
      providerId: json['providerId'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  Booking copyWith({
    String? id,
    String? providerName,
    String? serviceType,
    String? status,
    String? date,
    String? time,
    String? location,
    double? price,
    String? imageUrl,
    String? clientId,
    String? providerId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      providerName: providerName ?? this.providerName,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      clientId: clientId ?? this.clientId,
      providerId: providerId ?? this.providerId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    return _toDateTime(value);
  }
}
