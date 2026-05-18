import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wasla/core/database/api/api_consumer.dart';
import 'package:wasla/core/database/api/api_end_points.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/database/api/errors/api_exceptions.dart';
import 'package:wasla/core/enums/otp_type.dart';
import 'package:wasla/core/functions/convert_image_to_json.dart';
import 'package:wasla/core/models/doctor_specializationa_model.dart';
import 'package:wasla/features/auth/data/models/restaurant_catergories_model.dart';
import 'package:wasla/features/auth/data/models/roles_model.dart';
import 'package:wasla/features/auth/data/models/sign_in_model.dart';
import 'package:wasla/features/auth/data/repo/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final ApiConsumer api;

  AuthRepoImpl({required this.api});

  @override
  Future<Either<String, Null>> signUpWithEmailAndPassword({
    required String email,
    required String pass,
    required String role,
  }) async {
    try {
      await api.post(
        ApiEndPoints.register,
        body: {
          ApiKeys.email: email,
          ApiKeys.password: pass,
          ApiKeys.confirmPassword: pass,
          ApiKeys.roleId: role,
        },
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, Null>> verifyEmail({
    required String email,
    required String verificationCode,
    required OtpType otpType,
  }) async {
    try {
      await api.post(
        ApiEndPoints.verifyEmail,
        body: {
          ApiKeys.email: email,
          ApiKeys.verificationCode: verificationCode,
          ApiKeys.type: otpType.index,
        },
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, Null>> forgotPassCheckEmail({
    required String email,
    required OtpType verificationType,
  }) async {
    try {
      await api.post(
        ApiEndPoints.forgotPassCheckEmail,
        body: {
          ApiKeys.email: email,
          ApiKeys.verificationType: verificationType.index,
        },
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, Null>> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    try {
      await api.post(
        ApiEndPoints.forgotPass,
        body: {
          ApiKeys.email: email,
          ApiKeys.newPassword: newPassword,
          // ApiKeys.otp: otp,
        },
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, SignInDataModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.post(
        ApiEndPoints.login,
        body: {ApiKeys.email: email, ApiKeys.password: password},
      );
      if (response[ApiKeys.data][ApiKeys.role] == 'gym') {
        response[ApiKeys.data][ApiKeys.role] = 'gymOwner';
      } else if (response[ApiKeys.data][ApiKeys.role] == 'restaurant') {
        response[ApiKeys.data][ApiKeys.role] = 'restaurantOwner';
      }
      return Right(SignInDataModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, List<RolesModel>>> getRoles() async {
    try {
      final response = await api.get(ApiEndPoints.getRols);
      final List<RolesModel> roles = [];
      for (var role in response[ApiKeys.data]) {
        if (role[ApiKeys.roleName] == 'admin' ||role[ApiKeys.roleName] == 'superadmin' ) continue;

        if (role[ApiKeys.roleName] == 'gym') {
          role[ApiKeys.value] = 'gymOwner';
        } else if (role[ApiKeys.roleName] == 'restaurant') {
          role[ApiKeys.value] = 'restaurantOwner';
        }
        roles.add(RolesModel.fromJson(role));
      }
      return Right(roles);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, List<DoctorSpecializationaModel>>>
  getSpecialization() async {
    try {
      final response = await api.get(ApiEndPoints.getDoctorSpecializations);
      final List<DoctorSpecializationaModel> specializations = [];
      for (var specialization in response[ApiKeys.data]) {
        specializations.add(
          DoctorSpecializationaModel.fromJson(specialization),
        );
      }
      return Right(specializations);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, Null>> residentCompleteInfo({
    required String email,
    required String fullName,
    required String nationalId,
    required String phone,
    required String bDate,
    required File image,
    required double lat,
    required double lng,
  }) async {
    try {
      await api.post(
        ApiEndPoints.residentCompleteRegister,
        body: FormData.fromMap({
          ApiKeys.emailCapital: email,
          ApiKeys.fullName: fullName,
          ApiKeys.nationalId: nationalId,
          ApiKeys.phone: phone,
          ApiKeys.birthDay: bDate,
          ApiKeys.latitude: lat,
          ApiKeys.longitude: lng,
          ApiKeys.image: await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        }),
        headers: {"Content-Type": "multipart/form-data"},
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, Null>> doctorCompleteInfo({
    required String email,
    required String fullName,
    required String phone,
    required String bDate,
    required String universtiyName,
    required String description,
    required String hospitalName,
    required File image,
    required double lat,
    required double lng,
    required double graduationYear,
    required int spacializationID,
    required int experienceYears,
    required PlatformFile cv,
  }) async {
    try {
      final formData = FormData.fromMap({
        ApiKeys.emailCapital: email,
        ApiKeys.fullName: fullName,
        ApiKeys.phone: phone,
        ApiKeys.birthDay: bDate,
        ApiKeys.universityName: universtiyName,
        ApiKeys.description: description,
        ApiKeys.latitude: lat,
        ApiKeys.longitude: lng,
        ApiKeys.graduationYear: graduationYear,
        ApiKeys.specializationId: spacializationID,
        ApiKeys.experienceYears: experienceYears,
        ApiKeys.hospitalName: hospitalName,
        ApiKeys.image: await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),

        ApiKeys.cv: await MultipartFile.fromFile(cv.path!, filename: cv.name),
      });

      await api.post(
        ApiEndPoints.doctorCompleteInfo,
        body: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );

      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, Null>> logOut() async {
    try {
      await api.post(ApiEndPoints.logout);
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, Null>> gymCompleteInfo({
    required String gmail,
    required String businessName,
    required String ownerName,
    required String description,
    required List<String> phones,
    required double latitude,
    required double longitude,
    required List<File> photos,
  }) async {
    try {
      final formData = FormData.fromMap({
        ApiKeys.photo: await MultipartFile.fromFile(
          photos.first.path,
          filename: photos.first.path.split('/').last,
        ),
        ApiKeys.photos: await _convertFilesToMultipart(photos),
      });
      await api.post(
        ApiEndPoints.gymCompleteRegister,
        queryParameters: {
          ApiKeys.gmail: gmail,
          ApiKeys.businessName: businessName,
          ApiKeys.ownerName: ownerName,
          ApiKeys.description: description,
          ApiKeys.phones: phones,
          ApiKeys.latitudeSmall: latitude,
          ApiKeys.longitudeSmall: longitude,
        },
        body: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );

      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<List<MultipartFile>> _convertFilesToMultipart(List<File> files) async {
    return Future.wait(
      files.map(
        (file) async => await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      ),
    );
  }

  @override
  Future<Either<String, Null>> driverCompleteInfo({
    required String email,
    required String fullName,
    required String phone,
    required String bDate,
    required int vehicleType,
    required String vehicleModel,
    required String vehicleNumber,
    required int drivingExperienceYears,
    required double lng,
    required double lat,
    required String description,
    required File photo,
    required List<File> vehicleImages,
    required List<PlatformFile> driverFiles,
    required int vehicleColor,
  }) async {
    try {
      final formData = FormData.fromMap({
        ApiKeys.emailCapital: email,
        ApiKeys.vehicleColor: vehicleColor,
        ApiKeys.fullName: fullName,
        ApiKeys.phone: phone,
        ApiKeys.birthDay: bDate,
        ApiKeys.vehicleType: vehicleType,
        ApiKeys.vehicleModel: vehicleModel,
        ApiKeys.vehicleNumber: vehicleNumber,
        ApiKeys.drivingExperienceYears: drivingExperienceYears,
        ApiKeys.description: description,
        ApiKeys.latitude: lat,
        ApiKeys.longitude: lng,
        ApiKeys.photo: await convertImageToMultipart(photo),
        ApiKeys.carImages: await convertFilesToMultipart(vehicleImages),
        ApiKeys.driverFiles: await convertPlatformFilesToMultipart(driverFiles),
      });

      await api.post(
        "api/Driver/CompleteRegister",
        body: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> technicantCompleteInfo({
    required String email,
    required String fullName,
    required String phone,
    required String bDate,
    required int experienceYears,
    required int specialty,
    required double lng,
    required double lat,
    required String description,
    required File photo,
    required List<PlatformFile> technicantDocuments,
  }) async {
    try {
      final formData = FormData.fromMap({
        ApiKeys.photoCap: await convertImageToMultipart(photo),
        ApiKeys.documents: await convertPlatformFilesToMultipart(
          technicantDocuments,
        ),
      });

      await api.post(
        ApiEndPoints.technicantCompleteInfo,
        queryParameters: {
          ApiKeys.emailCapital: email,
          ApiKeys.fullName: fullName,
          ApiKeys.phone: phone,
          ApiKeys.birthDay: bDate,
          ApiKeys.experienceYears: experienceYears,
          ApiKeys.description: description,
          ApiKeys.latitude: lat,
          ApiKeys.longitude: lng,
          ApiKeys.specialty: specialty + 1,
        },
        body: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<RestaurantCatergoriesModel>>>
  getRestaurantCategories() async {
    try {
      final response = await api.get(ApiEndPoints.getRestaurantCategories);
      final List<RestaurantCatergoriesModel> catergories = [];
      for (var catergory in response[ApiKeys.data]) {
        catergories.add(RestaurantCatergoriesModel.fromJson(catergory));
      }
      return Right(catergories);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> restaurantCompleteInfo({
    required String email,
    required String restaurantName,
    required String ownerName,
    required String description,
    required String phone,
    required int categoryId,
    required File photo,
    required List<File> restaurantImages,
  }) async {
    try {
      final formData = FormData.fromMap({
        ApiKeys.email: email,
        ApiKeys.name: restaurantName,
        ApiKeys.descriptionSmall: description,
        ApiKeys.phoneNumber: phone,
        ApiKeys.profile: await convertImageToMultipart(photo),
        ApiKeys.gallery: await convertFilesToMultipart(restaurantImages),
        ApiKeys.ownerName: ownerName,
        ApiKeys.restaurantCategoryId: categoryId,
      });

      await api.post(
        ApiEndPoints.restaurantCompleteInfo,
        body: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
