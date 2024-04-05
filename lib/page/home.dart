import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.search)),
        IconButton(onPressed: (){}, icon: Icon(Icons.tune))
        // IconButton(onPressed: (){}, icon: SvgPicture)
      ], title: InkWell(
        onTap: (){
          print("click");
        },
        child: Row(
          children: [
            Text("Badger Market"),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ))
    );
  }
}