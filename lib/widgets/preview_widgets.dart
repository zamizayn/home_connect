import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sh_pdf/sh_pdf.dart';

class FullscreenImageViewer extends StatelessWidget {
  final String url;
  final bool isLocalFile;
  const FullscreenImageViewer({
    super.key,
    required this.url,
    this.isLocalFile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag: url,
            child: isLocalFile
                ? Image.file(
                    File(url),
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Image.network(
                    url,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class ActualPdfViewer extends StatelessWidget {
  final String title;
  final String url;
  const ActualPdfViewer({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CustomPdfViewer.url(url));
  }
}
