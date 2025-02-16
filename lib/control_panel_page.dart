import 'package:flutter/material.dart';


class ControlPanelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: screenSize.height * 0.4,
          color: Colors.black12,
          child: Center(
            child: Text(
              'Camera Playback Screen',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Expanded(
          child: ControlPanel(),
        ),
      ],
    );
  }
}

class ControlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                print("İleri butonuna basıldı");
              },
              child: Icon(Icons.arrow_upward),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    print("Sol butonuna basıldı");
                  },
                  child: Icon(Icons.arrow_back),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Dönme butonuna basıldı");
                    },
                    child: Icon(Icons.rotate_right),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(30),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print("Sağ butonuna basıldı");
                  },
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                print("Geri butonuna basıldı");
              },
              child: Icon(Icons.arrow_downward),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(right: 10, top: 10),
            child: ElevatedButton(
              onPressed: () {
                print("Kamera butonuna basıldı");
              },
              child: Icon(Icons.camera_alt),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
