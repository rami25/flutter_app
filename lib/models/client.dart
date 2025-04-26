class Client {
  String userName;
  String email;
  String password;
  String card_Id;
  // DateTime? cardDate;



  Client({
    required this.userName,
    required this.email,
    required this.password,
    required this.card_Id
    // required this.cardDate,
  });

  Map<String, dynamic> toJson() => {
    'userName' : userName,
    'email' : email,
    'password' : password,
    'card_Id' : card_Id
    // 'cardDate' : cardDate,
  };
}

class UserCredentials {
  String login;
  String password;

  UserCredentials({required this.login, required this.password});

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
  };
}
