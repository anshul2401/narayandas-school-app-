import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:narayandas_app/chat/chat_home.dart';
import 'package:narayandas_app/chat/database.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/utils/strings.dart';

class ParentsProvider with ChangeNotifier {
  List<ParentModel> _parents = [];
  List<ParentModel> get parents => _parents;

  Future<void> addParent(ParentModel parent) {
    List<Map<String, dynamic>> childdata = [];
    parent.children.forEach((element) {
      childdata.add(element.toJson());
    });
    return http
        .post(Uri.parse(parentUrl),
            body: jsonEncode({
              'email': parent.email,
              'password': parent.password,
              'father_name': parent.fatherName,
              'mother_name': parent.motherName,
              'address': parent.address,
              'phone_number': parent.phoneNumber,
              'one_signal_id': parent.oneSignalId,
              'total_fees': parent.totalFee,
              'children': childdata,
              'fees': parent.fees,
              'date_time': parent.dateTime,
              'is_blocked': parent.isBlocked,
            }))
        .then(
      (value) {
        parent.children.forEach((element) {
          http
              .post(Uri.parse(studentUrl),
                  body: json.encode({
                    'name': element.name,
                    'standard': element.standard,
                    'parent_id': json.decode(value.body)['name'],
                    'gender': element.gender,
                    'blood_group': element.bloodGroup,
                    'dob': element.dob,
                    'documents': element.documents
                  }))
              .then((valuee) {
            final newStudent = StudentModel(
                id: json.decode(valuee.body)['name'],
                parentId: json.decode(value.body)['name'],
                name: element.name,
                standard: element.standard,
                documents: element.documents,
                dob: element.dob,
                bloodGroup: element.bloodGroup,
                gender: element.gender);
          }).catchError((error) {
            print(error);
            throw error;
          });
        });

        http
            .post(
          Uri.parse(authUrl),
          body: json.encode({
            'email': parent.email,
            'password': parent.password,
            'role': 'Parent',
            'is_blocked': false,
            'role_id': json.decode(value.body)['name'],
          }),
        )
            .catchError((error) {
          print(error);
          throw error;
        });
        Map<String, dynamic> userInfoMap = {
          "email": parent.email,
          "username": parent.email.replaceAll("@gmail.com", ""),
          "name": parent.fatherName,
          "imgUrl":
              'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/1024px-Circle-icons-profile.svg.png'
        };

        DatabaseMethods()
            .addUserInfoToDB(json.decode(value.body)['name'], userInfoMap);

        final newParent = ParentModel(
            id: json.decode(value.body)['name'],
            email: parent.email,
            password: parent.password,
            fatherName: parent.fatherName,
            motherName: parent.motherName,
            address: parent.address,
            phoneNumber: parent.phoneNumber,
            oneSignalId: parent.oneSignalId,
            totalFee: parent.totalFee,
            children: parent.children,
            fees: parent.fees,
            dateTime: parent.dateTime,
            isBlocked: parent.isBlocked);
        _parents.insert(0, newParent);

        notifyListeners();
      },
    ).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> fetchAndSetParents() async {
    try {
      final resopnse = await http.get(Uri.parse(parentUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<ParentModel> loadedParent = [];
      data.forEach((key, value) {
        List<ChildModel> d = [];
        value['children'].forEach((element) {
          d.add(ChildModel(
              name: element['name'],
              standard: element['standard'],
              documents: [],
              bloodGroup: element['blood_group'],
              dob: element['dob'],
              gender: element['gender']));
        });
        loadedParent.add(ParentModel(
          id: key,
          address: value['address'],
          children: d,
          dateTime: value['date_time'],
          email: value['email'],
          fatherName: value['father_name'],
          fees: [],
          isBlocked: value['is_blocked'],
          motherName: value['mother_name'],
          oneSignalId: value['one_signal_id'],
          password: value['password'],
          phoneNumber: value['phone_number'],
          totalFee: value['total_fees'],
        ));
      });
      _parents = loadedParent;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateParent(String id, ParentModel parent) async {
    final index = _parents.indexWhere((c) => c.id == id);
    if (index >= 0) {
      List<Map<String, dynamic>> childdata = [];
      parent.children.forEach((element) {
        childdata.add(element.toJson());
      });
      try {
        var url = baseUrl + 'parents/$id.json';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'email': parent.email,
              'password': parent.password,
              'father_name': parent.fatherName,
              'mother_name': parent.motherName,
              'address': parent.address,
              'phone_number': parent.phoneNumber,
              'one_signal_id': parent.oneSignalId,
              'total_fees': parent.totalFee,
              'children': childdata,
              'fees': parent.fees,
              'date_time': parent.dateTime,
              'is_blocked': parent.isBlocked,
            }));
        _parents[index] = parent;
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }
}
