import 'package:flutter/material.dart';
import 'package:instagram_thecodingpapa/constants/size.dart';

class ShareSwitch extends StatefulWidget {
  final String label;

  const ShareSwitch({Key key, this.label}) : super(key: key);

  @override
  _ShareSwitchState createState() => _ShareSwitchState();
}

class _ShareSwitchState extends State<ShareSwitch> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            widget.label,
            textScaleFactor: 1.2,
          )),
          Switch(
              value: checked,
              onChanged: (change) {
                setState(() {
                  checked = change;
                });
              })
        ],
      ),
    );
  }
}
