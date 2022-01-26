import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_fees.dart';
import 'package:narayandas_app/admin/edit_parent.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/search_widget.dart';
import 'package:provider/provider.dart';

class SearchParent extends StatefulWidget {
  final bool isEdit;
  const SearchParent({Key? key, required this.isEdit}) : super(key: key);

  @override
  SearchParentState createState() => SearchParentState();
}

class SearchParentState extends State<SearchParent> {
  List<ParentModel> parents = [];
  String query = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<ParentsProvider>(context, listen: false)
        .fetchAndSetParents()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    var parentsProvider = Provider.of<ParentsProvider>(context, listen: false);
    parents = parentsProvider.parents;
  }

  @override
  Widget build(BuildContext context) {
    // var productProvider = Provider.of<Products>(context, listen: false);
    // products = productProvider.products;
    return Scaffold(
      appBar: getAppBar('Search Parent', context),
      body: isLoading
          ? getLoading(context)
          : Column(
              children: <Widget>[
                buildSearch(),
                Expanded(
                  child: ListView.builder(
                    itemCount: parents.length,
                    itemBuilder: (context, index) {
                      final parent = parents[index];

                      return buildProduct(parent);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search father name or number or email',
        onChanged: searchParent,
      );

  Widget buildProduct(ParentModel parentModel) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
            )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getBoldText(parentModel.fatherName, 15, Colors.black),
                    getNormalText(parentModel.phoneNumber, 13, Colors.grey),
                    getNormalText(parentModel.email, 13, Colors.black),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    widget.isEdit
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditParent(
                                      parentModel: parentModel,
                                    )))
                        : Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddFees(parentModel: parentModel)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: getNormalText(
                        widget.isEdit ? 'Edit' : 'Add Fees',
                        12,
                        Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );

  void searchParent(String query) {
    final books = parents.where((parentModel) {
      final nameLower = parentModel.fatherName.toLowerCase();
      final phoneLower = parentModel.phoneNumber.toLowerCase();
      final emailLower = parentModel.email.toLowerCase();

      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          phoneLower.contains(searchLower) ||
          emailLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      parents = books;
    });
  }
}
