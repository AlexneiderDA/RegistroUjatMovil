import 'package:flutter/material.dart';
import '../models/users.dart';
import '../services/auth.service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Constructor
  AuthViewModel() {
    _initializeAuthState();
  }

  // Inicializar estado de autenticación
  void _initializeAuthState() {
    _currentUser = _authService.getCurrentUser();
    _authService.authStateChanges.listen((UserModel? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // Método para iniciar sesión
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      _currentUser = await _authService.signInWithEmailAndPassword(email, password);
      _setLoading(false);
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _setError('Error al iniciar sesión: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Método para registrarse
  Future<bool> register(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      _currentUser = await _authService.registerWithEmailAndPassword(email, password);
      _setLoading(false);
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _setError('Error al registrarse: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.signOut();
      _currentUser = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Error al cerrar sesión: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Método para restablecer contraseña
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Error al restablecer contraseña: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Helpers para manejar estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}