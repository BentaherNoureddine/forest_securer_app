import 'package:flutter/material.dart';
import 'package:forst_ui/features/report/entities/category_model.dart';
import 'package:forst_ui/features/report/entities/report_model.dart';
import 'package:forst_ui/features/report/repositories/report_repository.dart';




class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late Future<List<Report>> _reportsFuture;

  Category currentCategory = Category.ALL;

   void doFilter(Category category){

  }

  @override
  void initState() {
    super.initState();
    _reportsFuture = ReportRepository.loadReports();
  }

  List<Widget> _buildGridCards(BuildContext context, List<Report> reports) {
    if (reports.isEmpty) {
      return const <Widget>[];
    }

    final ThemeData theme = Theme.of(context);

    return reports.map((report) {
      return GestureDetector(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Center(child: Text(report.title)),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        report.reporterId,
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            semanticLabel: "menu",
          ),
          onPressed: () {
            print("Menu button");
          },
        ),
        title: const Text('REPORTS '),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print('Search button');
            },
            icon: const Icon(
              Icons.search,
              semanticLabel: "search",
            ),
          ),
          IconButton(
            onPressed: () {
              doFilter(currentCategory);
            },
            icon: const Icon(
              Icons.tune,
              semanticLabel: "Filter",
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Report>>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reports available.'));
          } else {
            return GridView.count(
              crossAxisCount: 1,
              padding: const EdgeInsets.all(16),
              childAspectRatio: 8 / 9,
              children: _buildGridCards(context, snapshot.data!),
            );
          }
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
