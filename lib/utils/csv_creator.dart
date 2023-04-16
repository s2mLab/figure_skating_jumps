import 'package:csv/csv.dart';
import 'package:figure_skating_jumps/enums/x_sens/x_sens_dot_csv_columns.dart';
import 'package:figure_skating_jumps/models/x_sens_dot_data.dart';

class CsvCreator {
  static String createXSensDotCsv(List<XSensDotData> extractedData) {
    List<List<dynamic>> rows = <List<dynamic>>[];

    //Header
    List<String> header = [];
    for (var column in XSensDotCsvColumns.values) {
      header.add(column.title);
    }

    rows.add(header);

    //Data
    for (var xSensDotData in extractedData) {
      List<dynamic> row = [];
      row.add(xSensDotData.id);
      row.add(xSensDotData.time);

      //Euler angles (X, Y, Z)
      for (var eul in xSensDotData.euler) {
        row.add(eul);
      }

      //Acceleration (X, Y, Z)
      for (var acc in xSensDotData.acc) {
        row.add(acc);
      }

      //Gyr (X, Y, Z)
      for (var gyr in xSensDotData.gyr) {
        row.add(gyr);
      }

      rows.add(row);
    }

    return const ListToCsvConverter().convert(rows);
  }
}
