import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/model/user.dart';


class AuthMethods {
	final FirebaseAuth _auth = FirebaseAuth.instance;
	
	User _userFromFirebaseUser(FirebaseUser user) {
		return user!=null ? User(userId: user.uid) : null;
	}
	Future signInwithEmailAndPassword(String email, String password) async {
		try {
			//AuthResult result = _auth.signInWithEmailAndPassword(email: email,password: password);
			//FirebaseUser firebaseUser = result.user;
			final FirebaseUser firebaseUser = await _auth.signInWithEmailAndPassword(email: email,password: password);
			return _userFromFirebaseUser(firebaseUser);

		} catch(e) {
			print(e);
		}
	}
	Future signUpwithEmailAndPassword(String email, String password) async {
		try{
			//AuthResult result = _auth.createUserWithEmailAndPassword(email: email,password: password);
			//FirebaseUser firebaseUser = result.user;
			final FirebaseUser firebaseUser = await _auth.createUserWithEmailAndPassword(email: email,password: password);
			return _userFromFirebaseUser(firebaseUser);
		} catch(e){
			print(e);
		}
	}
	Future resetPass(String email) async {
		try{
			return _auth.sendPasswordResetEmail(email:email);
		} catch(e){
			print(e);
		}
	}

  Future signOut() async {
  	try{
  		return _auth.signOut();
		} catch(e){
			print(e);
		}
  }

}
