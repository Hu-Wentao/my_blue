import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'descriptor_tile.dart';
import 'none_border_color_expansion_tile.dart';

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final TextField sendBox;  // 发送消息输入框
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;

  const CharacteristicTile(
      {Key key,
      this.characteristic,
      this.descriptorTiles,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed,
      this.sendBox})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<int>>(
      stream: characteristic.value,           // 读取结果
      initialData: characteristic.lastValue,  // 存放上一次的结果
      builder: (c, snapshot) {
        final value = snapshot.data;
        return NoneBorderColorExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    '特征: 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.body1.copyWith(
                        color: Theme.of(context).textTheme.caption.color)),
              ],
            ),
            /// 此处显示接受到的信息
            subtitle: Text(value.toString()),

            contentPadding: EdgeInsets.all(0.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.5),
                ),
                onPressed: onReadPressed,
              ),
              IconButton(
                icon: Icon(Icons.file_upload,
                    color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
                onPressed: onWritePressed,
              ),
              IconButton(
                icon: Icon(
                    characteristic.isNotifying
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: characteristic.isNotifying
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).iconTheme.color.withOpacity(0.5)),
                onPressed: onNotificationPressed,
              ),
            ],
          ),
          children: descriptorTiles??<Widget>[sendBox],
//          children: descriptorTiles,  ########################### ######################
        );
      },
    );
  }
}
