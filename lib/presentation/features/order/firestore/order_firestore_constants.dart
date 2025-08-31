class OrderFs {
  static const String users = 'users';
  static const String subOrders = 'orders';
  static const String subReviews = 'reviews';

  // Order fields
  static const String fStatus = 'status'; // active | completed | cancelled
  static const String fItems = 'items';
  static const String fSubtotal = 'subtotal';
  static const String fTax = 'tax';
  static const String fDeliveryFee = 'deliveryFee';
  static const String fTotal = 'total';
  static const String fShippingAddress = 'shippingAddress';
  static const String fPayment = 'payment'; // { method, status, transactionId }
  static const String fDeliveryInfo = 'delivery'; // { eta, courierName, trackingId }
  static const String fCreatedAt = 'createdAt';
  static const String fUpdatedAt = 'updatedAt';
  static const String fCompletedAt = 'completedAt';
  static const String fCanceledAt = 'canceledAt';

  // Review fields
  static const String fRating = 'rating';
  static const String fComment = 'comment';
  static const String fReviewCreatedAt = 'createdAt';
}
