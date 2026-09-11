import 'dart:convert';
import 'dart:typed_data';

import '../security/fusion_charts_sanitizer.dart';

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

  /// A file name the application may use.
  ///
  /// Sanitised by this package before it reaches the application: it is always
  /// a bare name with the requested extension, contains no path separator, and
  /// cannot escape a directory it is joined to. The raw value originates in
  /// the page, driven by the chart's `exportFileName` configuration, so it is
  /// treated as untrusted input rather than as a trusted hint.
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
  /// [requestedFormat] is the format the application asked for. When it is a
  /// supported format it wins over the one reported by the payload, so the
  /// file-name extension allowlist is never fed by the same untrusted source
  /// it is meant to constrain.
  static FusionChartsExport? fromPayload(
    Map<String, dynamic> payload, {
    required String fallbackFormat,
    String? requestedFormat,
  }) {
    final String reported =
        (payload['format'] as String?)?.toLowerCase() ?? fallbackFormat;
    final String format = requestedFormat != null &&
            FusionChartsExportFormat.isValid(requestedFormat)
        ? requestedFormat.toLowerCase()
        : reported;
    final String mime =
        (payload['mime'] as String?) ?? 'application/octet-stream';

    // The page controls this value. Reduce it to a safe bare name before it
    // reaches the application, which may join it straight to a directory.
    final String name = sanitizeExportFileName(
      (payload['fileName'] as String?) ?? 'chart',
      format: FusionChartsExportFormat.isValid(format) ? format : 'bin',
    );

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
