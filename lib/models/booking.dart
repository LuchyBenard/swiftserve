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
  });
}
