abstract class ApiEndPoints {
  static const String baseUrl = 'https://waslammka.runasp.net/';
  static const String fcmUrl =
      'https://fcm.googleapis.com/v1/wasla-39f17/messages:send';
  static const String register = 'api/Account/register';
  static const String login = 'api/Account/login';
  static const String resetPasswordForProfile = 'api/Account/change-password';
  static const String updateRestaurantReservation =
      'api/Reservation/reservation';
  static const String forgotPassCheckEmail =
      'api/Account/check-mail-verification';
  static const String verifyEmail = 'api/Account/verify-email';
  static const String forgotPass = 'api/Account/forget-password';
  static const String getRols = 'api/Roles';
  static const String doctorCompleteInfo = 'api/Doctor/CompleteData';
  static const String getDoctorSpecializations =
      'api/Doctor/DoctorSpecializations';
  static const String residentCompleteRegister =
      'api/Resident/CompleteRegister';
  static const String residentGetProfile = 'api/Resident/get-Profile';
  static const String imageBaseUrl = '${baseUrl}assets/images/user/';
  static const String gymBaseUrl = '${baseUrl}assets/images/gym/';
  static const String technicalBaseUrl = '${baseUrl}assets/images/technician/';
  static const String doctorBaseUrl = '${baseUrl}assets/images/doctor/';
  static const String qrBaseUrl = '${baseUrl}assets/qrcodes/';
  static const String fileBaseUrl = '${baseUrl}assets/cv/doctor/';
  static const String residentEditProfile = 'api/Resident/edit-Profile';
  static const String doctorGetProfile = 'api/Doctor/GetDoctorProfile/';
  static const String doctorGetServices = 'api/DoctorService/GetServices/';
  static const String doctorUpdateService = 'api/DoctorService/UpdateService';
  static const String doctorAddService = 'api/DoctorService/AddService';
  static const String doctorDeleteService = 'api/DoctorService/DeleteService/';
  static const String getDoctorBySpecialist =
      'api/Doctor/GetDoctorBySpecialist/';
  static const String doctorBookService = 'api/DoctorBook/BookService';
  static const String doctorUpdateProfile = 'api/Doctor/UpdateDoctorProfile';
  static const String doctorGetChart = 'api/Doctor/GetDoctorChart/';
  static const String doctorGetAllBooking =
      'api/Doctor/GetAllBookingsOfDoctor/';
  static const String updateBooking = 'api/DoctorBook/UpdateBooking';
  static const String updateBookingStatus =
      'api/DoctorBook/UpdateBookingStatus';
  static const String getBookingDetailsForUser =
      'api/DoctorBook/GetBookingDetailsForUser';
  static const String getReviews = 'api/Review/service-provider/';
  static const String getReviewsByRating = 'api/Review/ratings/';
  static const String addReview = 'api/Review/AddReview';
  static const String updateReview = 'api/Review/UpdateReview';
  static const String removeReview = 'api/Review/rating/';
  static const String addToFavourite = 'api/Favourite/AddFavourite';
  static const String removeFromFavourite = 'api/Favourite/RemoveFavourite';
  static const String getAllFavourites = 'api/Favourite/GetAllFavourites';
  static const String getFavouritesByType = 'api/Favourite/GetFavouritesByType';
  static const String refreshToken = 'api/Account/refresh-token';
  static const String logout = 'api/Account/logout';
  static const String getDoctorById = 'api/Doctor/GetDoctorData/';
  static const String gymCompleteRegister = 'api/Gym/CompleteRegister';
  static const String getAllGyms = 'api/Gym/AllGyms';
  static const String getGymProfile = 'api/Gym/GymProfile';
  static const String getGymUpdateProfile = 'api/Gym/UpdateProfile';
  static const String gymPackage = 'api/Package';
  static const String getGymCharts = 'api/GymBooking/Charts/';
  static const String getGymAllBookings = 'api/GymBooking/gym/';
  static const String gymCancelBooking = 'api/GymBooking/cancel/';
  static const String bookAtGym = 'api/GymBooking/book';
  static const String getResidentBookingsWithGymByStatus =
      'api/GymBooking/resident/';
  static const String getResidentBookingsWithGym = 'api/GymBooking/resident/';
  static const String deleteNotification = 'api/Notification/';
  static const String markAllReadLastSeenNotifications =
      'api/Notification/User/';
  static const String markAAsSeenNotification = 'api/Notification/';
  static const String getTotalNumberOfLastSeenNotifications =
      'api/Notification/User/';
  static const String getAllNotifications = '/api/Notification/User/';
  static const String createPayment = 'api/payment/create-payment-token';
  static const String paymentCallback = 'api/payment/callback';
  static const String paymentServerCallback = 'api/payment/server-callback';
  static const String socialAddPost = 'api/Social/Post';
  static const String socialGetAllPosts = 'api/Social/Posts';
  static const String socialComment = 'api/Social/Comment';
  static const String getAllComments = 'api/Social/Comments';
  static const String socialToggleRecation = 'api/Social/ToggleReaction';
  static const String socialGetPostsByReaction =
      'api/Social/Posts/ReactionType';
  static const String socialGetUserInfo = 'api/Social/InformationProfile';
  static const String driverCompleteInfo = 'api/Driver/CompleteRegister';
  static const String chatMsg = 'api/Chats/Message';
  static const String udpateUserBio = 'api/Chats/Bio';
  static const String deleteChat = 'api/Chats/Chat';
  static const String getSpeceficChat = 'api/Chats/Chat';
  static const String getAllUserChats = 'api/Chats/Users';
  static const String getMyChats = 'api/Chats';
  static const String getProfileForSpecificChat = 'api/Chats/UserProfile';
  static const String chatReadMsgs = 'api/Chats/MarkAsRead/';
  static const String searchToRide = 'api/Ride/request';
  static const String chooseDriver = 'api/Ride/choose-driver';
  static const String isInRide = 'api/Ride/IsInRide';
  static const String getDetailsForRider = 'api/Ride/GetrideDetailsForRider/';
  static const String cancelRide = 'api/Ride/cancel/';
  static const String getDriverLocation = 'api/Driver/GetDriverLocation';
  static const String startTrip = 'api/Ride/start/';
  static const String completeTrip = 'api/Ride/complete/';
  static const String acceptTrip = 'api/Ride/accept/';
  static const String updateDriverLocation = 'api/Driver/TrackingDriver';
  static const String updateDriverStatus = 'api/Driver/ChangeStatus';
  static const String getTripDetailsForDriver =
      'api/Ride/GetrideDetailsForDriver/';
  static const String getRideDetaislForResident =
      'api/Ride/GetrideDetailsForResident/';
  static const String getResidentAllBookingsWithDriver =
      'api/Ride/GetUserRides/';
  static const String getDriverAllBookingsWithResident =
      'api/Ride/GetDriverRides/';
  static const String getDriverProfile = 'api/Driver/GetDriverProfileById';
  static const String getDriverChart = 'api/Ride/GetDriverChart/';
  static const String driverUpdateProfile = 'api/Driver/UpdateDriverProfile';
  static const String technicantCompleteInfo =
      'api/Technician/CompleteRegister';
  static const String technicantGetProfile = 'api/Technician/GetProfile';
  static const String technicantUpdateProfile = 'api/Technician/UpdateProfile';
  static const String technicianGetChart = 'api/Technician/GetChart';
  static const String technicianGetBookings =
      'api/TechnicianBooking/GetTechnicianBookings/';
  static const String technicianAcceptBooking = 'api/TechnicianBooking/accept/';
  static const String technicianCancelBooking = 'api/TechnicianBooking/cancel/';
  static const String technicianRejectBooking = 'api/TechnicianBooking/reject/';
  static const String technicianGetBookingDetails =
      'api/TechnicianBooking/GetBookingDetailsForTechnician/';
  static const String getBookingResidentWithTechnician =
      'api/TechnicianBooking/GetResidentBookings/';
  static const String getSpecializationsOfTechnician =
      'api/Technician/Specializations';
  static const String getTechniciansBySpeciality =
      'api/Technician/GetBySpecialty';
  static const String bookWithTechnician =
      'api/TechnicianBooking/CreateBooking';
  static const String getRestaurantCategories = 'api/RestaurantCategory/GetAll';
  static const String restaurantCompleteInfo = 'api/Restaurant/CompleteProfile';
  static const String getRestaurntProfile = 'api/Restaurant';
  static const String updateRestaurntProfile =
      'api/Restaurant/UpdateRestaurant';
  static const String getAllRestaurants = 'api/Restaurant/Restaurants';
  static const String getAllResevationOfResidentWithRestauant =
      'api/Reservation/ResidentReservations';
  static const String restaurantChangeStatusOfBooking =
      'api/Reservation/ChangeStatus';
  static const String restaurantReservatioin = 'api/Reservation/Reservation';
  static const String getMenuCategory = 'api/RestaurantMenu/Categories';
  static const String getMenuCategoryItemByCategories =
      'api/RestaurantMenu/ItemsByCategory';
  static const String retaurantMenu = 'api/RestaurantMenu/Item';
  static const String getReservationForRestaruant =
      'api/Reservation/RestaurantReservations';
  static const String getOrdersForRestaruant =
      'api/RestaurantOrder/orders-restaurant';
  static const String getRestaurantChart = 'api/Restaurant/Charts';
  static const String getRestaurantMenu = '/api/RestaurantMenu/Items';
  static const String addMenuToCart = 'api/RestaurantOrder/add-to-cart';
  static const String getResidentCartWithRestaurant =
      'api/RestaurantOrder/cart-items';
  static const String updateQuantityCartWithRestaurant =
      'api/RestaurantOrder/quantity-cart-item';
  static const String removeItemFromCartWithRestaurant =
      'api/RestaurantOrder/remove-from-cart';
  static const String restaurantCheckout = 'api/RestaurantOrder/checkout';
  static const String checkPaymentStatus = 'api/payment/status';
  static const String getResidentOrdersWithRestaurant =
      'api/RestaurantOrder/orders-resident';
  static const String restaurantMarkOrderAsPreparing =
      'api/RestaurantOrder/start-preparing-order';
  static const String restaurantMarkOrderAsDelivered =
      'api/RestaurantOrder/mark-order-delivered';
  static const String reportForSomething = 'api/Social/Report';
  static const String checkTokenStatus = 'api/Account/validate-token';
  static const String getAllServiceProviders = 'api/ServiceProvider/All';
  static const String searchServiceProviders = 'api/ServiceProvider/Search';
  static const String createUserEvent = 'api/UserEvent/CreateUserEvent';
  static const String cancelOrder = 'api/RestaurantOrder/cancel-order';
  static const String getTopServicesProviders =
      'api/UserEvent/GetTopServiceProviders';
  static const String getTopServicesProvidersGlobally =
      'api/UserEvent/GetMostUsedServicesGlobally';
  static const String getPaymentsForResident = 'api/payment/AllPayment/';
  static const String addContact = 'api/Admin/AddContact';
  static const String getPaymentsForServiceProvider =
      '/api/payment/AllPaymentByServiceProvider/';
}
