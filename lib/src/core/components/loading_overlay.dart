import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingOverlay {
  static final LoadingOverlay _instance = LoadingOverlay._internal();

  factory LoadingOverlay() {
    return _instance;
  }

  LoadingOverlay._internal();

  OverlayEntry? _overlayEntry;

  void show(BuildContext context, {String? message}) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Fundo escuro semitransparente
          Container(
            color: Colors.black.withValues(alpha: (0.5)),
          ),
          // Indicador de loading centralizado
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SpinKitWaveSpinner(
                  color: Colors.white,
                ),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    // Adiciona o overlay à árvore de widgets
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
