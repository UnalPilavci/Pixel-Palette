import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../themes/app_theme.dart';
import '../services/color_service.dart';
import '../components/color_tile.dart';
import '../components/my_drawer.dart';
import '../utils/color_utils.dart';
import '../components/palette_share_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  img.Image? _decodedImage;
  List<Color> _palette = [];
  bool _isLoading = false;
  Color? _hoverColor;
  Offset? _hoverPos;
  bool _isPipetteActive = false;
  List<Offset> _highlightPoints = [];
  bool _isHighlighting = false;
  final GlobalKey _shareCardKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSharing = false;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isLoading = true;
        _highlightPoints.clear();
        _palette.clear();
      });

      await _extractColors(File(pickedFile.path));

      final bytes = await File(pickedFile.path).readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage != null) {
        _decodedImage = img.copyResize(originalImage, width: 300);
      }
    }
  }

  Future<void> _extractColors(File imageFile) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      FileImage(imageFile),
      size: const Size(200, 200),
      maximumColorCount: 20,
    );

    setState(() {
      _palette = generator.paletteColors.map((e) => e.color).take(10).toList();
      _isLoading = false;
    });
  }

  void _findColorLocations(Color targetColor) {
    if (_decodedImage == null) return;
    List<Offset> points = [];
    final int width = _decodedImage!.width;
    final int height = _decodedImage!.height;
    const int tolerance = 40;
    setState(() { _isHighlighting = true; });
    final int targetR = (targetColor.r * 255).toInt();
    final int targetG = (targetColor.g * 255).toInt();
    final int targetB = (targetColor.b * 255).toInt();

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = _decodedImage!.getPixel(x, y);
        final num r = pixel.r;
        final num g = pixel.g;
        final num b = pixel.b;
        final distance = sqrt(pow(r - targetR, 2) + pow(g - targetG, 2) + pow(b - targetB, 2));

        if (distance < tolerance) {
          points.add(Offset(x / width, y / height));
        }
      }
    }
    setState(() { _highlightPoints = points; });
  }
  void _clearHighlight() {
    setState(() {
      _isHighlighting = false;
      _highlightPoints.clear();
    });
  }

  void _updatePixelColor(Offset localPosition, Size widgetSize) {
    if (_decodedImage == null) return;
    double scaleX = _decodedImage!.width / widgetSize.width;
    double scaleY = _decodedImage!.height / widgetSize.height;
    int pixelX = (localPosition.dx * scaleX).toInt();
    int pixelY = (localPosition.dy * scaleY).toInt();
    if (pixelX < 0 || pixelX >= _decodedImage!.width || pixelY < 0 || pixelY >= _decodedImage!.height) return;
    final pixel = _decodedImage!.getPixel(pixelX, pixelY);
    Color color = Color.fromARGB(255, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
    setState(() {
      _hoverColor = color;
      _hoverPos = localPosition;
      _isPipetteActive = true;
    });
  }

  Future<void> _captureAndSharePng() async {
    setState(() { _isSharing = true; });
    try {
      RenderRepaintBoundary boundary = _shareCardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/pixel_palette_card.png').create();
      await file.writeAsBytes(pngBytes);

      setState(() { _isSharing = false; });
      await Share.shareXFiles([XFile(file.path)], text: 'Bu harika renk paletini Pixel Palette ile buldum! 🎨');
    } catch (e) {
      debugPrint(e.toString());
      setState(() { _isSharing = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hata oluştu.")));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      body: Stack(
        children: [
      Container(
      decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1A2530),
          Color(0xFF000000),
        ],
      ),
    ),
    ),
    SafeArea(
    child: Column(
    children: [
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    IconButton(
    icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 30),
    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
    ),
    const Text(
    "Pixel Palette",
    style: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    ),
    ),
    IconButton(
    icon: _isSharing
    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
        : Icon(Icons.share_rounded, color: (_imageFile != null && _palette.isNotEmpty) ? Colors.white : Colors.white24),
    onPressed: (_imageFile != null && _palette.isNotEmpty && !_isSharing)
    ? _captureAndSharePng
        : null,
    ),
    ],
    ),
    ),
    Expanded(
    flex: 5,
    child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
    color: Colors.white.withValues(alpha: 0.05),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withValues(alpha: 0.3),
    blurRadius: 20,
    offset: const Offset(0, 10),
    ),
    ],
    ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: _imageFile == null
            ? Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_rounded, size: 70, color: Colors.white.withValues(alpha: 0.3)),
                const SizedBox(height: 15),
                Text(
                  "Analiz için bir fotoğraf yükle",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Fotoğraf Seç", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        )
        : Stack( // Resim Yüklüyse
    fit: StackFit.expand,
    children: [
    LayoutBuilder(
    builder: (context, constraints) {
    return GestureDetector(
    onPanStart: (details) => _updatePixelColor(details.localPosition, constraints.biggest),
    onPanUpdate: (details) => _updatePixelColor(details.localPosition, constraints.biggest),
    onPanEnd: (_) => setState(() => _isPipetteActive = false),

    child: Stack(
    fit: StackFit.expand,
    children: [
    Image.file(_imageFile!, fit: BoxFit.contain),
    if (_isHighlighting) CustomPaint(painter: HighlightPainter(points: _highlightPoints)),
    if (_isPipetteActive && _hoverPos != null && _hoverColor != null)
    Positioned(
    left: _hoverPos!.dx - 40,
    top: _hoverPos!.dy - 90,
    child: _buildMagnifier(_hoverColor!),
    ),
    ],
    ),
    );
    }
    ),
    Positioned(
    bottom: 15,
    right: 15,
    child: FloatingActionButton(
    onPressed: _pickImage,
    backgroundColor: AppTheme.primary,
    mini: true,
    child: const Icon(Icons.edit, color: Colors.black),
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    Expanded(
    flex: 6,
    child: Container(
    width: double.infinity,
    decoration: const BoxDecoration(
    color: AppTheme.surface,
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(40),
    topRight: Radius.circular(40),
    ),
    boxShadow: [
    BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, -5))
    ],
    ),
    child: Column(
    children: [
    Container(
    margin: const EdgeInsets.only(top: 15, bottom: 10),
    width: 50,
    height: 5,
    decoration: BoxDecoration(
    color: Colors.white24,
    borderRadius: BorderRadius.circular(10),
    ),
    ),
    Expanded(
    child: _isLoading
    ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : _palette.isEmpty
    ? Center(
    child: Text(
    "Renk paleti burada görünecek.",
    style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
    ),
    )
        : ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 10),
    itemCount: _palette.length,
    itemBuilder: (context, index) {
    final color = _palette[index];
    final isFav = ColorService.isFavorite(color);

    return GestureDetector(
    onLongPress: () => _findColorLocations(color),
    onLongPressEnd: (_) => _clearHighlight(),
    child: ColorTile(
    color: color,
    isFavorite: isFav,
    onFavoriteToggle: () {
    setState(() { ColorService.toggleFavorite(color); });
    },
    ),
    );
    },
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
          if (_imageFile != null && _palette.isNotEmpty)
            Transform.translate(
              offset: const Offset(-9999, 0),
              child: RepaintBoundary(
                key: _shareCardKey,
                child: PaletteShareCard(imageFile: _imageFile!, colors: _palette),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildMagnifier(Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 2)
            ],
          ),
          child: Center(
            child: Icon(Icons.add, color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
          child: Text(
            ColorUtils.toHex(color),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
class HighlightPainter extends CustomPainter {
  final List<Offset> points;
  HighlightPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()..color = Colors.greenAccent.withValues(alpha: 0.4)..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black.withValues(alpha: 0.7),
    );

    final double pixelSize = size.width / 300;
    for (var point in points) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(point.dx * size.width, point.dy * size.height),
          width: pixelSize * 2.5,
          height: pixelSize * 2.5,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}