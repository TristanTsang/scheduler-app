class JournalPrompt{
  int? id;
  late String text;

  JournalPrompt(this.text);

  JournalPrompt.fromMap( Map<String, dynamic> map){
    id = map['id'];
    text = map['prompt'];
  }

  Map<String, Object?> toMap( Map<String, dynamic> map){
    var map = <String, Object?>{
      'id': id,
      'prompt':text,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}