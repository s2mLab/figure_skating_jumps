import 'package:csv/csv.dart';
import 'package:figure_skating_jumps/enums/x_sens_dot_csv_columns.dart';

import '../models/xsens_dot_data.dart';

class CsvCreator {
    static String createXSensDotCsv(List<XSensDotData> extractedData) {
      List<List<dynamic>> rows = <List<dynamic>>[];

      //Header
      List<String> header = [];
      for(var column in XSensDotCsvColumns.values) {
        header.add(column.title);
      }

      rows.add(header);

      //Data
      for(var xSensDotData in extractedData) {
        List<dynamic> row = [];
        row.add(xSensDotData.id);
        row.add(xSensDotData.time);

        //Euler angles (X, Y, Z)
        row.add(xSensDotData.euler[0]);
        row.add(xSensDotData.euler[1]);
        row.add(xSensDotData.euler[2]);

        //Acceleration (X, Y, Z)
        row.add(xSensDotData.acc[0]);
        row.add(xSensDotData.acc[1]);
        row.add(xSensDotData.acc[2]);

        //Gyr (X, Y, Z)
        row.add(xSensDotData.gyr[0]);
        row.add(xSensDotData.gyr[1]);
        row.add(xSensDotData.gyr[2]);

        rows.add(row);
      }

      return const ListToCsvConverter().convert(rows);
    }
}