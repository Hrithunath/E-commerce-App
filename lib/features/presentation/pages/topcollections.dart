import 'package:flutter/material.dart';

class Topcollections extends StatelessWidget {
  const Topcollections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Categories'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          childAspectRatio: 1, 
          crossAxisSpacing: 10, 
          mainAxisSpacing: 10, 
        ),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.category, 
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(
                  'Category ${index + 1}', 
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
        itemCount: 10, 
      ),
    );
  }
}
