import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/database/api/api_consumer.dart';
import 'package:wasla/features/payment/payment_service.dart';
import 'package:wasla/features/payment/presentation/manager/cubit/payment_cubit.dart';
import 'package:wasla/features/payment/presentation/views/payment_view.dart';
import 'package:wasla/core/utils/app_strings.dart';
import 'package:wasla/features/auth/presentation/views/restaurant_complete_info_view.dart';
import 'package:wasla/features/auth/presentation/views/technicant_complete_info_view.dart';
import 'package:wasla/features/profile/presentation/views/help_center_view.dart';
import 'package:wasla/features/profile/presentation/views/privacy_policy_view.dart';
import 'package:wasla/features/profile/presentation/views/restaurant_edit_profile.dart';
import 'package:wasla/features/profile/presentation/views/restaurant_profile_info.dart';
import 'package:wasla/features/profile/presentation/views/technician_edit_profile.dart';
import 'package:wasla/features/profile/presentation/views/technician_profile_info.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/views/choose_driver_view.dart';
import 'package:wasla/features/resident_service/features/gym/data/repo/gym_resident_repo_impl.dart';
import 'package:wasla/features/resident_service/features/gym/presentation/manager/cubit/gym_resident_cubit.dart';
import 'package:wasla/features/resident_service/features/home/presentation/views/all_bannars_view.dart';
import 'package:wasla/features/resident_service/features/home/presentation/views/resident_search_view.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/Update_restaurant_reservation_model.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restauarant_menu_item_model.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/repo/cart/restaurant_cart_repo_impl.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/repo/details/resident_restaurant_repo_impl.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/manager/cubit/cart/restaurant_cart_cubit.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/views/update_reservation_view.dart';
import 'package:wasla/features/restaurant/orders/presentation/views/resident_restaurant_orders_view.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/views/restaurant_cart_view.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/views/restaurant_checkout_view.dart';
import 'package:wasla/features/restaurant/menu/data/repo/resident_menu_repo_impl.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/manager/cubit/details/resident_restaurant_cubit.dart';
import 'package:wasla/features/restaurant/menu/presentation/manager/cubit/resident_menu_cubit.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/views/resident_menu_view.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/views/resident_restaurant_details_view.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/views/resident_restaurant_reservation_view.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/views/resident_restaurant_view.dart';
import 'package:wasla/features/resident_service/features/technicain/data/repo/resident_technician_repo_impl.dart';
import 'package:wasla/features/resident_service/features/technicain/presentation/manager/cubit/resident_technician_cubit.dart';
import 'package:wasla/features/resident_service/features/technicain/presentation/views/resident_technical_book_view.dart';
import 'package:wasla/features/resident_service/features/technicain/presentation/views/resident_technician_details_view.dart';
import 'package:wasla/features/resident_service/features/technicain/presentation/views/resident_technician_view.dart';
import 'package:wasla/features/restaurant/home/data/models/restaurant_model.dart';
import 'package:wasla/features/restaurant/home/presentation/views/restaurant_bottom_nav_bar_view.dart';
import 'package:wasla/features/restaurant/menu/presentation/views/add_menu_item_view.dart';
import 'package:wasla/features/restaurant/menu/presentation/views/update_menu_item_view.dart';
import 'package:wasla/features/restaurant/orders/data/repo/orders_repo_impl.dart';
import 'package:wasla/features/restaurant/orders/presentation/manager/cubit/orders_cubit.dart';
import 'package:wasla/features/restaurant/orders/presentation/views/order_view.dart';
import 'package:wasla/features/social_media/presentation/views/social_report_view.dart';
import 'package:wasla/features/technicant/features/booking/data/repo/technician_bookings_repo_impl.dart';
import 'package:wasla/features/technicant/features/booking/presentation/manager/cubit/technician_booking_cubit.dart';
import 'package:wasla/features/technicant/features/booking/presentation/views/technician_booking_details_view.dart';
import 'package:wasla/features/technicant/features/home/data/models/technician_model.dart';
import 'package:wasla/features/technicant/features/home/presentation/views/technicant_bottom_nav_bar_view.dart';
import 'package:wasla/randoms/animation_test.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/functions/handle_initial_route.dart';
import 'package:wasla/core/service/Audio/audio_test.dart';
import 'package:wasla/features/payment/presentation/views/payment_failure_view.dart';
import 'package:wasla/features/payment/presentation/views/payment_success_view.dart';
import 'package:wasla/core/service/service_locator.dart';
import 'package:wasla/features/auth/presentation/views/driver_info_view.dart';
import 'package:wasla/features/chat/data/models/chat_user_info.dart';
import 'package:wasla/features/chat/presentation/views/all_users_chats_view.dart';
import 'package:wasla/features/chat/presentation/views/chat_user_profile_veiw.dart';
import 'package:wasla/features/chat/presentation/views/chat_view.dart';
import 'package:wasla/features/driver/features/home/data/models/driver_profile_model.dart';
import 'package:wasla/features/driver/features/home/presentation/views/driver_bottom_nav_bar.dart';
import 'package:wasla/features/driver/features/trip/presentation/views/driver_map_tracking_view.dart';
import 'package:wasla/features/driver/features/trip/presentation/views/suggested_trip_view.dart';
import 'package:wasla/features/driver/features/trip/presentation/views/trip_residnet_info_view.dart';
import 'package:wasla/features/profile/presentation/views/dirver_edit_profile_view.dart';
import 'package:wasla/features/profile/presentation/views/driver_profile_info_page.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/views/driver_tracking_view.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/views/driver_trip_details_view.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/views/enter_your_locatoin_view.dart';
import 'package:wasla/features/notifications/presentation/views/notification_view.dart';
import 'package:wasla/features/auth/presentation/views/gym_complete_info_view.dart';
import 'package:wasla/features/doctor_service/features/home/data/models/doctor_booking_model.dart';
import 'package:wasla/features/doctor_service/features/home/data/models/doctor_model.dart';
import 'package:wasla/features/doctor_service/features/home/presentation/views/doctor_edit_booking_view.dart';
import 'package:wasla/features/doctor_service/features/service/data/models/doctor_service_model.dart';
import 'package:wasla/features/doctor_service/features/service/presentation/views/doctor_add_service_view.dart';
import 'package:wasla/features/favourite/presentation/views/all_favourites_views.dart';
import 'package:wasla/features/gym/features/dashboard/presentation/views/gym_bottom_nav_bar.dart';
import 'package:wasla/features/gym/features/packages/data/models/gym_package_model.dart';
import 'package:wasla/features/gym/features/packages/presentation/views/gym_add_update_package_view.dart';
import 'package:wasla/features/profile/data/models/gym_model.dart';
import 'package:wasla/features/profile/presentation/views/doctor_edit_profile_view.dart';
import 'package:wasla/features/profile/presentation/views/doctor_profile_info.dart';
import 'package:wasla/features/profile/presentation/views/gym_edit_profile_view.dart';
import 'package:wasla/features/profile/presentation/views/gym_profile_info_viwe.dart';
import 'package:wasla/features/profile/presentation/views/resident_profile_info.dart';
import 'package:wasla/features/resident_service/features/doctor/data/models/doctor_data_model.dart';
import 'package:wasla/features/resident_service/features/doctor/presentation/views/doctor_booking_view.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/views/load_untill_trip_view.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/views/rate_driver_view.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/views/resident_driver_view.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/views/trip_canceld_view.dart';
import 'package:wasla/features/resident_service/features/gym/presentation/views/gym_resident_view.dart';
import 'package:wasla/features/resident_service/features/gym/presentation/views/resident_gym_details_view.dart';
import 'package:wasla/features/resident_service/features/gym/presentation/views/resident_gym_see_pakcages_views.dart';
import 'package:wasla/features/reviews/presentation/views/reviews_view.dart';
import 'package:wasla/features/resident_service/features/doctor/presentation/views/doctor_see_serevices_view.dart';
import 'package:wasla/features/resident_service/features/home/data/models/user_model.dart';
import 'package:wasla/core/service/maps/cubit/maps_helper_cubit.dart';
import 'package:wasla/features/auth/presentation/views/auth_map_view.dart';
import 'package:wasla/features/auth/presentation/views/doctor_complete_info_view.dart';
import 'package:wasla/features/auth/presentation/views/doctor_info_view.dart';
import 'package:wasla/features/auth/presentation/views/forgot_pass_view.dart';
import 'package:wasla/features/auth/presentation/views/reset_pass_view.dart';
import 'package:wasla/features/auth/presentation/views/resident_info_view.dart';
import 'package:wasla/features/auth/presentation/views/resurent_info_view.dart';
import 'package:wasla/features/auth/presentation/views/sign_in_view.dart';
import 'package:wasla/features/auth/presentation/views/sign_up_view.dart';
import 'package:wasla/features/auth/presentation/views/verification_code_view.dart';
import 'package:wasla/features/doctor_service/features/home/presentation/views/doctor_nav_bar_view.dart';
import 'package:wasla/features/onboarding/presentation/manager/cubit/onboarding_cubit.dart';
import 'package:wasla/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:wasla/features/profile/presentation/views/account_change_pass_view.dart';
import 'package:wasla/features/profile/presentation/views/change_lang_view.dart';
import 'package:wasla/features/profile/presentation/views/resident_edit_profile_view.dart';
import 'package:wasla/features/resident_service/features/doctor/presentation/views/doctor_details_view.dart';
import 'package:wasla/features/resident_service/features/doctor/presentation/views/doctor_view.dart';
import 'package:wasla/features/resident_service/features/home/presentation/views/all_services_view.dart';
import 'package:wasla/features/resident_service/features/home/presentation/views/home_resident_navbar.dart';
import 'package:wasla/features/resident_service/features/home/presentation/views/resident_home_view.dart';
import 'package:wasla/features/social_media/presentation/views/add_post_view.dart';
import 'package:wasla/features/social_media/presentation/views/all_posts_view.dart';
import 'package:wasla/features/social_media/presentation/views/reactions_view.dart';
import 'package:wasla/features/social_media/presentation/views/social_profile_view.dart';
import 'package:wasla/features/splash/presentation/views/splash_view.dart';
import 'package:wasla/randoms/download_file.dart';
import 'package:wasla/randoms/scroll/scrallable_list.dart';
import 'package:wasla/randoms/stack_test.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,

  initialLocation: handleInitialRoute(),
  // initialLocation: AppRoutes.scrollableListScreen,
  redirect: (context, state) {
    if (state.uri.toString().contains('wasla://payment/success')) {
      return AppRoutes.paymentSuccessScreen;
    }
    if (state.uri.toString().contains('wasla://payment/failed')) {
      return AppRoutes.paymentFailureScreen;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.testAudioScreen,
      builder: (context, state) => AudioTest(),
    ),
    GoRoute(
      path: AppRoutes.scrollableListScreen,
      builder: (context, state) => ScrallableList(),
    ),
    GoRoute(
      path: AppRoutes.stackTestScreen,
      builder: (context, state) => StackTest(),
    ),
    GoRoute(
      path: AppRoutes.downloadTestScreen,
      builder: (context, state) => DownloadFile(),
    ),
    GoRoute(
      path: AppRoutes.animationTestScreen,
      builder: (context, state) => AnimationTest(),
    ),
    GoRoute(
      path: AppRoutes.chatUserProfileScreen,
      builder: (context, state) {
        final ChatUserInfo user = state.extra as ChatUserInfo;
        return ChatUserProfileVeiw(user: user);
      },
    ),
    GoRoute(
      path: AppRoutes.splashScreen,
      builder: (context, state) => SplashView(),
    ),
    GoRoute(
      path: AppRoutes.onboardingScreen,
      builder: (context, state) => BlocProvider(
        create: (context) => OnboardingCubit(),
        child: const OnboardingView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.signInScreen,
      builder: (context, state) => SignInView(),
    ),
    GoRoute(
      path: AppRoutes.signUpScreen,
      builder: (context, state) => SignUpView(),
    ),
    GoRoute(
      path: AppRoutes.resetPassScreen,
      builder: (context, state) => ResetPassView(),
    ),
    GoRoute(
      path: AppRoutes.forgotScreen,
      builder: (context, state) => ForgotPassView(),
    ),
    GoRoute(
      path: AppRoutes.authMapScreen,
      builder: (context, state) => BlocProvider(
        create: (context) => MapsHelperCubit()..getCurrentLocation(),
        child: AuthMapView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.verifyScreen,
      builder: (context, state) {
        final String nextRoute = state.extra as String;
        return VerificationCodeView(nextRoute: nextRoute);
      },
    ),
    GoRoute(
      path: AppRoutes.residentInfoScreen,
      builder: (context, state) => ResidentInfoView(),
    ),
    GoRoute(
      path: AppRoutes.doctorInfoScreen,
      builder: (context, state) => DoctorInfoView(),
    ),
    GoRoute(
      path: AppRoutes.doctorCompleteInfoScreen,
      builder: (context, state) => DoctorCompleteInfoView(),
    ),
    GoRoute(
      path: AppRoutes.resturentInfoScreen,
      builder: (context, state) => ResurentInfoView(),
    ),
    GoRoute(
      path: AppRoutes.residentHomeScreen,
      builder: (context, state) => ResidentHomeView(),
    ),
    GoRoute(
      path: AppRoutes.residenBottomNavBar,
      builder: (context, state) {
        return HomeResidentNavbar();
      },
    ),
    GoRoute(
      path: AppRoutes.allServicesScreen,
      builder: (context, state) => AllServicesView(),
    ),

    GoRoute(
      path: AppRoutes.doctorScreen,
      builder: (context, state) => DoctorView(),
    ),
    GoRoute(
      path: AppRoutes.doctorDetailsScreen,
      builder: (context, state) {
        final DoctorDataModel doc = state.extra as DoctorDataModel;
        return DoctorDetailsView(doctor: doc);
      },
    ),
    GoRoute(
      path: AppRoutes.chnageLangScreen,
      builder: (context, state) => ChangeLangView(),
    ),
    GoRoute(
      path: AppRoutes.residentEditProfileScreen,
      builder: (context, state) {
        final UserModel userModel = state.extra as UserModel;
        return ResidentEditProfileView(user: userModel);
      },
    ),
    GoRoute(
      path: AppRoutes.doctorEditProfileScreen,
      builder: (context, state) {
        final DoctorModel doctorModel = state.extra as DoctorModel;
        return DoctorEditProfileView(doc: doctorModel);
      },
    ),
    GoRoute(
      path: AppRoutes.accountChangePassScreen,
      builder: (context, state) => AccountChangePassView(),
    ),
    GoRoute(
      path: AppRoutes.doctorNavbarScreen,
      builder: (context, state) => DoctorNavBarView(),
    ),
    GoRoute(
      path: AppRoutes.doctorAddServiceScreen,
      builder: (context, state) => DoctorAddServiceView(),
    ),
    GoRoute(
      path: AppRoutes.reviewScreen,
      builder: (context, state) {
        final int? reviewId = state.extra as int?;
        return ReviewsView(reviewId: reviewId);
      },
    ),
    GoRoute(
      path: AppRoutes.doctorSeeSevicesScreen,
      builder: (context, state) {
        final String doctorId = state.extra as String;
        return DoctorSeeSerevicesView(docId: doctorId);
      },
    ),
    GoRoute(
      path: AppRoutes.doctorBookingScreen,
      builder: (context, state) {
        final DoctorServiceModel doctorServiceModel =
            state.extra as DoctorServiceModel;
        return DoctorBookingView(doctorServiceModel: doctorServiceModel);
      },
    ),
    GoRoute(
      path: AppRoutes.doctorEditBookingScreen,
      builder: (context, state) {
        final DoctorBookingModel doctorBookingModel =
            state.extra as DoctorBookingModel;
        return DoctorEditBookingView(bookingModel: doctorBookingModel);
      },
    ),
    GoRoute(
      path: AppRoutes.allFavouritesScreen,
      builder: (context, state) => AllFavouritesViews(),
    ),

    GoRoute(
      path: AppRoutes.gymCompleteInfoScreen,
      builder: (context, state) => GymCompleteInfoView(),
    ),
    GoRoute(
      path: AppRoutes.gymBottomNavBarScreen,
      builder: (context, state) => GymBottomNavBar(),
    ),
    GoRoute(
      path: AppRoutes.gymAddUpdatePackageScreen,
      builder: (context, state) {
        final GymPackageModel? package = state.extra as GymPackageModel?;
        return GymAddUpdatePackageView(package: package);
      },
    ),
    GoRoute(
      path: AppRoutes.gymProfileInfoScreen,
      builder: (context, state) {
        final GymModel gym = state.extra as GymModel;
        return GymProfileInfoViwe(gym: gym);
      },
    ),
    GoRoute(
      path: AppRoutes.doctorProfileInfoScreen,
      builder: (context, state) {
        final DoctorModel doc = state.extra as DoctorModel;
        return DoctorProfileInfo(doctorModel: doc);
      },
    ),
    GoRoute(
      path: AppRoutes.residentProfileInfoScreen,
      builder: (context, state) {
        final UserModel resident = state.extra as UserModel;
        return ResidentProfileInfo(resident: resident);
      },
    ),
    GoRoute(
      path: AppRoutes.gymEditProfileScreen,
      builder: (context, state) {
        final GymModel gym = state.extra as GymModel;
        return GymEditProfileView(gym: gym);
      },
    ),
    GoRoute(
      path: AppRoutes.gymResidentScreen,
      builder: (context, state) => BlocProvider(
        create: (context) =>
            GymResidentCubit(GymResidentRepoImpl(api: sl<ApiConsumer>())),
        child: GymResidentView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.gymResidentDetailsScreen,
      builder: (context, state) {
        final Map<String, dynamic> details =
            state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (context) =>
              GymResidentCubit(GymResidentRepoImpl(api: sl<ApiConsumer>())),
          child: ResidentGymDetailsView(details: details),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.gymResidentSeePackagesScreen,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data[AppStrings.cubit] as GymResidentCubit,
          child: ResidentGymSeePakcagesView(
            gymId: data[AppStrings.id] as String,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.notificationsScreen,
      builder: (context, state) => NotificationView(),
    ),
    GoRoute(
      path: AppRoutes.allPostsScreen,
      builder: (context, state) => AllPostsView(),
    ),
    GoRoute(
      path: AppRoutes.addPostsScreen,
      builder: (context, state) => AddPostView(),
    ),
    GoRoute(
      path: AppRoutes.socialProfileScreen,
      builder: (context, state) {
        final Map<String, dynamic> userData =
            state.extra as Map<String, dynamic>;
        return SocialProfileView(userData: userData);
      },
    ),
    GoRoute(
      path: AppRoutes.reactionsScreen,
      builder: (context, state) {
        final int postId = state.extra as int;
        return ReactionsView(postId: postId);
      },
    ),
    GoRoute(
      path: AppRoutes.driverCompleteInfoScreen,
      builder: (context, state) => DriverInfoView(),
    ),
    GoRoute(
      path: AppRoutes.driverBottomNavBarScreen,
      builder: (context, state) => DriverBottomNavBar(),
    ),
    GoRoute(
      path: AppRoutes.residentDriverScreen,
      builder: (context, state) => ResidentDriverView(),
    ),

    GoRoute(
      path: AppRoutes.paymentSuccessScreen,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return PaymentSuccessView(data: data);
      },
    ),
    GoRoute(
      path: AppRoutes.paymentFailureScreen,
      builder: (context, state) => PaymentFailedView(),
    ),

    GoRoute(
      path: AppRoutes.enterYourLocationScreen,
      builder: (context, state) => EnterYourLocatoinView(),
    ),
    GoRoute(
      path: AppRoutes.loadUntillTripScreen,
      builder: (context, state) => LoadUntillTripView(),
    ),
    GoRoute(
      path: AppRoutes.driverTripDetailsScreen,
      builder: (context, state) {
        final int tripId = state.extra as int;
        return DriverTripDetailsView(tripId: tripId);
      },
    ),
    GoRoute(
      path: AppRoutes.residentDriverTrakcingScreen,
      builder: (context, state) => DriverTrackingView(),
    ),
    GoRoute(
      path: AppRoutes.driverReviewScreen,
      builder: (context, state) {
        final String driverId = state.extra as String;
        return DriverReviewScreen(driverId: driverId);
      },
    ),
    GoRoute(
      path: AppRoutes.allUsersChatssScreen,
      builder: (context, state) => AllUsersChatsView(),
    ),
    GoRoute(
      path: AppRoutes.chatScreen,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return ChatView(data: data);
      },
    ),
    GoRoute(
      path: AppRoutes.suggestedTripScreen,
      builder: (context, state) {
        final int tripId = state.extra as int;
        return SuggestedTripView(tripId: tripId);
      },
    ),
    GoRoute(
      path: AppRoutes.residentTripInfoScreen,
      builder: (context, state) {
        final int tripId = state.extra as int;
        return TripResidnetInfoView(tripId: tripId);
      },
    ),
    GoRoute(
      path: AppRoutes.driverMapTrackingScreen,
      builder: (context, state) {
        return DriverMapTrackingView();
      },
    ),
    GoRoute(
      path: AppRoutes.tripCanceldScreen,
      builder: (context, state) {
        final bool isDriver = state.extra as bool;
        return TripCancelledScreen(isDriver: isDriver);
      },
    ),
    GoRoute(
      path: AppRoutes.driverEditProfileScreen,
      builder: (context, state) {
        final DriverProfileModel driverProfileModel =
            state.extra as DriverProfileModel;
        return DirverEditProfileView(profile: driverProfileModel);
      },
    ),
    GoRoute(
      path: AppRoutes.chooseDriverScreen,
      builder: (context, state) {
        return ChooseDriverView();
      },
    ),
    GoRoute(
      path: AppRoutes.driverProfileInfoScreen,
      builder: (context, state) {
        final DriverProfileModel driverProfileModel =
            state.extra as DriverProfileModel;
        return DriverProfileInfoPage(driver: driverProfileModel);
      },
    ),
    GoRoute(
      path: AppRoutes.technicantCompleteInfoScreen,
      builder: (context, state) {
        return TechnicantCompleteInfoView();
      },
    ),
    GoRoute(
      path: AppRoutes.technicantBottomNavBarScreen,
      builder: (context, state) {
        return TechnicantBottomNavBarView();
      },
    ),
    GoRoute(
      path: AppRoutes.technicantInfoScreen,
      builder: (context, state) {
        final TechnicianModel technician = state.extra as TechnicianModel;
        return TechnicianProfileInfo(technician: technician);
      },
    ),
    GoRoute(
      path: AppRoutes.technicantEditProfileScreen,
      builder: (context, state) {
        final TechnicianModel technician = state.extra as TechnicianModel;
        return TechnicianEditProfile(technician: technician);
      },
    ),
    GoRoute(
      path: AppRoutes.technicianBookingDetailsScreen,
      builder: (context, state) {
        final int bookingId = state.extra as int;
        return BlocProvider(
          create: (context) => TechnicianBookingCubit(
            TechnicianBookingsRepoImpl(api: sl<ApiConsumer>()),
          ),
          child: TechnicianBookingDetailsView(bookingId: bookingId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.residentTechnicianScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => ResidentTechnicianCubit(
            ResidentTechnicianRepoImpl(api: sl<ApiConsumer>()),
          ),
          child: ResidentTechnicianView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.residentTechnicianDetailsScreen,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (context) => ResidentTechnicianCubit(
            ResidentTechnicianRepoImpl(api: sl<ApiConsumer>()),
          ),
          child: ResidentTechnicianDetailsView(data: data),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.residentTechnicianBookingScreen,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data[AppStrings.cubit] as ResidentTechnicianCubit,
          child: ResidentTechnicalBookView(technicianId: data[AppStrings.id]),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.restuarantCompleteInfo,
      builder: (context, state) {
        return RestaurantCompleteInfoView();
      },
    ),
    GoRoute(
      path: AppRoutes.restuarantBottomNavBar,
      builder: (context, state) {
        return RestaurantBottomNavBarView();
      },
    ),
    GoRoute(
      path: AppRoutes.restuarantEditProfile,
      builder: (context, state) {
        final RestaurantModel restaurantModel = state.extra as RestaurantModel;
        return RestaurantEditProfile(restaurant: restaurantModel);
      },
    ),
    GoRoute(
      path: AppRoutes.residentRestaurant,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => ResidentRestaurantCubit(
            ResidentRestaurantRepoImpl(api: sl<ApiConsumer>()),
          ),
          child: ResidentRestaurantView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.residentRestaurantDetailsScreen,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (context) => ResidentRestaurantCubit(
            ResidentRestaurantRepoImpl(api: sl<ApiConsumer>()),
          ),
          child: ResidentRestaurantDetailsView(data: data),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.residentRestaurantReservationScreen,
      builder: (context, state) {
        final String restaurantId = state.extra as String;
        return BlocProvider(
          create: (context) => ResidentRestaurantCubit(
            ResidentRestaurantRepoImpl(api: sl<ApiConsumer>()),
          ),
          child: ResidentRestaurantReservationView(restaurantId: restaurantId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.updateReservationScreen,
      builder: (context, state) {
        final reservationModel =
            state.extra as UpdateRestaurantReservationModel;
        return BlocProvider(
          create: (context) => ResidentRestaurantCubit(
            ResidentRestaurantRepoImpl(api: sl<ApiConsumer>()),
          ),
          child: UpdateReservationView(reservationModel: reservationModel),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.residentRestaurantMenuScreen,
      builder: (context, state) {
        final String restaurantId = state.extra as String;
        return BlocProvider(
          create: (context) =>
              ResidentMenuCubit(ResidentMenuRepoImpl(api: sl<ApiConsumer>())),
          child: ResidentMenuView(restaurantId: restaurantId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.addMenuItemScreen,
      builder: (context, state) {
        final ResidentMenuCubit cubit = state.extra as ResidentMenuCubit;
        return BlocProvider.value(value: cubit, child: AddMenuItemView());
      },
    ),
    GoRoute(
      path: AppRoutes.updateMenuItemScreen,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data[AppStrings.cubit] as ResidentMenuCubit,
          child: UpdateMenuItemView(menu: data[AppStrings.item] as MenuItem),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.orderScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) =>
              OrdersCubit(OrdersRepoImpl(api: sl<ApiConsumer>())),
          child: OrderView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.restaurantCartScreen,
      builder: (context, state) {
        final String restaurantId = state.extra as String;
        return BlocProvider(
          create: (context) => RestaurantCartCubit(
            RestaurantCartRepoImpl(api: sl<ApiConsumer>()),
          ),
          child: RestaurantCartView(restaurantId: restaurantId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.restaurantCheckoutScreen,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data[AppStrings.cubit] as RestaurantCartCubit,
          child: RestaurantCheckoutView(
            restaurantId: data[AppStrings.id] as String,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.residentRestaurantOrdersScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) =>
              OrdersCubit(OrdersRepoImpl(api: sl<ApiConsumer>())),
          child: ResidentRestaurantOrdersView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.socialReportScreen,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return SocialReportView(data: data);
      },
    ),
    GoRoute(
      path: AppRoutes.residentSearchScreen,
      builder: (context, state) {
        return ResidentSearchView();
      },
    ),
    GoRoute(
      path: AppRoutes.paymentScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => PaymentCubit(PaymentService()),
          child: PaymentView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.privacyPlolicyScreen,
      builder: (context, state) {
        return PrivacyPolicyView();
      },
    ),
    GoRoute(
      path: AppRoutes.helpCenterScreen,
      builder: (context, state) {
        return HelpCenterView();
      },
    ),
    GoRoute(
      path: AppRoutes.allBannarsScreen,
      builder: (context, state) {
        return AllBannarsView();
      },
    ),

    GoRoute(
      path: AppRoutes.restaurantProfileScreen,
      builder: (context, state) {
        final RestaurantModel restaurantModel = state.extra as RestaurantModel;
        return RestaurantProfileInfo(restaurant: restaurantModel);
      },
    ),
  ],
);
