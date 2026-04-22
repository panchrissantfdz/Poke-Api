package com.pokemon.api.ui.auth

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performTextInput
import org.junit.Rule
import org.junit.Test

class LoginScreenTest {

    @get:Rule
    val composeTestRule = createComposeRule()

    @Test
    fun `muestra error cuando email no tiene arroba`() {
        // Given
        composeTestRule.setContent {
            LoginScreen(onLoginSuccess = {}, onRegisterClick = {})
        }

        // When
        composeTestRule.onNodeWithText("Correo electrónico").performTextInput("correoSinArroba")
        composeTestRule.onNodeWithText("Iniciar Sesión").performClick()

        // Then
        composeTestRule.onNodeWithText("Email inválido").assertIsDisplayed()
    }

    @Test
    fun `muestra error cuando password tiene menos de 6 caracteres`() {
        // Given
        composeTestRule.setContent {
            LoginScreen(onLoginSuccess = {}, onRegisterClick = {})
        }

        // When
        composeTestRule.onNodeWithText("Contraseña").performTextInput("123")
        composeTestRule.onNodeWithText("Iniciar Sesión").performClick()

        // Then
        composeTestRule.onNodeWithText("Mínimo 6 caracteres").assertIsDisplayed()
    }
}