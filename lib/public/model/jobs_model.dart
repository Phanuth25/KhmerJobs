class JobModel {
  final int id;
  final int companyId;
  final String title;
  final String description;
  final String category;
  final String location;
  final int salaryMin;
  final int salaryMax;
  final String type;
  final String status;
  final String createdAt;
  final String companyName;
  JobModel({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.salaryMin,
    required this.salaryMax,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.companyName,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      companyId: json['company_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      location: json['location'],
      salaryMin: json['salary_min'],
      salaryMax: json['salary_max'],
      type: json['type'],
      status: json['status'],
      createdAt: json['created_at'],
      companyName: json['company_name'],
    );
  }
}