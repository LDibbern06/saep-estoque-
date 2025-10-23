import 'package:flutter/material.dart';
import '../services/db_repository.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nomeC = TextEditingController();
  final loginC = TextEditingController();
  final senhaC = TextEditingController();
  final confirmC = TextEditingController();

  void _register() async {
    final nome = nomeC.text.trim();
    final login = loginC.text.trim();
    final senha = senhaC.text;
    final conf = confirmC.text;
    if (nome.isEmpty || login.isEmpty || senha.isEmpty)
      return _show('Validação', 'Preencha todos os campos');
    if (senha != conf)
      return _show('Validação', 'Senha e confirmação não conferem');
    final exists = await dbRepo.getUserByLogin(login) != null;
    if (exists) return _show('Erro', 'Login já existe');
    final u = await dbRepo.addUser(nome, login, senha);
    // entrar no sistema com o usuário criado
    Navigator.pushReplacementNamed(context, '/home', arguments: u);
  }

  void _show(String title, String msg) => showDialog(
      context: context,
      builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text('OK'))
              ]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro - SAEP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: nomeC,
                decoration: InputDecoration(labelText: 'Nome')),
            TextField(
                controller: loginC,
                decoration: InputDecoration(labelText: 'Login')),
            TextField(
                controller: senhaC,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true),
            TextField(
                controller: confirmC,
                decoration: InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true),
            SizedBox(height: 12),
            ElevatedButton(
                onPressed: _register, child: Text('Cadastrar e Entrar')),
            TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                child: Text('Voltar para Login'))
          ],
        ),
      ),
    );
  }
}
