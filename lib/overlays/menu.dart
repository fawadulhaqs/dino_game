import 'package:flutter/material.dart';
import 'package:my_first_game/main.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.black.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'HOME',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.white),
                ),
              ),
              const Divider(
                endIndent: 200,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: const Text('Highest Coins',
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                      trailing: Text('${sp?.getInt('coins') ?? 0}',
                          style: const TextStyle(
                              fontSize: 17, color: Colors.white)),
                    ),
                    ListTile(
                      title: const Text('Highest Score',
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                      trailing: Text('${sp?.getInt('score') ?? 0}',
                          style: const TextStyle(
                              fontSize: 17, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyGame()));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Let's Play",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
