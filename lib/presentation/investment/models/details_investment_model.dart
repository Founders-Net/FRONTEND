class DetailsInvestmentModel {
  final String title;
  final String amount;
  final String period;
  final String location;
  final String description;

  final String? businessPlanUrl;
  final String? financialModelUrl;
  final String? presentationUrl;

  final String managerName;
  final String managerImage;
  final List<String> managerTags;

  const DetailsInvestmentModel({
    required this.title,
    required this.amount,
    required this.period,
    required this.location,
    required this.description,
    this.businessPlanUrl,
    this.financialModelUrl,
    this.presentationUrl,
    required this.managerName,
    required this.managerImage,
    required this.managerTags,
  });
}
