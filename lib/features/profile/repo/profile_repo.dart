import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reddit_clone/constants/firebase_constants.dart';

class ProfileRepo {
  final FirebaseFirestore _firestore;
  ProfileRepo({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;


      CollectionReference<Map<String, dynamic>> get _userCollection =>  _firestore.collection(FirebaseConstants.usersCollection);

      
}