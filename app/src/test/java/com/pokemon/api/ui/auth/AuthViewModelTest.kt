package com.pokemon.api.ui.auth

import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import com.google.firebase.auth.FirebaseUser
import com.pokemon.api.MainDispatcherRule
import com.pokemon.api.data.repository.AuthRepository
import io.mockk.coEvery
import io.mockk.coJustRun
import io.mockk.mockk
import io.mockk.slot

import kotlinx.coroutines.delay
import kotlinx.coroutines.test.*
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test

class AuthViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    // ─────────────────────────────────────────
    // Test 1: Login exitoso
    // ─────────────────────────────────────────
    @Test
    fun `login exitoso cambia estado a Success`() = runTest {
        // Given
        val mockRepo = mockk<AuthRepository>()
        val fakeUser = mockk<FirebaseUser>()
        coEvery { mockRepo.login("ash@pokemon.com", "pikachu") } returns Result.success(fakeUser)
        val viewModel = AuthViewModel(mockRepo)

        // When
        viewModel.login("ash@pokemon.com", "pikachu")
        advanceUntilIdle() // ← le dice al dispatcher: ejecuta todo lo pendiente

        // Then
        assertEquals(AuthUiState.Success, viewModel.uiState.value)
    }

    // ─────────────────────────────────────────
    // Test 2: Login fallido
    // ─────────────────────────────────────────
    @Test
    fun `login fallido cambia estado a Error con mensaje`() = runTest {
        // Given
        val mockRepo = mockk<AuthRepository>()
        coEvery {
            mockRepo.login(any(), any())
        } returns Result.failure(Exception("Credenciales inválidas"))
        val viewModel = AuthViewModel(mockRepo)

        // When
        viewModel.login("mal@email.com", "wrong")
        advanceUntilIdle() // ← igual aquí, espera que la coroutine termine

        // Then
        val state = viewModel.uiState.value
        assert(state is AuthUiState.Error) { "Se esperaba Error pero fue: $state" }
        assertEquals("Credenciales inválidas", (state as AuthUiState.Error).message)
    }

    // ─────────────────────────────────────────
    // Test 3: Estado Loading mientras procesa
    // ─────────────────────────────────────────
    @Test
    fun `login muestra Loading mientras procesa la peticion`() = runTest {
        // Given
        val mockRepo = mockk<AuthRepository>()
        val fakeUser = mockk<FirebaseUser>()
        // El repo tarda 1000ms — simula una llamada real a Firebase
        coEvery {
            mockRepo.login(any(), any())
        } coAnswers {
            delay(1_000)
            Result.success(fakeUser)
        }
        val viewModel = AuthViewModel(mockRepo)

        // When — lanzamos la coroutine
        viewModel.login("ash@pokemon.com", "pikachu")

        // Avanzamos solo 1ms para que se ejecute el setState(Loading)
        // pero sin completar el delay(1000) del repositorio
        advanceTimeBy(1)

        // Then — en este punto exacto debe ser Loading
        assertEquals(AuthUiState.Loading, viewModel.uiState.value)

        // Limpieza — dejamos terminar todo para no contaminar otros tests
        advanceUntilIdle()
        assertEquals(AuthUiState.Success, viewModel.uiState.value)
    }
}