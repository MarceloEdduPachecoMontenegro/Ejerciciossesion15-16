# ManosSeguras — Proyecto base (Guías de Práctica N.° 2, 3 y 4)

Proyecto Flutter de partida para la **Evaluación de la Unidad de
Aprendizaje I** de SIS048 – Desarrollo de Software II (UAC, 2026-II).

Todos los equipos comienzan la evaluación con este mismo código ya
clonado y funcionando, de modo que el trabajo de los 60 minutos de
desarrollo se concentre en la pantalla nueva asignada por sorteo
(ver Anexo 1 de la ficha de evaluación) y no en reconstruir lo que
ya se practicó en clase.

## Qué incluye este proyecto base

| Guía de Práctica | Sesiones | Qué construye |
|---|---|---|
| N.° 2 | 4–5 | `PantallaBienvenida` con la tarjeta "Los 5 Momentos" (Text, Container, Icon, padding/margin) |
| N.° 3 | 4–7 | `PantallaEstablecimiento`, `PantallaPersonal`, `PantallaOportunidades` (Row, Column, Expanded) |
| N.° 4 | 8–10 | Indicador de estado tipo Stack (`IndicadorEstado`), etiquetas tipo Wrap (`EtiquetasMomentos`) y el panel responsivo `AppLayout` (LayoutBuilder, MediaQuery) |
| — (base para Sesión 11) | 11 | `darkTheme` completo en `AppTheme` + el `ValueNotifier<ThemeMode> temaApp` en `main.dart`, listos para que cualquier pantalla lea o cambie el tema activo sin tocar la raíz de la app |

El modelo de datos (`lib/models/`) sigue fielmente los campos del
formulario oficial KoboToolbox `formularioahmniveliii.xlsx`: los 5
Momentos y las 4 Acciones (Guantes, Lavado de manos, Omisión,
Fricción de manos) están modelados como `enum` de Dart para que el
compilador impida valores fuera del catálogo oficial.

## Sobre el ThemeMode (`temaApp`)

`lib/theme/tema_app.dart` expone una variable global:

```dart
final ValueNotifier<ThemeMode> temaApp = ValueNotifier(ThemeMode.system);
```

`main.dart` importa este archivo y `ManosSegurasApp` ya escucha esta
variable con un `ValueListenableBuilder`, aplicando `AppTheme.theme`
/ `AppTheme.darkTheme` según corresponda. Esto significa que **ningún
equipo necesita convertir la raíz de la app a `StatefulWidget`** para
poder cambiar de tema: basta con importar `theme/tema_app.dart` desde
la pantalla nueva y asignar, por ejemplo:

```dart
import 'package:manos_seguras/theme/tema_app.dart';
// ...
temaApp.value = ThemeMode.dark;
```

El cambio se refleja de inmediato en toda la app. Este mecanismo
existe específicamente para que la Variante D del Anexo 1
(Configuración y Apariencia) no exija más trabajo estructural que
las otras tres variantes — todas parten del mismo punto y solo
agregan una pantalla nueva. `temaApp` vive en su propio archivo (no
en `main.dart`) justamente para que las pantallas puedan importarlo
sin crear un import circular con `main.dart`.

## Estructura del proyecto

```
lib/
├── main.dart                       # Punto de entrada, arma MaterialApp con temaApp
├── theme/
│   ├── app_theme.dart               # Paleta institucional UAC + ThemeData claro y oscuro
│   └── tema_app.dart                # ValueNotifier<ThemeMode> global (ver sección anterior)
├── models/
│   ├── establecimiento.dart         # Datos del establecimiento auditado
│   ├── personal.dart                # Observador y Observado (herencia)
│   └── oportunidad.dart             # Momento, Accion, Oportunidad
├── widgets/
│   ├── app_layout.dart              # Panel responsivo (Guía N.° 4)
│   ├── indicador_estado.dart        # Stack + Positioned (Guía N.° 4)
│   ├── etiquetas_momentos.dart      # Wrap (Guía N.° 4)
│   └── tarjeta_base.dart            # Tarjeta con estilo institucional
└── screens/
    ├── pantalla_bienvenida.dart
    ├── pantalla_establecimiento.dart
    ├── pantalla_personal.dart
    └── pantalla_oportunidades.dart
```

## Cómo ejecutar el proyecto

```bash
flutter pub get
flutter run
```

Requiere el mismo entorno configurado desde la Sesión 1 (Flutter SDK
y FVM). No usa paquetes externos más allá de `cupertino_icons`, por
lo que `flutter pub get` no requiere conexión a paquetes de terceros
adicionales.

## Qué NO incluye (a propósito)

Este proyecto base **no** resuelve ninguna de las 4 variantes de
pantalla del Anexo 1 de la evaluación (Resumen de Oportunidad,
Panel de Cumplimiento por Servicio, Perfil del Observador,
Configuración y Apariencia): esa pantalla nueva es, junto con el
resto de los contenidos de las Sesiones 1 a 11, el trabajo que cada
equipo realiza durante los 60 minutos de la evaluación. El `darkTheme`
y el mecanismo `temaApp` SÍ están incluidos desde el proyecto base
(ver sección anterior), precisamente para que ese trabajo se limite
a construir la pantalla asignada y no a preparar infraestructura de
tema que le tocaría por igual a cualquier equipo.

## Nota para el docente

Este código está pensado para distribuirse a los equipos **antes**
de sortear la variante de pantalla, ya sea como archivo comprimido
en el laboratorio o como repositorio Git ya clonado en las máquinas.
Verificar que `flutter pub get` se ejecute sin errores en al menos
una máquina de prueba antes del día de la evaluación.
