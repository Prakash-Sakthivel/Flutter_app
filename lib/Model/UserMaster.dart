class UserMaster {
    int id;
    String userName;
    String password;
    static final columns = ["id", "username", "password"];
    UserMaster(this.id, this.userName, this.password);
    factory UserMaster.fromMap(Map<String, dynamic> data) {
        return UserMaster(
                data['id'],
                data['username'],
                data['password'],
                );
    }
    Map<String, dynamic> toMap() => {
        "id": id,
        "username": userName,
        "password": password,
    };

    factory UserMaster.createUserObject() {
      return UserMaster(0, "", "");
    }
}
