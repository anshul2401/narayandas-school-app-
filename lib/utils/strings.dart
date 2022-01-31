import 'package:narayandas_app/model/auth_model.dart';

const String baseUrl =
    'https://narayandas-school-app-default-rtdb.asia-southeast1.firebasedatabase.app/';
const String parentUrl = baseUrl + 'parents.json';
const String studentUrl = baseUrl + 'students.json';
const String feesUrl = baseUrl + 'fees.json';
const String teacherUrl = baseUrl + 'teachers.json';
const String mealUrl = baseUrl + 'meals.json';
const String studentAttendanceUrl = baseUrl + 'studentAttendance.json';
const String teacherAttendanceUrl = baseUrl + 'teacherAttendance.json';
const String homeworkUrl = baseUrl + 'homework.json';
const String authUrl = baseUrl + 'auth.json';
const String galleryUrl = baseUrl + 'gallery.json';
const String accountUrl = baseUrl + 'account.json';
const String oneSignalUrl = baseUrl + 'one_signal.json';
AuthModel? currentUser;

// Constant Strings fields
const String NAME = 'name';
const String EMAIL = 'email';
const String ADDRESS = 'address';
const String PHONE = 'phone';
const String USER_ID = 'user_id';
const String PRODUCT_ITEM = 'product_item';
const String TOTAL_AMOUNT = 'total_amount';
const String TITLE = 'title';
const String CONTENT = 'content';
const String VALID_TILL = 'valid_till';
const String OFFER_START = 'offer_start';
const String BILLING_DATE = 'billing_date';
const String ONE_SIGNAL_ID = 'cfc69e7c-43de-48f2-a24b-c99c97d7fcaf';
