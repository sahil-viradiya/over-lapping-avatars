import 'package:flutter/material.dart';

class OverlappingAvatars extends StatelessWidget {
  /// La lista de datos de usuario. Cada mapa debe contener las claves necesarias para tu `avatarBuilder` o las claves por defecto ('Name', 'url').
  final List<Map<String, String>> users;

  /// El número máximo de avatares a mostrar antes de agrupar el resto en un círculo de conteo.
  final int maxVisible;

  /// El radio de cada círculo de avatar.
  final double avatarRadius;

  /// La cantidad de píxeles que cada avatar se superpone al anterior.
  final double overlap;

  /// El color de fondo para los avatares por defecto cuando la URL de la imagen no es válida o no se proporciona.
  final Color avatarBackgroundColor;

  /// El estilo de texto para la inicial de fallback en el avatar por defecto.
  final TextStyle fallbackTextStyle;

  /// El color del borde exterior para el círculo de conteo extra (ej. '+5').
  final Color extraCountCircleColor;

  /// El color de fondo para el círculo de conteo extra.
  final Color extraCountCircleBackgroundColor;

  /// El estilo de texto para el número en el círculo de conteo extra.
  final TextStyle extraCountTextStyle;

  /// Un constructor opcional para crear un widget de avatar personalizado.
  /// Si se proporciona, anula la lógica de renderizado de avatar por defecto.
  final Widget Function(BuildContext context, Map<String, String> user)?
  avatarBuilder;

  const OverlappingAvatars({
    super.key,
    required this.users,
    this.maxVisible = 5,
    this.avatarRadius = 30,
    this.overlap = 20,
    this.avatarBackgroundColor = const Color(
      0xFFE0E0E0,
    ), // Colors.grey.shade300
    this.fallbackTextStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    this.extraCountCircleColor = Colors.red,
    this.extraCountCircleBackgroundColor = const Color(
      0xFFE0E0E0,
    ), // Colors.grey.shade300
    this.extraCountTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    this.avatarBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = users.length > maxVisible ? maxVisible : users.length;
    final extraCount = users.length > maxVisible
        ? users.length - maxVisible
        : 0;

    // Calcula el ancho total necesario para los avatares visibles y el círculo de conteo.
    final double totalWidth =
        (displayCount * (avatarRadius * 2 - overlap)) +
        (extraCount > 0 ? (avatarRadius * 2 - overlap) : 0) +
        overlap; // Añade el overlap final para que el último círculo se vea completo.

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: avatarRadius * 2,
        width: totalWidth,
        child: Stack(
          children: [
            // Renderiza los avatares visibles
            for (int i = 0; i < displayCount; i++)
              Positioned(
                left: i * (avatarRadius * 2 - overlap),
                child: _buildAvatar(context, users[i]),
              ),
            // Renderiza el círculo de conteo si hay usuarios extra
            if (extraCount > 0)
              Positioned(
                left: displayCount * (avatarRadius * 2 - overlap),
                child: _buildExtraCountCircle(extraCount),
              ),
          ],
        ),
      ),
    );
  }

  /// Decide si usar el constructor de avatar personalizado o el por defecto.
  Widget _buildAvatar(BuildContext context, Map<String, String> user) {
    if (avatarBuilder != null) {
      return avatarBuilder!(context, user);
    }
    return _buildDefaultAvatar(user);
  }

  /// Construye el círculo de conteo para los usuarios no visibles.
  Widget _buildExtraCountCircle(int count) {
    return CircleAvatar(
      radius: avatarRadius,
      backgroundColor: extraCountCircleColor,
      child: CircleAvatar(
        radius: avatarRadius - 3,
        backgroundColor: extraCountCircleBackgroundColor,
        child: Text('+$count', style: extraCountTextStyle),
      ),
    );
  }

  /// Construye el avatar por defecto (imagen o inicial).
  /// Construye el avatar por defecto (imagen de red, asset o inicial).
Widget _buildDefaultAvatar(Map<String, String> user) {
  final name = user['Name'] ?? '';
  final url = user['url'] ?? '';
  final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

  // Determine if it's a network URL or local asset
  final bool isNetworkUrl = url.startsWith('http://') || url.startsWith('https://');
  final bool hasUrl = url.isNotEmpty;

  return CircleAvatar(
    radius: avatarRadius,
    backgroundColor: avatarBackgroundColor,
    child: hasUrl
        ? ClipOval(
            child: isNetworkUrl
                ? Image.network(
                    url,
                    width: avatarRadius * 2,
                    height: avatarRadius * 2,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Center(child: _buildFallbackText(firstLetter));
                    },
                  )
                : Image.asset(
                    url,
                    width: avatarRadius * 2,
                    height: avatarRadius * 2,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Center(child: _buildFallbackText(firstLetter));
                    },
                  ),
          )
        : _buildFallbackText(firstLetter),
  );
}

  /// Construye el texto de fallback (la inicial del nombre).
  Widget _buildFallbackText(String letter) {
    return Text(letter, style: fallbackTextStyle);
  }
}
