import 'package:flutter/material.dart';

class ColorService extends ChangeNotifier {
  int _redTapCount = 0;
  int _blueTapCount = 0;

  int get redTapCount => _redTapCount;
  int get blueTapCount => _blueTapCount;

  void incrementRedTapCount() {
    _redTapCount++;
    notifyListeners();
  }

  void incrementBlueTapCount() {
    _blueTapCount++;
    notifyListeners();
  }
}

final colorService = ColorService();

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));
}

enum CardType { red, blue }

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
        children: [
          ColorTap(type: CardType.red),
          ColorTap(type: CardType.blue),
        ],
      ),
    );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;

  const ColorTap({super.key, required this.type});

  Color get backgroundColor => type == CardType.red ? Colors.red : Colors.blue;

  void onTap() {
    if (type == CardType.red) {
      colorService.incrementRedTapCount();
    } else {
      colorService.incrementBlueTapCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: colorService,
      builder: (context, child) {
        final tapCount = type == CardType.red
            ? colorService.redTapCount
            : colorService.blueTapCount;
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
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
              children: [
                Text(
                  'Red Taps: ${colorService.redTapCount}',
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  'Blue Taps: ${colorService.blueTapCount}',
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
