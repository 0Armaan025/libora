import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:epub_view/epub_view.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileViewerScreen extends StatefulWidget {
  final String mirrorLink;
  final String format;
  final String title;
  final VoidCallback action;

  const FileViewerScreen({
    Key? key,
    required this.mirrorLink,
    required this.format,
    required this.title,
    required this.action,
  }) : super(key: key);

  @override
  _FileViewerScreenState createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  late bool isPdf;
  EpubController? _epubController;
  PDFViewController? _pdfController;
  int _pdfTotalPages = 0;
  int _pdfCurrentPage = 0;
  bool _isLoading = true;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    isPdf = widget.format.toLowerCase() == 'pdf';
    _downloadAndOpenFile();
  }

  Future<void> _downloadAndOpenFile() async {
    try {
      final uri = Uri.parse(
          "https://5000-0armaan025-liboraapi-tiluu0ibikh.ws-us118.gitpod.io/api/scrape/download?mirrorUrl=${widget.mirrorLink}&title=${widget.title}&format=${widget.format}");
      final response = await http.get(uri);

      print('URI: $uri');
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response length: ${response.bodyBytes.length}');

      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${widget.title}.${widget.format}';
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);

        // Verify if the file is actually written
        if (await file.exists()) {
          print("File saved successfully at: $filePath");

          setState(() {
            _filePath = filePath;
            _isLoading = false;
          });

          // Initialize EPUB if needed
          if (!isPdf) {
            _epubController =
                EpubController(document: EpubDocument.openFile(file));
          }
        } else {
          throw Exception("File write failed.");
        }
      } else {
        throw Exception("Failed to download file: Invalid response.");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading file: ${e.toString()}")));
    }
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
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: widget.action,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filePath == null
              ? const Center(child: Text("Failed to load file"))
              : isPdf
                  ? _buildPdfView()
                  : _buildEpubView(),
    );
  }

  Widget _buildPdfView() {
    return SfPdfViewer.file(File(_filePath!));
  }

  Widget _buildEpubView() {
    return _epubController == null
        ? const Center(child: CircularProgressIndicator())
        : EpubView(controller: _epubController!);
  }
}
