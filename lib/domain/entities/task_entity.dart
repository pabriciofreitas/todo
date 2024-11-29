// ignore_for_file: public_member_api_docs, sort_constructors_first
class TaskEntity {
  int? id;
  String title;
  bool isCheck;
  bool isEditing;
  TaskEntity({
    this.id,
    required this.title,
    this.isCheck = false,
    this.isEditing = false,
  });
  // Converte o objeto em um Map (para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCheck': isCheck,
    };
  }

  // Cria um objeto a partir de um Map (de JSON)
  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['id'],
      title: json['title'],
      isCheck: json['isCheck'],
    );
  }
  copyWith({int? id, String? title, bool? isCheck, bool? isEditing}) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCheck: isCheck ?? this.isCheck,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  String toString() {
    return 'TaskEntity(id: $id, title: $title, isCheck: $isCheck, isEditing: $isEditing)';
  }
}
