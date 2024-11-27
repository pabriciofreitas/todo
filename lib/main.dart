import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/infra/local/local.dart';

import 'presentation/presentations/to_do/to_do.dart';
import 'ui/pages/to_do/to_do_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ProviderToDoPresenter(
                repository: RespositorySharedPreferesAdapter())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const ToDoListPage(),
      ),
    );
  }
}
