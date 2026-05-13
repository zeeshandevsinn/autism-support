import 'dart:io';

void main() {
  final months = [
    'JAN','FEB','MAR','APR','MAY','JUN',
    'JUL','AUG','SEP','OCT','NOV','DEC'
  ];

  final dir = Directory('assets/months');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  for (final month in months) {
    final file = File('assets/months/${month.toLowerCase()}.svg');
    file.writeAsStringSync(_buildSvg(month));
    print('Created: ${file.path}');
  }

  print('\n✅ Done! All month SVGs generated.');
}

String _buildSvg(String label) {
  return '''
<svg width="320" height="180" viewBox="0 0 320 180"
xmlns="http://www.w3.org/2000/svg">

<defs>
<linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
<stop offset="0%" style="stop-color:#8EC5FC;stop-opacity:1" />
<stop offset="100%" style="stop-color:#E0C3FC;stop-opacity:1" />
</linearGradient>
</defs>

<rect width="320" height="180" rx="30" fill="url(#grad)" />

<text x="160" y="100"
text-anchor="middle"
fill="white"
font-size="60"
font-weight="bold"
font-family="Arial">
$label
</text>

</svg>
''';
}