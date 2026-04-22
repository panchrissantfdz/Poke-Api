# Pokédex Flutter — Documentación del Proyecto

Aplicación móvil construida con Flutter que muestra una Pokédex con búsqueda, filtrado por tipos, detalle de estadísticas, favoritos persistentes y autenticación con Firebase. Incluye notificaciones locales y cambio de tema guardado en el dispositivo.

## Visión General
- Listado y detalle de Pokémon consumiendo la API pública PokeAPI.
- Búsqueda por nombre y filtro por tipos.
- Pantalla de detalle con estadísticas y chips de tipos.
- Marcado de favoritos persistente (SharedPreferences) y vista de favoritos.
- Autenticación con email/contraseña usando Firebase Auth.
- Notificaciones locales (recordatorios, modo prueba cada 30s).
- Cambio de tema (claro, oscuro, alterno) persistido localmente.

## Arquitectura y Estado
- Estado con Riverpod:
	- `authStateChangesProvider`: expone el `Stream<User?>` para el `AuthGate`.
	- `SignInController`: `AutoDisposeAsyncNotifier` para login email/contraseña.
	- `themeControllerProvider`: `AsyncNotifier<AppTheme>` que carga/guarda el tema vía `SharedPreferences`.
- Persistencia local:
	- `FavoriteService`: guarda IDs de favoritos en `SharedPreferences` (`getFavorites()`, `toggleFavorite()`, `isFavorite()`).
	- `ThemePreferences`: guarda el tema seleccionado.
- Notificaciones:
	- `NotificationService`: inicializa el plugin, configura zona horaria y ofrece `showNow()`, `scheduleDaily()` y un modo de pruebas `scheduleEvery30sTesting()`.
- Consumo de API:
	- `PokemonService` (Dio) consulta `https://pokeapi.co/api/v2/`, normaliza `types`, `stats` e imagen.

## Estructura de Carpetas (lib/)
- `main.dart`: arranque, `Firebase.initializeApp`, `AuthGate`, `ProviderScope`.
- `firebase_options.dart`: opciones generadas por FlutterFire CLI.
- `API/get_api.dart`: servicio HTTP (Dio) para PokeAPI.
- `auth/`
	- `auth_providers.dart`: providers de autenticación (FirebaseAuth, stream de usuario, controlador de login).
	- `theme_provider.dart`: controlador y provider para tema (Riverpod + SharedPreferences).
- `Design/themes.dart`: temas Material 3 y utilidades de color/iconos por tipo.
- `notifications/notification_service.dart`: notificaciones locales y scheduling.
- `Preferences/shared_preferences.dart`: utilidades de favoritos y tema.
- `Widgets/`
	- `home_screen.dart`: grid, búsqueda, filtros, cambio de tema, notificaciones, logout.
	- `pokemon_widget.dart`: `PokemonGrid` (FutureBuilder) y `PokemonCard`.
	- `pokemon_details.dart`: detalle con chips y barras de progreso; toggle de favorito.
	- `pokemon_favorite.dart`: pantalla de favoritos.
	- `filter_pokemon.dart`: hoja modal de filtros por tipo.
	- `login_user.dart`: UI de login con email/contraseña.
	- `register_user.dart`: placeholder de registro.

## Paquetes Utilizados
- `dio`: cliente HTTP para consumir PokeAPI.
- `flutter_riverpod`: manejo de estado reactivo (auth/tema/controladores).
- `shared_preferences`: persistencia ligera de favoritos y tema.
- `firebase_core`: inicialización de Firebase.
- `firebase_auth`: autenticación con email/contraseña.
- `flutter_local_notifications`: notificaciones locales en iOS/Android.
- `timezone` + `flutter_native_timezone`: soporte de zonas horarias para scheduling preciso.
- `cupertino_icons`: iconos estilo iOS.
- `flutter_bloc`: está en dependencias pero no se usa actualmente en el código.

## Configuración de Firebase
El proyecto incluye configuración ya generada por FlutterFire:
- iOS: `ios/Runner/GoogleService-Info.plist`.
- Android: `android/app/google-services.json`.
- Dart: `lib/firebase_options.dart` (generado por `flutterfire configure`).

Para usar tu propio proyecto Firebase:
1. Instala la CLI de FlutterFire y configura:
	 ```bash
	 dart pub global activate flutterfire_cli
	 flutterfire configure
	 ```
2. Sustituye los archivos de plataforma (`GoogleService-Info.plist`, `google-services.json`) y se regenerará `firebase_options.dart`.

## Ejecución y Desarrollo
1. Instalar dependencias:
	 ```bash
	 flutter pub get
	 ```
2. Ejecutar en dispositivo/simulador:
	 ```bash
	 flutter run
	 ```
3. iOS: Asegúrate de abrir `Runner.xcworkspace` si compilas desde Xcode. Flutter maneja CocoaPods al ejecutar.

### Requisitos de permisos
- iOS: Se solicitan permisos de notificaciones al iniciar. Puedes activar/desactivar desde el menú de la `HomeScreen`.
- Android 13+: El plugin maneja la solicitud del permiso `POST_NOTIFICATIONS` si está declarado; revisa el `AndroidManifest.xml` si modificas canales.

## Funcionalidades Clave
- Búsqueda y filtro por tipo desde la `AppBar` y hoja modal.
- Favoritos: Persistidos localmente; accesibles desde el ícono de corazón en la `AppBar`.
- Notificaciones: Menú para activar modo prueba (cada 30s) o cancelar todas.
- Temas: Selector de tema (claro/oscuro/alterno) con persistencia.
- Autenticación: `AuthGate` redirige entre `LoginUser` y `HomeScreen` según el estado de `FirebaseAuth`.

## Pruebas
Ejecuta los tests:
```bash
flutter test
```

## Notas y Próximos Pasos
- `register_user.dart` es un placeholder; pendiente de implementar registro.
- Considera mover la lógica de favoritos a un provider si se requiere reactividad global.
- Si ampliamos notificaciones, añadir canales y descripción personalizada por plataforma.

## Créditos y Fuentes
- API: https://pokeapi.co/
- Proyecto Firebase: `memo-moviles` (según `firebase_options.dart`). Si usas otro, reconfigura con FlutterFire CLI.

