class Contact{
  int _id;
  String _name;
  String _phone;
  String _email;
  String _whatsapp;
  String _address;
  String _dob;
  int _relation;

  Contact(this._name,this._phone,this._email,this._whatsapp,this._address,this._dob,this._relation);

  Contact.withId(this._id,this._name,this._phone,this._email,this._whatsapp,this._address,this._dob,this._relation);

  int get id=>_id;

  String get name=>_name;

  String get phone=>_phone;

  String get email=>_email;

  String get whatsapp=>_whatsapp;

  String get address=>_address;

  String get dob=>_dob;

  int get relation=>_relation;

  set name(String newName){
    if(newName.length<=30){
      this._name=newName;
    }
  }

  set phone(String newPhone){
    if(newPhone.length==10){
      this._phone=newPhone;
    }
  }

  set email(String newEmail){
    if(newEmail.length<=30){
      this._email=newEmail;
    }
  }

  set whatsapp(String newWhatsapp){
    if(newWhatsapp.length==10){
      this._whatsapp=newWhatsapp;
    }
  }

  set address(String newAddress){
    if(newAddress.length<=200){
      this._address=newAddress;
    }
  }

  set dob(String newDOB){
      this._dob=newDOB;
  }

  set relation(int newRelation){
    if(newRelation>=1 && newRelation<=7){
      this._relation=newRelation;
    }
  }


  //Convert a Note into a map object
  Map<String , dynamic> toMap(){
    var map=Map<String , dynamic>();
    if(id!=null){
      map['id']=_id;
    }
    map['name']=_name;
    map['phone']=_phone;
    map['email']=_email;
    map['whatsapp']=_whatsapp;
    map['address']=_address;
    map['dob']=_dob;
    map['relation']=relation;
    return map;
  }

  //Extract a note object from Map object
  Contact.fromMapObject(Map<String,dynamic>map){
    this._id=map['id'];
    this._name=map['name'];
    this._phone=map['phone'];
    this._email=map['email'];
    this._whatsapp=map['whatsapp'];
    this._address=map['address'];
    this._dob=map['dob'];
    this._relation=map['relation'];
  }

}