// ignore_for_file: file_names

Map<String, String> getheader(String token) {
  Map<String, String> header = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Accept-Charset': 'UTF-8',
    'Authorization': 'Bearer $token'
  };
  return header;
}

Map<String, String> headerLogin = {
  'Content-Type': 'application/json; charset=UTF-8',
  'Accept': 'application/json',
  'Accept-Charset': 'UTF-8',
};


//Main URL API
const mainURL = 'https://thanhhoagarden.herokuapp.com';

//User
const loginWithUsernamePasswordURL = '/user/login';
const loginWithGGorPhoneURL = '/user/loginWithEmailOrPhone?';
const registerURL = '/user/register';
const updatefcmTokenURL = '/user/createFcmToken';
const getUserInfoURL = '/user/getByToken';
const logoutURL = '/user/logout';

//Bonsai
const getPlantByIDURL = '/plant/';
const getListPlantURL = '/plant/plantFilter?';

//category
const getAllCategoryURL = '/category';

//service
const getServiceURL = '/service?pageNo=0&pageSize=100&sortBy=ID&sortAsc=true';

//servicePack
const getServicePackURL = '/servicePack';


//contractDetail
const getContractDetailURL = '/contract/contractDetail/';
const getAllContractDetailURL = '/contract/getContractDetailByStaffToken';

//contract
const getContractURL = '/contract/byCustomerToken?Staff%20%2F%20Customer=Staff';
const getAContractURL = '/contract/getByID?contractID=';

//ImageNoAvailable
const getImageNoAvailableURL = 'https://t3.ftcdn.net/jpg/03/34/83/22/360_F_334832255_IMxvzYRygjd20VlSaIAFZrQWjozQH6BQ.jpg';

//Schedule
const getScheduleURL = '/workingDate/getByStaffToken';
const getScheduleInWeekURL = '/contract/getContractDetailByStaffTokenAndDate?';

//ScheduleDetail
const getScheduleDetailURL = '/workingDate/getByWorkingDate?';
const confirmWorkingURL = '/workingDate/addWorkingDate?contractDetailID=';

//cart
const cartURL = '/cart';

//feedback
const getFeedbackByPlantIDURL = '/feedback/orderFeedback/byPlantID?';
const getFeedbackURL = '/feedback/orderFeedback?';
const createFeedbackDURL = '/feedback/createOrderFB';

//rating
const getRatingURL = '/feedback/getRating';

//order
const orderURL = '/order';
const getOrderURL = '/order/getAllOrderByUsername?';
const getOrderDetailURL = '/order/orderDetail/';
const cancelOrderURL = '/order/rejectOrder?';
const getOrderDetaiByFeedbackStatuslURL = '/order/getOrderDetailByIsFeedback?';

//store
const storeURL = '/store';
const storeIdURL = '/store/getByID?';

//Distance Price
const distanceURL = '/distancePrice';

//enum
const orderStatus = '/enum/order';

//report
const createReportURL = '/report';
const getReportByToken = '/report/getByCustomerToken';

//noti
const notificationURL = '/notification';
const checkReadOneURL = '/notification/isRead?notificationID=';
const checkReadAllURL = '/notification/isReadByToken';