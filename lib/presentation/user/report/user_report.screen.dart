import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:unjabbed_admin/domain/core/interfaces/widget/loading.dart';
import 'package:unjabbed_admin/domain/core/model/user_model.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/Global.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';
import 'package:unjabbed_admin/presentation/user/report/controllers/user_report.controller.dart';

import 'info/info.dart';

class UserReportScreen extends StatefulWidget {
  @override
  _UserReportScreen createState() => _UserReportScreen();
}

class _UserReportScreen extends State<UserReportScreen> {
  List reportedUserProfileList = [];
  var user = [];
  // Document? lastVisible;
  bool sort = true;
  bool isLoading = true;
  int totalDoc = 0;
  int documentLimit = 25;
  var controller = Get.put(UserReportController());
  CollectionReference<Map<String, dynamic>> collectionReference = queryCollectionDB("Users");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchReportedUserList();
    });

    // getuserList();
  }

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController searchctrlr = TextEditingController();

  fetchReportedUserList() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    dynamic resultant = await controller.getReportedUser();

    if (resultant == null) {
      print('unable to retrieve');
    } else {
      // setState(() {
      reportedUserProfileList = resultant;
      // });
      debugPrint("reported data---->${reportedUserProfileList.first}");
    //  print(reportedUserProfileList.length);
    }
    totalDoc = reportedUserProfileList.length;
    getuserList();
  }

  Future<void> getuserList() async {
    for (int i = 0; i < (reportedUserProfileList).length; i++) {
      // print(reportedUserProfileList[i]['victim_id']);
      if (reportedUserProfileList[i] == null) {
        continue;
      }
      var reportedid = reportedUserProfileList[i]['victim_id'];
      var reportedby = reportedUserProfileList[i]['reported_by'];
      debugPrint(reportedid + " : " + reportedby.toString());
      try {
        DocumentSnapshot<Map<String, Object?>> docreportid =
            await collectionReference.doc(reportedid).get();
        DocumentSnapshot<Map<String, Object?>> docreportby =
            await collectionReference.doc(reportedby).get();
        user.add({
          'Reportedby': docreportby['UserName'],
          'reason': reportedUserProfileList[i]['reason'],
          "ReportedDate":reportedUserProfileList[i]['timestamp'],
          'UserData': UserModel.fromJson(docreportid.data()!)
        });
      } catch (e) {
        if (kDebugMode) {
          print("getuserList---->$e");
        }
      }
    }
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
    // return user;
  }

  Widget userlists(user) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: isLoading
          ? Center(child: loadingWidget(null, null, isloadingText: true))
          : Column(
              children: [
                Container(
                  width: Get.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    child: DataTable(
                      sortAscending: sort,
                      sortColumnIndex: 2,
                      columnSpacing: Get.width * .052,

                      columns: [
                        DataColumn(
                          label: Text("Images"),
                        ),
                        DataColumn(
                          label: Text("Name"),
                        ),
                        DataColumn(
                          label: Text("Gender"),
                        ),
                        DataColumn(label: Text("Phone Number")),
                        DataColumn(label: Text("User_id")),
                        DataColumn(label: Text("view")),
                        DataColumn(label: Text("Reported By")),
                        DataColumn(label: Text("Reported date")),
                        DataColumn(label: Text("Reported reason")),
                      ],
                      rows: [
                        for (var i in user)
                          DataRow(
                            cells: [
                              DataCell(
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: CircleAvatar(
                                    child: i['UserData'].imageUrl[0] != null
                                        ? Image.network(
                                            (i['UserData']
                                                        .imageUrl[0]
                                                        .runtimeType ==
                                                    String)
                                                ? i['UserData'].imageUrl[0]
                                                : i['UserData'].imageUrl[0]
                                                    ['url'],
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Text('');
                                            },
                                          )
                                        : Container(),
                                    backgroundColor: Colors.grey,
                                    radius: 18,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text("${i['UserData'].name}"),
                              ),
                              DataCell(
                                Text("${i['UserData'].gender}"),
                              ),
                              DataCell(
                                Text("${i['UserData'].phoneNumber}"),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Container(
                                      width: 150,
                                      child: Text(
                                        "${i['UserData'].id}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.content_copy,
                                        size: 20,
                                      ),
                                      tooltip: "copy",
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: "${i['UserData'].id}",
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.fullscreen),
                                  tooltip: "open profile",
                                  onPressed: () async {
                                    var _isdelete = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Info(i['UserData']),
                                      ),
                                    );
                                    if (_isdelete != null && _isdelete) {
                                      Global().showInfoDialog(
                                        'Deleted',
                                      );

                                      searchctrlr.clear();
                                      searchReasultfuture = null;
                                      user.removeWhere((element) =>
                                          element.id == i['UserData'].id);
                                    }
                                  },
                                ),
                              ),
                              DataCell(
                                Text("${i['Reportedby']}"),
                              ),  DataCell(
                                Text("${DateFormat('dd-MM-yyyy').format(i['ReportedDate'].toDate())}"),
                              ),DataCell(
                                Text("${i['reason']}"),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                searchReasultfuture != null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 12,
                                ),
                                onPressed: () {}),
                            Text(
                                "${user.length >= documentLimit ? user.length - documentLimit : 0}-${user.length - 1} of $totalDoc  "),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
              ],
            ),
    );
  }

  var results = [];
  var r = [];
  Future<QuerySnapshot<Map<String, Object?>>>? searchReasultfuture;
  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  searchuser(String query) {
    if (query.trim().length > 0) {
      Future<QuerySnapshot<Map<String, Object?>>> users = collectionReference
          .where(
            isNumeric(query) ? 'phoneNumber' : 'UserName',
            isEqualTo: query,
          )
          .get();

      setState(() {
        searchReasultfuture = users;
      });
    }
  }

  Widget buildSearchresults() {
    return FutureBuilder(
      future: searchReasultfuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                )),
              ),
              Text("Searching......"),
            ],
          );
        }

        if ((snapshot.data?.docs ?? []).isNotEmpty) {
          results.clear();

          snapshot.data?.docs.forEach((DocumentSnapshot<Map<String, Object?>> doc) async {
            if (kDebugMode) {
              print(doc.data());
            }
            if (await doc.exists) {
              var t = user.map((e) {
                // if (doc.data['userId'] == e['UserData'].id) {
                //   var reportername = e['Reportedby'];
                //   var usert22 = User.fromDocument(doc);
                //   results
                //       .add({'UserData': usert22, 'Reportedby': reportername});
                // }
                Map<String, dynamic> data = doc.data()!;
                if (data['userId'] == e['UserData'].id) {
                  var reportername = e['Reportedby'];
                  var usert22 = UserModel.fromJson(data);
                  results
                      .add({'UserData': usert22, 'Reportedby': reportername});
                }
              });
              print(t);
            }
          });

          return userlists(results);
        }
        return Center(child: Text("no data found"));
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     "Reported Users List",
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   actions: [
          
      //   ],
      // ),
      body:
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Reported Users List",style: TextStyle(fontSize: 20),),
                      ),
                  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .3,
                  child: Card(
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      controller: searchctrlr,
                      decoration: InputDecoration(
                          hintText: "Search by name or phone number",
                          filled: true,
                          prefixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () => searchuser(searchctrlr.text)),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchctrlr.clear();
                              setState(() {
                                searchReasultfuture = null;
                              });
                            },
                          )),
                      onFieldSubmitted: searchuser,
                    ),
                  ),
            ),
          ),
                ],
              ),
              Expanded(child: searchReasultfuture == null ? userlists(user) : buildSearchresults()),
            ],
          ),
    );
  }
}
