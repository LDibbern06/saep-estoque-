import 'package:flutter/material.dart';
import '../models/user.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(title: Text('SAEP')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                    radius: 28, child: Icon(Icons.inventory_2, size: 28)),
                SizedBox(height: 12),
                Text('Bem-vindo, ${user.nome}',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(height: 20),
                Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                              context, '/products',
                              arguments: user),
                          icon: Icon(Icons.list),
                          label: Text('Produtos')),
                      ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                              context, '/stock',
                              arguments: user),
                          icon: Icon(Icons.swap_horiz),
                          label: Text('Estoque')),
                      ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/'),
                          icon: Icon(Icons.logout),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          label: Text('Logout')),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
