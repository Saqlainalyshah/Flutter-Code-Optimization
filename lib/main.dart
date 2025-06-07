import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MaterialApp(home: HomeScreen())));
}

final elements = StateProvider<List<int>>(
  (ref) => List.generate(50, (index) {
    return index;
  }),
);
final _index = StateProvider<int>((ref) => 0);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("Rebuilds.......");
    return Scaffold(
      appBar: AppBar(title: Text("App optimization")),
      body: Consumer(
        builder: (context, ref, child) => ListView.builder(
          itemCount: ref.watch(elements.select((item) => item.length)),
          itemBuilder: (context, index) {
            print("Listview Items rebuild $index");
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProviderScope(
                overrides: [_index.overrideWith((ref) => index)],
                child: buildButton(),
              ),
            );
          },
        ),
      ),
    );
  }
}

buildButton() {
  return Consumer(
    builder: (context, ref, child) {
      final indexOfItem = ref.read(_index);
      return ElevatedButton(
        onPressed: () {
          print("Length of List ${ref.read(elements).length}");
          final list = [...ref.read(elements)];
          int val = indexOfItem + 10;
          list[indexOfItem] = val;
          ref.read(elements.notifier).state = list; // Assign new list to state
        },
        child: Text("data ${ref.watch(elements)[indexOfItem]}"),
      );
    },
  );
}
