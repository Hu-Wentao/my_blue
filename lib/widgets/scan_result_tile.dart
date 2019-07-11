import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'none_border_color_expansion_tile.dart';
import 'radius_text_botton_widget.dart';

/// 扫描结果 片
class ScanResultTile extends StatelessWidget {
  final ScanResult result;
  final VoidCallback onTap;

  const ScanResultTile({
    Key key,
    this.result,
    this.onTap,
  }) : super(key: key);

  //##########################################################################################
  @override
  Widget build(BuildContext context) {
    final String advertiseName = result.advertisementData.localName;
    final String deviceName = result.device.name;
    final String serviceUuids = result.advertisementData.serviceUuids.join(",");


    print("####################################");
    print("advertiseName 广播名: $advertiseName");
    print("deviceName 设备名称: $deviceName");


    return NoneBorderColorExpansionTile(
      title: _buildTitle(context, deviceName),
      leading: _buildLeading(context),
      trailing: _buildTailing(context),
      children: <Widget>[
        _buildAdvertiseRow(
            context, '广播名', advertiseName),
        _buildAdvertiseRow(context, 'Tx Power Level',
            '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
        _buildAdvertiseRow(
            context,
            'Manufacturer Data',
            getNiceManufacturerData(
                    result.advertisementData.manufacturerData) ??
                'N/A'),
        _buildAdvertiseRow(
            context,
            'Service UUIDs',
            (result.advertisementData.serviceUuids.isNotEmpty)
                ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
                : 'N/A'),
        _buildAdvertiseRow(context, 'Service Data',
            getNiceServiceData(result.advertisementData.serviceData) ?? 'N/A'),
      ],
    );
  }

  Widget _buildLeading(BuildContext context) {
    if(result.advertisementData.localName.startsWith("RaceHF")){

    }


    return Icon(
      Icons.bluetooth,
      color: result.advertisementData.connectable
          ? Theme.of(context).primaryColor
          : Colors.grey,
    );
  }

  // todo deviceName 待测试
  Widget _buildTitle(BuildContext context, String deviceName) {
    final Text deviceName = ( result.device.name.length > 0)
        ? Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          )
        : Text("N/A");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            deviceName,
            Text(
              result.device.id.toString(),
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
        // 信号强度
        Text(result.rssi.toString()),
      ],
    );
  }

  Widget _buildTailing(BuildContext context) {
    return RadiusButton(
      child: Text(
        '连接',
        style: TextStyle(fontSize: 12),
      ),
      onPressed: (result.advertisementData.connectable) ? onTap : null,
    );
  }

  Widget _buildAdvertiseRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }
}
