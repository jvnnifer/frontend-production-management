import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jago_app/api_services/ApiService.dart';
import 'package:jago_app/components/HomeBarChartWrapper.dart';
import 'package:jago_app/components/CollapsibleSidebar.dart';
import 'package:jago_app/controller/SidebarController.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SidebarController sidebar = Get.find<SidebarController>();

  // Key untuk chart di layar
  final GlobalKey liveChartKey = GlobalKey();

  // Key untuk chart tersembunyi (untuk diambil gambar ke PDF)
  final GlobalKey hiddenChartKey = GlobalKey();

  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> prepOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      orders = await ApiService().loadOrders();
      prepOrders = await ApiService().loadPreparationOrders();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error load dashboard data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> generatePdf() async {
    await Future.delayed(const Duration(milliseconds: 800));

    Uint8List? chartImage;
    try {
      RenderRepaintBoundary? boundary = hiddenChartKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary != null) {
        var image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ImageByteFormat.png);
        chartImage = byteData?.buffer.asUint8List();
      }
    } catch (e) {
      print("Error capturing chart: $e");
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Laporan Produksi ${DateTime.now().year}',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),

          // Chart
          pw.Text(
            'Hasil Produksi',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          if (chartImage != null)
            pw.Image(pw.MemoryImage(chartImage), height: 200),
          pw.SizedBox(height: 20),

          // Orders Table
          pw.Text(
            'Daftar Order',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: ['Order No', 'Deadline', 'Dept Store', 'Notes', 'Status'],
            data: orders
                .map((o) => [
                      o['orderNo'].toString(),
                      o['deadline'] ?? '',
                      o['deptStore'] ?? '',
                      o['notes'] ?? '',
                      o['status'] ?? ''
                    ])
                .toList(),
          ),
          pw.SizedBox(height: 20),

          // Preparation Orders Table
          pw.Text(
            'Preparation Orders',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: [
              'PO Id',
              'Approval PIC',
              'Note',
              'Production PIC',
              'Status',
              'Order No'
            ],
            data: prepOrders
                .map((p) => [
                      p['id'].toString(),
                      p['approvalPic'] ?? '',
                      p['note'] ?? '',
                      p['productionPic'] ?? '',
                      p['status'] ?? '',
                      p['orders']['orderNo'].toString(),
                    ])
                .toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF80CBC4)),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          height: 100,
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Obx(() => sidebar.isCollapsed.value
                                  ? IconButton(
                                      icon: const Icon(Icons.menu,
                                          color: Colors.black),
                                      onPressed: sidebar.toggleSidebar,
                                    )
                                  : const SizedBox(width: 48)),
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Produksi Internal',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Text(
                            "Laporan Produksi ${DateTime.now().year}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Chart tampil di layar
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hasil Produksi',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 220,
                                child: HomeBarChartWrapper(
                                    globalKey: liveChartKey),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Orders Table
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Daftar Order',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Order No')),
                                      DataColumn(label: Text('Deadline')),
                                      DataColumn(label: Text('Dept Store')),
                                      DataColumn(label: Text('Notes')),
                                      DataColumn(label: Text('Status')),
                                    ],
                                    rows: orders
                                        .map(
                                          (o) => DataRow(
                                            cells: [
                                              DataCell(Text(
                                                  o['orderNo'].toString())),
                                              DataCell(
                                                  Text(o['deadline'] ?? '')),
                                              DataCell(
                                                  Text(o['deptStore'] ?? '')),
                                              DataCell(Text(o['notes'] ?? '')),
                                              DataCell(Text(o['status'] ?? '')),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Preparation Orders Table
                              const Text(
                                'Preparation Orders',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('PO Id')),
                                      DataColumn(label: Text('Approval PIC')),
                                      DataColumn(label: Text('Note')),
                                      DataColumn(label: Text('Production PIC')),
                                      DataColumn(label: Text('Status')),
                                      DataColumn(label: Text('Order No')),
                                    ],
                                    rows: prepOrders
                                        .map(
                                          (p) => DataRow(
                                            cells: [
                                              DataCell(
                                                  Text(p['id'].toString())),
                                              DataCell(
                                                  Text(p['approvalPic'] ?? '')),
                                              DataCell(Text(p['note'] ?? '')),
                                              DataCell(Text(
                                                  p['productionPic'] ?? '')),
                                              DataCell(Text(p['status'] ?? '')),
                                              DataCell(Text(p['orders']
                                                      ['orderNo']
                                                  .toString())),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        FloatingActionButton.extended(
                          onPressed: generatePdf,
                          icon: const Icon(Icons.picture_as_pdf,
                              color: Colors.white),
                          label: const Text(
                            "Generate PDF",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          backgroundColor: const Color(0xFF80CBC4),
                        ),
                      ],
                    ),
                  ),
                ),

          // Sidebar dan chart tersembunyi untuk screenshot
          Stack(
            children: [
              Obx(
                () => CollapsibleSidebar(
                  isCollapsed: sidebar.isCollapsed.value,
                  toggleSidebar: sidebar.toggleSidebar,
                  selectedRoute: sidebar.selectedRoute.value,
                  onSelected: sidebar.handleMenuTap,
                ),
              ),
              Positioned(
                left: -9999,
                top: -9999,
                child: SizedBox(
                  width: 1200,
                  height: 594,
                  child: HomeBarChartWrapper(
                    globalKey: hiddenChartKey,
                    scrollable: false,
                    fontScale: 3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
