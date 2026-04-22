// ui/auth/AuthGate.kt
package com.pokemon.api.ui.auth

import androidx.compose.runtime.*
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Scaffold
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.channels.awaitClose
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

// ViewModel que escucha el stream de Firebase
class AuthGateViewModel : ViewModel() {
    sealed class AuthGateState {
        object Loading : AuthGateState()
        object Authenticated : AuthGateState()
        object Unauthenticated : AuthGateState()
    }

    private val _state = MutableStateFlow<AuthGateState>(AuthGateState.Loading)
    val state: StateFlow<AuthGateState> = _state

    init {
        viewModelScope.launch {
            callbackFlow {
                val listener = FirebaseAuth.AuthStateListener { trySend(it.currentUser) }
                FirebaseAuth.getInstance().addAuthStateListener(listener)
                awaitClose { FirebaseAuth.getInstance().removeAuthStateListener(listener) }
            }.collect { user ->
                _state.value = if (user != null)
                    AuthGateState.Authenticated
                else
                    AuthGateState.Unauthenticated
            }
        }
    }
}

@Composable
fun AuthGate(
    onAuthenticated: @Composable () -> Unit,  // → HomeScreen
    viewModel: AuthGateViewModel = viewModel()
) {
    val state by viewModel.state.collectAsStateWithLifecycle()

    when (state) {
        is AuthGateViewModel.AuthGateState.Loading -> {
            Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        }
        is AuthGateViewModel.AuthGateState.Authenticated -> onAuthenticated()
        is AuthGateViewModel.AuthGateState.Unauthenticated -> {
            LoginScreen(
                onLoginSuccess = { /* AuthGate reacciona solo al stream */ },
                onRegisterClick = { /* navegación próximo paso */ }
            )
        }
    }
}