import 'package:flutter/material.dart';
import '../services/db_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  void _doLogin() async {
    final login = _loginController.text.trim();
    final senha = _senhaController.text;
    final user = await dbRepo.authenticate(login, senha);
    if (user == null) {
      final exists = await dbRepo.getUserByLogin(login) != null;
      final msg = exists ? 'Senha incorreta' : 'Usuário não encontrado';
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text('Falha de autenticação'),
                  content: Text(msg),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'))
                  ]));
      return;
    }
    Navigator.pushReplacementNamed(context, '/home', arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('SAEP',
                      style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 8),
                  Text('Controle de Estoque',
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 16),
                  TextField(
                      controller: _loginController,
                      decoration: InputDecoration(
                          labelText: 'Login', prefixIcon: Icon(Icons.person))),
                  SizedBox(height: 8),
                  TextField(
                      controller: _senhaController,
                      decoration: InputDecoration(
                          labelText: 'Senha', prefixIcon: Icon(Icons.lock)),
                      obscureText: true),
                  SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: _doLogin, child: Text('Entrar')))
                  ]),
                  SizedBox(height: 8),
                  TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: Text('Criar conta'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
