import 'dart:convert';
import 'dart:typed_data';

/// An export payload handed to the application.
///
/// The wrapper does not write files, request storage permissions, or choose a
/// destination. It returns the bytes and lets the application decide whether to
/// save, share, preview or discard them. This is why `permission_handler`,
/// `path_provider` and `pdf` are no longer dependencies.
class FusionChartsExport {
  const FusionChartsExport({
    required this.format,
    required this.mimeType,
    required this.suggestedFileName,
    required this.bytes,
    this.text,
  });

  /// Requested format, lower-case: `png`, `jpg`, `svg`, `pdf`, `csv`, `xlsx`.
  final String format;

  /// MIME type reported by the page, for example `image/png`.
  final String mimeType;

  /// A filename the application may use. It is a suggestion, not a path.
  final String suggestedFileName;

  /// The payload. Always populated, including for text formats.
  final Uint8List bytes;

  /// The payload as text, for `svg` and `csv` where the page returns a string
  /// directly. `null` for binary formats.
  final String? text;

  int get lengthInBytes => bytes.lengthInBytes;

  /// Builds an export from a validated inbound bridge payload.
  ///
  /// Returns `null` if the payload carries neither `base64` nor `text`, so a
  /// malformed message can never surface as an empty but apparently valid file.
  static FusionChartsExport? fromPayload(
    Map<String, dynamic> payload, {
    required String fallbackFormat,
  }) {
    final String format =
        (payload['format'] as String?)?.toLowerCase() ?? fallbackFormat;
    final String mime =
        (payload['mime'] as String?) ?? 'application/octet-stream';
    final String name = (payload['fileName'] as String?) ?? 'chart.$format';

    final Object? text = payload['text'];
    if (text is String) {
      return FusionChartsExport(
        format: format,
        mimeType: mime,
        suggestedFileName: name,
        bytes: Uint8List.fromList(utf8.encode(text)),
        text: text,
      );
    }

    final Object? b64 = payload['base64'];
    if (b64 is String && b64.isNotEmpty) {
      try {
        return FusionChartsExport(
          format: format,
          mimeType: mime,
          suggestedFileName: name,
          bytes: base64Decode(b64),
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  String toString() => 'FusionChartsExport($format, $mimeType, '
      '$suggestedFileName, $lengthInBytes bytes)';
}

/// Export formats the bridge accepts.
///
/// Availability is platform-dependent; see the published support matrix. As of
/// 2.0, Android returns all six, while iOS returns `svg`, `csv` and `xlsx`.
/// FusionCharts produces no payload for the other formats in WKWebView.
/// Requesting an unavailable format reports an `export-unsupported` error
/// rather than hanging or returning an empty file.
abstract class FusionChartsExportFormat {
  static const String png = 'png';
  static const String jpg = 'jpg';
  static const String svg = 'svg';
  static const String pdf = 'pdf';
  static const String csv = 'csv';
  static const String xlsx = 'xlsx';

  static const List<String> all = <String>[png, jpg, svg, pdf, csv, xlsx];

  static bool isValid(String format) => all.contains(format.toLowerCase());
}
