class HomeworkModel {
  late String id,
      standard,
      dateTime,
      homeworktext,
      imgUrl,
      teacherId,
      remark,
      subject;
  HomeworkModel(
      {required this.id,
      required this.standard,
      required this.dateTime,
      required this.homeworktext,
      required this.imgUrl,
      required this.teacherId,
      required this.remark,
      required this.subject});
}
