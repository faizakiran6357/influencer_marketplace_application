class InfluencerShortlistModel {
  final String id;
  final String campaignId;
  final String influencerId;
  final String status;
  final double payment;

  InfluencerShortlistModel({
    required this.id,
    required this.campaignId,
    required this.influencerId,
    required this.status,
    required this.payment,
  });

  factory InfluencerShortlistModel.fromMap(Map<String, dynamic> map) {
    return InfluencerShortlistModel(
      id: map['id'],
      campaignId: map['campaign_id'],
      influencerId: map['influencer_id'],
      status: map['status'] ?? 'invited',
      payment: (map['payment'] ?? 0).toDouble(),
    );
  }
}
