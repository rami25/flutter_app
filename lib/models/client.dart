class Client {
  String userName;
  String email;
  String password;
  int cardId;
  DateTime cardDate;
/////

/////




  Client({
    required this.userName,
    required this.email,
    required this.password,
    required this.cardId,
    required this.cardDate,
  });

  Map<String, dynamic> toJson() => {
    'userName' : userName,
    'email' : email,
    'password' : password,
    'cardId' : cardId,
    'cardDate' : cardDate,
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
