enum ItemSize {
  small('Small', 0.0),
  medium('Medium', 2.0),
  large('Large', 4.0),
  xlarge('X-Large', 6.0);

  final String displayName;
  final double priceModifier;

  const ItemSize(this.displayName, this.priceModifier);

  double getPrice(double basePrice) => basePrice + priceModifier;
}
