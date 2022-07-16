import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResumoCard extends StatelessWidget {
  
  final int qtd;
  final String prato;
  final double total;
  final String observacao;
  
  ResumoCard(this.qtd,this.prato,this.total, this.observacao);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 25.w,
                  child: Text(
                    qtd.toString(),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        fontSize: 20.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 230.w,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    prato,
                    style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                Container(
                  width: 95.w,
                  alignment: Alignment.centerRight,
                  child: Text(
                    "R\$"+total.toStringAsFixed(2),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 35.w),
                child: Container(
                  height: observacao.isEmpty?0:20.h,
                  width: 200.w,
                  child: Text(
                    "\""+observacao+"\"",
                    style: GoogleFonts.roboto(
                      color: Colors.grey.shade900.withOpacity(0.7),
                      fontSize: 18.sp
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
