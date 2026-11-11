import 'package:flutter/material.dart';

import '../app_state.dart';
import '../l10n.dart';
import '../models.dart';
import 'test_setup_screen.dart';

class SubjectScreen extends StatelessWidget {
  final Subject subject;
  const SubjectScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subjectName(subject.id))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _card(context, tr('ready_materials'), Icons.fact_check, 'materials'),
            const SizedBox(height: 12),
            _card(context, tr('textbooks'), Icons.menu_book, 'textbooks'),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, String title, IconData icon, String kind) {
    final count = app.assetBookCount(subject.id, kind);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BookListScreen(
              subject: subject,
              kind: kind,
              title: title,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: subject.color.withAlpha(40),
                child: Icon(icon, size: 32, color: subject.color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(tr('books_count', {'n': count.toString()})),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class BookListScreen extends StatelessWidget {
  final Subject subject;
  final String kind;
  final String title;
  const BookListScreen({
    super.key,
    required this.subject,
    required this.kind,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final books = app.assetBooks(subject.id, kind);
    return Scaffold(
      appBar: AppBar(title: Text('${subjectName(subject.id)} • $title')),
      body: SafeArea(
        child: books.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    tr('no_books'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: books.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final b = books[i];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.picture_as_pdf, color: subject.color),
                      title: Text(b.title),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => TestSetupScreen(book: b)),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
