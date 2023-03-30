

class UserModel {
  static const USER_REF = "users";
  static const DIRECTORY = "profile images";

  static const ID = "user_id";
  static const F_NAME = "f_name";
  static const L_NAME = "l_name";
  static const GENDER = "gender";
  static const IMAGE_URL = "image_url";
  static const ADDRESS = "address";
  static const SSN = "ssn";
  static const BIRTH_DATE = "birth_date";
  static const EMAIL = "email";
  static const PHONE_NUMBER = "phone_number";
  static const TYPE = "type";
  static const CONNECTED = "connected";

  String _id = "";
  String _fName = "";
  String _lName = "";
  String _gender = "";
  String _imageUrl = " ";
  String _address = "";
  String _ssn = "";
  String _birthDate = "";
  String _phoneNumber = "";
  String _email = "";
  String _type = "";
  String _connected = "";

  UserModel();

  UserModel.fromSnapshoot(Map<String, dynamic>? userData) {

    _id = userData![ID];
    _fName = userData[F_NAME]??"";
    _lName = userData[L_NAME]??"";
    _imageUrl = userData["image_url"] ?? "";
    _email = userData[EMAIL];
    _ssn = userData[SSN];
    _address = userData[ADDRESS];
    _birthDate = userData[BIRTH_DATE];
    _phoneNumber = userData[PHONE_NUMBER];
    _gender = userData[GENDER];
    _type = userData[TYPE];
    _connected = userData[CONNECTED];
  }

  String get id => _id;

  String get fName => _fName;

  String get lName => _lName;

  String get gender => _gender;

  String get imageUrl => _imageUrl;

  String get address => _address;

  String get ssn => _ssn;

  String get birthDate => _birthDate;

  String get phoneNumber => _phoneNumber;

  String get email => _email;

  String get type => _type;

  String get connected => _connected;
}
