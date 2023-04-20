import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sistem/helpers/query_organisation_name.dart';
import 'package:sistem/models/Employee.dart';
import 'package:sistem/models/ModelProvider.dart';
import 'package:uuid/uuid.dart';


Future _usersEmail() async {
    try {
      var attributes = (await Amplify.Auth.fetchUserAttributes()).toList();
      for (var attribute in attributes) {
        if (attribute.userAttributeKey.toString() == 'email') {
          return attribute.value.toString();
        }
      }
      return 'no email';
    } on AuthException catch (e) {
      return '${e.message}';
    }
  }


Future<void> saveEmployee(String employeeRole,String organizationId, int employeePhone) async {
   final now = DateTime.now();
  final formattedDate = '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}';
  final userEmail = await _usersEmail();
  final newEmployee = Employee(
    employee_created: formattedDate,
    employee_role: employeeRole,
    id: Uuid().v4(),
    organizationIDtoEmployeeRelation: organizationId,
    employee_organization: await queryOrgansationName(organizationId),
    employee_phone: employeePhone,
    employee_email: userEmail
  );

  await Amplify.DataStore.save(newEmployee);
}

Future<void> saveManager(String employeeRole, int employeePhone,String organizationName,) async {
  final orgid = Uuid().v4();
   final now = DateTime.now();
  final formattedDate = '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}';
  
   final userEmail = await _usersEmail();

  final newManager = Employee(
    employee_created: formattedDate,
    employee_role: employeeRole,
    id: Uuid().v4(),
    employee_organization: organizationName,
    employee_phone: employeePhone,
    employee_email: userEmail,
    organizationIDtoEmployeeRelation: orgid
  );

  final newOrganisation = Organization(
    id: orgid,
    organization_name: organizationName,
    organization_created: formattedDate,
  );
  
  try {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result != false){
        await Amplify.DataStore.save(newOrganisation,);
        await Amplify.DataStore.save(newManager);
    }
    
  } catch (e) {
   throw Exception(e);
  }
  
  
}

String _addLeadingZero(int number) {
  return number.toString().padLeft(2, '0');
}