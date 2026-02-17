import 'package:flutter/material.dart';

class ColorService extends ChangeNotifier {
  final Map<CardType, int> _tapCounts = {
    for (var type in CardType.values) type: 0,
  };

  int getTapCount(CardType type) => _tapCounts[type]!;

  void incrementTapCount(CardType type) {
    _tapCounts[type] = _tapCounts[type]! + 1;
    notifyListeners();
  }

  Map<CardType, int> get allTapCount => _tapCounts;
}

final colorService = ColorService();

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));
}

enum CardType { red, green, yellow, blue }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 ? ColorTapsScreen() : StatisticsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.tap_and_play),
            label: 'Taps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}

class ColorTapsScreen extends StatelessWidget {
  const ColorTapsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Taps')),
      body: Column(
        children: CardType.values.map((type) => ColorTap(type: type)).toList(),
      ),
    );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;

  const ColorTap({super.key, required this.type});

  Color get buttonBackgroundColor {
    switch (type) {
      case CardType.blue:
        return Colors.blue;
      case CardType.green:
        return Colors.green;
      case CardType.red:
        return Colors.red;
      case CardType.yellow:
        return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: colorService,
      builder: (context, child) {
        final tapCount = colorService.getTapCount(type);
        return GestureDetector(
          onTap: () => colorService.incrementTapCount(type),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: buttonBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: 100,
            child: Center(
              child: Text(
                'Taps: $tapCount',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Center(
        child: ListenableBuilder(
          listenable: colorService,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: colorService.allTapCount.entries
                  .map(
                    (entry) => Text(
                        '${entry.key.name.toUpperCase()} Taps: ${entry.value}',
                        style: const TextStyle(fontSize: 24),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
