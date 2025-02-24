import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth.viewmodel.dart';
import '../login/login.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    
    // Si el usuario no está autenticado, redirigir a Login
    if (!authViewModel.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await authViewModel.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Correo: ${authViewModel.currentUser?.email}',
              style: const TextStyle(fontSize: 16),
            ),
            if (authViewModel.currentUser?.displayName != null) ...[
              const SizedBox(height: 8),
              Text(
                'Nombre: ${authViewModel.currentUser?.displayName}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await authViewModel.signOut();
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}