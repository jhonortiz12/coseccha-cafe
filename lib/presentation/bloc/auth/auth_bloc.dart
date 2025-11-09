import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sign_in.dart';
import '../../../domain/usecases/sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;

  AuthBloc({required this.signIn, required this.signUp}) : super(AuthInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await signIn(SignInParams(
        email: event.email,
        password: event.password,
      ));
      
      result.fold(
        (failure) => emit(AuthError(message: 'Error de autenticación')),
        (user) => emit(AuthSuccess(user: user))
      );
    });

    // Similar implementation for SignUpRequested
  }
}
