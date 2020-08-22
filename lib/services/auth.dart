import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/model/user.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthMethods {
	final FirebaseAuth _auth = FirebaseAuth.instance;
	final GoogleSignIn _googleSignIn = GoogleSignIn();
	
	User _userFromFirebaseUser(FirebaseUser user) {
		return user!=null ? User(userId: user.uid) : null;
	}
	Future signInwithEmailAndPassword(String email, String password) async {
		try {
			final FirebaseUser firebaseUser = await _auth.signInWithEmailAndPassword(email: email,password: password);
			return _userFromFirebaseUser(firebaseUser);

		} catch(e) {
			print(e);
		}
	}
	Future signUpwithEmailAndPassword(String email, String password) async {
		try{
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
  		await _googleSignIn.signOut();
  		return _auth.signOut();

		} catch(e){
			print(e);
		}
  }

  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
	}

	Future<FirebaseUser> signInWithGoogle() async {
    //loader();

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = await _auth.signInWithCredential(credential);
     	return user;
  }

}
