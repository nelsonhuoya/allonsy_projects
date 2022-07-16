import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:allonsyapp/firebase/api_response.dart';


class FirebaseService{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ApiResponse> login(String email, String senha) async{
    try {
      //Login no FireBase
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: senha);
      final User? fUser = result.user;
      print("Firebase Nome: ${fUser!.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoURL}");

      //Resposta genérica

      return ApiResponse.ok();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if(e.message == "The password is invalid or the user does not have a password."){
        return ApiResponse.error(msg: "Endereço de e-mail e/ou senha inválidos. Tente novamente.");
      }
      if(e.message == "There is no user record corresponding to this identifier. The user may have been deleted."){
        return ApiResponse.error(msg: "Endereço de e-mail e/ou senha inválidos. Tente novamente.");
      }
      return ApiResponse.error(msg: "Não foi possível fazer o login. Tente novamente");
    }
  }

  Future<ApiResponse> loginGoogle() async {
    try {

      //Login com o Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      print("Google User: ${googleUser.email}");

      //Credenciais para o Firebase
      final AuthCredential  credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login no FireBase
      UserCredential result = await _auth.signInWithCredential(credential);
      final User? fuser = result.user;
      print("Firebase Nome: ${fuser!.displayName}");
      print("Firebase Email: ${fuser.email}");
      print("Firebase Foto: ${fuser.photoURL}");

      //Resposta genérica
      return ApiResponse.ok();
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error(msg: "Não foi possível fazer o login");
    }
  }

  Future<ApiResponse> cadastrar(String nome, String email, String senha) async {
    try {
     UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: senha);
     final User? fUser = result.user;

      //Dados para atualizar o usuário
     fUser!.updateDisplayName(nome);
     fUser.updatePhotoURL("https://i1.wp.com/terracoeconomico.com.br/wp-content/uploads/2019/01/default-user-image.png?ssl=1");
     await FirebaseAuth.instance.currentUser!.reload();



      //Resposta genérica

      return ApiResponse.ok(msg: "Usuário criado com sucesso");
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if(e.message == "The email address is badly formatted."){
        return ApiResponse.error(
          msg: "O endereço de e-mail está formatado incorretamente.");
      }
      if(e.message == "The email address is already in use by another account.") {
        return ApiResponse.error(
            msg: "O endereço de e-mail já está em uso.");
      }
      return ApiResponse.error(
          msg: "Não foi possível criar um usuário");
    }
  }

  Future<Null> logout() async{
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}