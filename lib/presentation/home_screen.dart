import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSignedIn = _currentUser != null;

    Future signIn() async {
      try {
        await _googleSignIn.signIn();
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    signOut() {
      _googleSignIn.disconnect();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: isSignedIn
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: GoogleUserCircleAvatar(identity: _currentUser!),
                      title: Text(_currentUser!.displayName ?? ''),
                      subtitle: Text(_currentUser!.email),
                    ),
                    OutlinedButton(
                        onPressed: signOut, child: const Text('Sign out'))
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not signed in'),
                    ElevatedButton(
                        onPressed: signIn,
                        child: const Text('Sign in with google'))
                  ],
                )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
