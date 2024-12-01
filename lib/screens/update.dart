import 'package:flutter/material.dart';
import 'package:todaysnews/db_connection/db_helper.dart';

class UpdateNews extends StatefulWidget {
  final int id;
  final String initialTitle;
  final String initialDescription;

  const UpdateNews({
    Key? key,
    required this.id,
    required this.initialTitle,
    required this.initialDescription,
  }) : super(key: key);

  @override
  State<UpdateNews> createState() => _UpdateNewsState();
}

class _UpdateNewsState extends State<UpdateNews> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description cannot be empty')),
      );
      return;
    }

    final updatedValues = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };

    await DatabaseHelper.instance.updateNews(widget.id, updatedValues);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Saved News',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title input
              const Text(
                'Edit Title',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter title',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Description input
              const Text(
                'Edit Description',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter description',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5E8AA),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
