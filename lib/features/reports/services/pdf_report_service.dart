import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hr_connect/features/attendance/models/attendance_model.dart';
import 'package:hr_connect/features/leave/models/leave_model.dart';
import 'package:hr_connect/features/reimbursement/models/reimbursement_model.dart';
import 'package:hr_connect/features/reports/controllers/reports_controller.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class PdfReportService {
  static final _dateFormat = DateFormat('dd MMM yyyy');
  static final _timeFormat = DateFormat('HH:mm');
  static final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static Future<void> generateAttendanceReport(
    BuildContext context,
    ReportData data,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) =>
            _buildHeader('Attendance Report', startDate, endDate),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildAttendanceSummary(data),
          pw.SizedBox(height: 20),
          _buildAttendanceTable(data.attendanceRecords),
        ],
      ),
    );

    await _showPdfPreview(context, pdf, 'attendance_report');
  }

  static Future<void> generateLeaveReport(
    BuildContext context,
    ReportData data,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader('Leave Report', startDate, endDate),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildLeaveSummary(data),
          pw.SizedBox(height: 20),
          _buildLeaveTable(data.leaveRecords),
        ],
      ),
    );

    await _showPdfPreview(context, pdf, 'leave_report');
  }

  static Future<void> generateFullReport(
    BuildContext context,
    ReportData data,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) =>
            _buildHeader('HR Connect Report', startDate, endDate),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildOverviewSection(data),
          pw.SizedBox(height: 30),
          pw.Header(level: 1, text: 'Attendance Summary'),
          _buildAttendanceSummary(data),
          pw.SizedBox(height: 20),
          _buildAttendanceTable(data.attendanceRecords.take(10).toList()),
          pw.SizedBox(height: 30),
          pw.Header(level: 1, text: 'Leave Summary'),
          _buildLeaveSummary(data),
          pw.SizedBox(height: 20),
          _buildLeaveTable(data.leaveRecords.take(10).toList()),
        ],
      ),
    );

    await _showPdfPreview(context, pdf, 'hr_full_report');
  }

  static Future<void> generateWorkingHoursReport(
    BuildContext context,
    ReportData data,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) =>
            _buildHeader('Working Hours Report', startDate, endDate),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildWorkingHoursSummary(data),
          pw.SizedBox(height: 20),
          _buildWorkingHoursTable(data.attendanceRecords),
        ],
      ),
    );

    await _showPdfPreview(context, pdf, 'working_hours_report');
  }

  static Future<void> generateReimbursementReport(
    BuildContext context,
    ReportData data,
    DateTime startDate,
    DateTime endDate,
    double totalBudget,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) =>
            _buildHeader('Reimbursement Report', startDate, endDate),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildReimbursementSummary(data, totalBudget),
          pw.SizedBox(height: 20),
          _buildReimbursementByTypeTable(data),
          pw.SizedBox(height: 20),
          _buildReimbursementTable(data.reimbursementRecords),
        ],
      ),
    );

    await _showPdfPreview(context, pdf, 'reimbursement_report');
  }

  static pw.Widget _buildHeader(
    String title,
    DateTime startDate,
    DateTime endDate,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'HR Connect',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.Text(
              'Generated: ${_dateFormat.format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          'Period: ${_dateFormat.format(startDate)} - ${_dateFormat.format(endDate)}',
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
        ),
        pw.Divider(thickness: 2, color: PdfColors.blue800),
        pw.SizedBox(height: 10),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'HR Connect System',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildOverviewSection(ReportData data) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Overview',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildMetricBox(
                'Total Employees',
                '${data.totalEmployees}',
                PdfColors.blue,
              ),
              _buildMetricBox(
                'Active',
                '${data.activeEmployees}',
                PdfColors.green,
              ),
              _buildMetricBox(
                'Attendance Rate',
                '${data.attendanceRate.toStringAsFixed(1)}%',
                PdfColors.teal,
              ),
              _buildMetricBox(
                'Avg Hours',
                '${data.avgWorkHours.toStringAsFixed(1)}h',
                PdfColors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMetricBox(String label, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAttendanceSummary(ReportData data) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Present',
            '${data.attendanceByStatus['present'] ?? 0}',
            PdfColors.green,
          ),
          _buildStatItem(
            'Late',
            '${data.attendanceByStatus['late'] ?? 0}',
            PdfColors.orange,
          ),
          _buildStatItem(
            'Absent',
            '${data.attendanceByStatus['absent'] ?? 0}',
            PdfColors.red,
          ),
          _buildStatItem(
            'On Leave',
            '${data.attendanceByStatus['leave'] ?? 0}',
            PdfColors.blue,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildLeaveSummary(ReportData data) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Pending', '${data.pendingLeaves}', PdfColors.orange),
          _buildStatItem('Approved', '${data.approvedLeaves}', PdfColors.green),
          _buildStatItem('Rejected', '${data.rejectedLeaves}', PdfColors.red),
          _buildStatItem(
            'Utilization',
            '${data.leaveUtilization.toStringAsFixed(1)}%',
            PdfColors.blue,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildWorkingHoursSummary(ReportData data) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Avg Hours',
            '${data.avgWorkHours.toStringAsFixed(1)}h',
            PdfColors.blue,
          ),
          _buildStatItem(
            'Total Records',
            '${data.attendanceRecords.length}',
            PdfColors.teal,
          ),
          _buildStatItem(
            'On Time',
            '${data.attendanceByStatus['present'] ?? 0}',
            PdfColors.green,
          ),
          _buildStatItem(
            'Late',
            '${data.attendanceByStatus['late'] ?? 0}',
            PdfColors.orange,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildReimbursementSummary(
    ReportData data,
    double totalBudget,
  ) {
    final remaining = totalBudget - data.paidReimbursementAmount;
    final utilization = (data.paidReimbursementAmount / totalBudget) * 100;

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.teal50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Budget Overview',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildMetricBox(
                'Total Budget',
                _currencyFormat.format(totalBudget),
                PdfColors.blue,
              ),
              _buildMetricBox(
                'Used',
                _currencyFormat.format(data.paidReimbursementAmount),
                PdfColors.orange,
              ),
              _buildMetricBox(
                'Remaining',
                _currencyFormat.format(remaining),
                remaining > 0 ? PdfColors.green : PdfColors.red,
              ),
              _buildMetricBox(
                'Utilization',
                '${utilization.toStringAsFixed(1)}%',
                PdfColors.teal,
              ),
            ],
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            'Request Status',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Pending',
                '${data.pendingReimbursements}',
                PdfColors.orange,
              ),
              _buildStatItem(
                'Approved',
                '${data.approvedReimbursements}',
                PdfColors.blue,
              ),
              _buildStatItem(
                'Paid',
                '${data.paidReimbursements}',
                PdfColors.green,
              ),
              _buildStatItem(
                'Rejected',
                '${data.rejectedReimbursements}',
                PdfColors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildReimbursementByTypeTable(ReportData data) {
    if (data.reimbursementByType.isEmpty) {
      return pw.Container();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Reimbursement by Type',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.teal800),
          cellPadding: const pw.EdgeInsets.all(6),
          cellStyle: const pw.TextStyle(fontSize: 10),
          headers: ['Type', 'Total Amount'],
          data: data.reimbursementByType.entries
              .map((e) => [e.key, _currencyFormat.format(e.value)])
              .toList(),
        ),
      ],
    );
  }

  static pw.Widget _buildReimbursementTable(List<ReimbursementModel> records) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.teal800),
      cellPadding: const pw.EdgeInsets.all(6),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headers: ['Employee', 'Type', 'Amount', 'Date', 'Status'],
      data: records
          .map(
            (r) => [
              r.employeeName,
              r.typeText,
              _currencyFormat.format(r.amount),
              _dateFormat.format(r.createdAt),
              r.statusText,
            ],
          )
          .toList(),
    );
  }

  static pw.Widget _buildStatItem(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
        ),
      ],
    );
  }

  static pw.Widget _buildAttendanceTable(List<AttendanceModel> records) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellPadding: const pw.EdgeInsets.all(6),
      cellStyle: const pw.TextStyle(fontSize: 10),
      headers: ['Employee', 'Date', 'Check In', 'Check Out', 'Status'],
      data: records
          .map(
            (r) => [
              r.employeeName,
              _dateFormat.format(r.date),
              r.checkIn != null ? _timeFormat.format(r.checkIn!) : '-',
              r.checkOut != null ? _timeFormat.format(r.checkOut!) : '-',
              r.statusText,
            ],
          )
          .toList(),
    );
  }

  static pw.Widget _buildLeaveTable(List<LeaveModel> records) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellPadding: const pw.EdgeInsets.all(6),
      cellStyle: const pw.TextStyle(fontSize: 10),
      headers: ['Employee', 'Type', 'Start', 'End', 'Days', 'Status'],
      data: records
          .map(
            (l) => [
              l.employeeName,
              l.typeText,
              _dateFormat.format(l.startDate),
              _dateFormat.format(l.endDate),
              '${l.days}',
              l.statusText,
            ],
          )
          .toList(),
    );
  }

  static pw.Widget _buildWorkingHoursTable(List<AttendanceModel> records) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellPadding: const pw.EdgeInsets.all(6),
      cellStyle: const pw.TextStyle(fontSize: 10),
      headers: [
        'Employee',
        'Date',
        'Check In',
        'Check Out',
        'Hours',
        'Overtime',
      ],
      data: records.map((r) {
        double hours = 0;
        double overtime = 0;
        if (r.checkIn != null && r.checkOut != null) {
          hours = r.checkOut!.difference(r.checkIn!).inMinutes / 60;
          overtime = hours > 8 ? hours - 8 : 0;
        }
        return [
          r.employeeName,
          _dateFormat.format(r.date),
          r.checkIn != null ? _timeFormat.format(r.checkIn!) : '-',
          r.checkOut != null ? _timeFormat.format(r.checkOut!) : '-',
          hours > 0 ? '${hours.toStringAsFixed(1)}h' : '-',
          overtime > 0 ? '+${overtime.toStringAsFixed(1)}h' : '-',
        ];
      }).toList(),
    );
  }

  static Future<void> _showPdfPreview(
    BuildContext context,
    pw.Document pdf,
    String fileName,
  ) async {
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: '$fileName.pdf',
    );
  }

  static Future<String?> savePdfToDevice(
    pw.Document pdf,
    String fileName,
  ) async {
    try {
      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());
      return file.path;
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      return null;
    }
  }
}
