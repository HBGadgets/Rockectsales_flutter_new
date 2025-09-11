class QRCard {
  String? cardTitle;
  String? dateTime;
  String? qrObjectId;
  String? qrId;
  String? addressString;
  String? questionSetId;

  QRCard({
    this.cardTitle,
    this.dateTime,
    this.qrObjectId,
    this.qrId,
    this.addressString,
    this.questionSetId,
  });

  QRCard.fromJson(Map<String, dynamic> json) {
    cardTitle = json['boxNo']?.toString();
    dateTime = json['createdAt'];
    qrObjectId = json['_id'];
    qrId = json['qrcodeId']?.toString(); // ✅ fixed: string, not object
    addressString = json['address'];
    questionSetId = json['questionSetId']; // might be null (not in your response)
  }
}


class QRCardInfo {
  String? cardTitle;
  String? dateTime;
  String? qrId;
  String? addressString;
  String? companyName;
  String? branchName;
  String? supervisorName;
  String? salesmanName;
  String? salesmanSelfie;

  QRCardInfo(
      {required this.cardTitle,
        required this.dateTime,
        required this.qrId,
        required this.addressString,
        required this.companyName,
        required this.branchName,
        required this.supervisorName,
        required this.salesmanName,
        required this.salesmanSelfie});

  QRCardInfo.fromJson(Map<String, dynamic> json) {
    cardTitle = json['boxNo'];
    dateTime = json['createdAt'];
    qrId = json['qrcodeId']['_id'];
    addressString = json['address'];
    companyName = json['companyId']['companyName'];
    branchName = json['branchId']['branchName'];
    supervisorName = json['supervisorId']['supervisorName'];
    salesmanName = json['salesmanId']['salesmanName'];
    salesmanSelfie = json['selfieImage'];
  }
}

class QRQuestions {
  int? questionNo;
  String? text;
  String? id;

  QRQuestions({this.questionNo, this.text, this.id});

  QRQuestions.fromJson(Map<String, dynamic> json) {
    questionNo = json['questionNo'];  // ✅ just assign as int
    text = json['text'];
    id = json['_id'];
  }
}

class AnsweredQuestion {
  String question;
  String answer;

  AnsweredQuestion({
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
  };
}

