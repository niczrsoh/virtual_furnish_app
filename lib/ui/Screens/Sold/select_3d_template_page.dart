import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Select3DTemplatePage extends StatelessWidget {
  const Select3DTemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    List templates = [
      "Chair","Table","Cabinet","Drawer","Curtain","Baby Furniture"
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Select 3D Template"),
      ),
      body: Container(
        child: Center(
          child: //grid list to choose different type of 3d templates
          ListView.builder(
            itemCount: templates.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  //navigate to 3d template page
                  Navigator.pop(context,"${templates[index]}");
                },
                child: ListTile(
                  title: Text("3D Template : ${templates[index]}"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}