import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha com Imagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeHomePage(),
    );
  }
}

class TicTacToeHomePage extends StatefulWidget {
  @override
  _TicTacToeHomePageState createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  List<String> board = List.generate(9, (index) => '');
  bool isPlayer1Turn = true;
  String winner = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/oceano.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double boardSize = constraints.maxWidth < constraints.maxHeight
                ? constraints.maxWidth
                : constraints.maxHeight * 0.7;

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Jogo da Velha - Oceano',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: boardSize,
                      height: boardSize,
                      child: _buildBoard(),
                    ),
                    if (winner.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          winner == 'Empate' ? 'Empatou!' : '$winner ganhou!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (winner.isNotEmpty)
                      ElevatedButton(
                        onPressed: _resetGame,
                        child: Text('Reiniciar Jogo'),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: _buildTile,
        itemCount: 9,
      ),
    );
  }

  Widget _buildTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _onTileTapped(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: _buildImage(index),
        ),
      ),
    );
  }

  Widget _buildImage(int index) {
    String imageName = board[index];
    if (imageName.isNotEmpty) {
      return Image.asset('assets/$imageName.png');
    }
    return Container();
  }

  void _onTileTapped(int index) {
    if (board[index].isNotEmpty || winner.isNotEmpty) {
      return;
    }

    setState(() {
      board[index] = isPlayer1Turn ? 'barco' : 'onda';
      isPlayer1Turn = !isPlayer1Turn;
      winner = _checkWinner();
    });
  }

  String _checkWinner() {
    const List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      String a = board[combination[0]];
      String b = board[combination[1]];
      String c = board[combination[2]];

      if (a.isNotEmpty && a == b && a == c) {
        return a == 'barco' ? 'Jogador 1' : 'Jogador 2';
      }
    }

    if (!board.contains('')) {
      return 'Empate';
    }

    return '';
  }

  void _resetGame() {
    setState(() {
      board = List.generate(9, (index) => '');
      isPlayer1Turn = true;
      winner = '';
    });
  }
}
