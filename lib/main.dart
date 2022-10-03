import 'package:flutter/material.dart';
import 'package:widgets/page/book_page.dart';
import 'package:widgets/repositories/book_repository.dart';

import 'model/book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late TextEditingController controller;
  late BookRepository bookRepository;
  List<Book> listBooks = [];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    bookRepository = BookRepository();
    listBooks = bookRepository.books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Book title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.blue, width: 1)
                )
              ),
              onChanged: searchBook,
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: listBooks.length,
                  itemBuilder: (context, index) {
                    final book = listBooks[index];

                    return ListTile(
                      leading: Image.network(book.urlImage, height: 50, width: 50, fit: BoxFit.cover,),
                      title: Text(book.title),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => BookPage(book: book)),
                      ),
                    );
                  }
              )
          )
        ],
      )
    );
  }

  void searchBook(String query) {
    final suggestions = listBooks.where((book) {
      final bookTitle = book.title.toLowerCase();
      final input = query.toLowerCase();

      return bookTitle.contains(input);
    }).toList();

    setState(() => listBooks = suggestions);
  }
}


class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = [
    'Brazil',
    'China',
    'India',
    'Russia',
    'USA',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
        onPressed: () {
          if(query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear))
  ]; // Para exibir o botao apóos o campo de consulta

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back)
  ); // Para exibir o botao antes do campo de consulta

  @override
  Widget buildResults(BuildContext context) => Center(
    child: Text(query, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),),
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();
    
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context);
            },
          );
        }
    );
  }
}



