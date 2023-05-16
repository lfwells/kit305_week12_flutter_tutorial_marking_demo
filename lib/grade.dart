import 'package:json_annotation/json_annotation.dart';


part 'grade.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Grade {
  Grade(this.week, this.studentID, this.stringGrade, this.doubleGrade);

  @JsonKey(ignore:true)
  late String id;

  @JsonKey(defaultValue: 1)
  int week; //starting 1
  @JsonKey(defaultValue: "110852")
  String studentID;

  //TODO: store grade type?
  @JsonKey(required: false)
  String? stringGrade; //HD, D, C, P, N
  @JsonKey(defaultValue: 0)
  double doubleGrade; //%, checkpoints, checkbox

  @JsonKey(ignore: true)
  String get displayGrade
  {
    var doubleGradeAsPerc = doubleGrade * 100;
    if (stringGrade != null)
    {
      return "${stringGrade!} ($doubleGradeAsPerc %)";
    }
    else
    {
      return "$doubleGradeAsPerc%";
    }
  }

  /// A necessary factory constructor for creating a new Grade instance
  /// from a map. Pass the map to the generated `_$GradeFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GradeToJson(this);
}