import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrCodePage extends StatelessWidget {
  final String data;
  QrCodePage(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xF7131313),
      appBar: AppBar(
        backgroundColor: Color(0xF7131313),
      ),
      body: _body(),
    );
  }

  _body() {
    return Center(
      child: Container(
        color: Colors.white,
        height: 400.h,
        width: 400.w,
        child: Center(
          child: QrImage(
            data: data,
            version: QrVersions.auto,
            size: 400.sp,
          ),
        ),
      ),
    );
  }
}
