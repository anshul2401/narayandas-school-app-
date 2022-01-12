import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_fees.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class ParentsList extends StatefulWidget {
  const ParentsList({Key? key}) : super(key: key);

  @override
  _ParentsListState createState() => _ParentsListState();
}

class _ParentsListState extends State<ParentsList> {
  @override
  Widget build(BuildContext context) {
    var parentsProvider = Provider.of<ParentsProvider>(context, listen: false);
    List<ParentModel> parents = parentsProvider.parents.toList();
    return Scaffold(
      appBar: getAppBar('Parents List', context),
      body: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: parents.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddFees(parentModel: parents[index])));
                  },
                  child:
                      getBoldText(parents[index].fatherName, 13, Colors.black));
            }),
      ),
    );
  }
}
