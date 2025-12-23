/// Model for asset data
class AssetModel {
  final String assetId;
  final String name;
  final String category;
  final String assignedTo;
  final String date;
  final String cost;
  final String status;
  final String warranty;
  final String condition;

  const AssetModel({
    required this.assetId,
    required this.name,
    required this.category,
    required this.assignedTo,
    required this.date,
    required this.cost,
    required this.status,
    required this.warranty,
    required this.condition,
  });
}
