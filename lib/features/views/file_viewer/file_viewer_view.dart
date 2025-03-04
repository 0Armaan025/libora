import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:epub_view/epub_view.dart';
import 'package:libora/utils/utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileViewerScreen extends StatefulWidget {
  final String filePath;
  final String fileName;

  const FileViewerScreen({
    Key? key,
    required this.filePath,
    required this.fileName,
  }) : super(key: key);

  @override
  _FileViewerScreenState createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  late bool isPdf;
  EpubController? _epubController;
  int _pdfTotalPages = 0;
  int _pdfCurrentPage = 0;
  bool _pdfLoaded = false;

  @override
  void initState() {
    super.initState();
    isPdf = widget.filePath.toLowerCase().endsWith('.pdf');

    if (!isPdf) {
      _initEpub();
    }
  }

  void _initEpub() async {
    _epubController = EpubController(
      document: EpubDocument.openFile(File(widget.filePath)),
    );
  }

  @override
  void dispose() {
    _epubController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: () {
              _showTextSettings(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              _handleBookmark(context);
            },
          ),
        ],
      ),
      body: isPdf ? _buildPdfView(context) : _buildEpubView(),
      bottomNavigationBar: isPdf ? _buildPdfBottomBar() : null,
    );
  }

  Widget _buildPdfView(BuildContext context) {
    return PDFView(
      filePath: widget.filePath,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      defaultPage: _pdfCurrentPage,
      onRender: (pages) {
        setState(() {
          _pdfTotalPages = pages!;
          _pdfLoaded = true;
        });
      },
      onViewCreated: (PDFViewController controller) {
        // PDF controller is created
      },
      onPageChanged: (int? page, int? total) {
        if (page != null) {
          setState(() {
            _pdfCurrentPage = page;
          });
        }
      },
      onError: (error) {
        showSnackBar(context, 'Error ${error.toString()}');
      },
    );
  }

  Widget _buildEpubView() {
    if (_epubController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return EpubView(
      controller: _epubController!,
    );
  }

  Widget _buildPdfBottomBar() {
    if (!_pdfLoaded) {
      return const SizedBox.shrink();
    }

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: _pdfCurrentPage > 0
                ? () {
                    setState(() {
                      _pdfCurrentPage = 0;
                    });
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: _pdfCurrentPage > 0
                ? () {
                    setState(() {
                      _pdfCurrentPage--;
                    });
                  }
                : null,
          ),
          Text(
            '${_pdfCurrentPage + 1} / $_pdfTotalPages',
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: _pdfCurrentPage < _pdfTotalPages - 1
                ? () {
                    setState(() {
                      _pdfCurrentPage++;
                    });
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: _pdfCurrentPage < _pdfTotalPages - 1
                ? () {
                    setState(() {
                      _pdfCurrentPage = _pdfTotalPages - 1;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _showTextSettings(BuildContext context) {
    // Show dialog for font size, theme, etc.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reader Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.text_increase),
              title: const Text('Font Size'),
              subtitle: Slider(
                value: 1.0,
                min: 0.5,
                max: 2.0,
                divisions: 6,
                onChanged: (value) {
                  // Implement font size change
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Theme'),
              trailing: DropdownButton<String>(
                value: 'Light',
                items: ['Light', 'Dark', 'Sepia']
                    .map((mode) => DropdownMenuItem(
                          value: mode,
                          child: Text(mode),
                        ))
                    .toList(),
                onChanged: (value) {
                  // Implement theme change
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleBookmark(BuildContext context) {
    // Logic to add/remove bookmarks
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isPdf
            ? 'Page ${_pdfCurrentPage + 1} bookmarked'
            : 'Current section bookmarked'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
