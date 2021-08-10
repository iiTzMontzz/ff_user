class Predictions {
  String placeID;
  String maintext;
  String secondaryText;

  Predictions({
    this.placeID,
    this.maintext,
    this.secondaryText,
  });

  Predictions.fromJson(Map<String, dynamic> json) {
    placeID = json['place_id'];
    maintext = json['structured_formatting']['main_text'];
    secondaryText = json['structured_formatting']['secondary_text'];
  }
}
