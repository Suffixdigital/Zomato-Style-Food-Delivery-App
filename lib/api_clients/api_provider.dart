import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smart_flutter/model/email_phone_link_request.dart';
import 'package:smart_flutter/model/email_phone_link_response.dart';
import 'package:smart_flutter/model/email_request.dart';
import 'package:smart_flutter/model/email_response.dart';

part 'api_provider.g.dart'; // <-- IMPORTANT

@RestApi(baseUrl: 'https://evqveotscootuaaruplk.functions.supabase.co/')
abstract class ApiProvider {
  factory ApiProvider(Dio dio, {String baseUrl}) = _ApiProvider;

  @POST('validate-email-provider')
  Future<EmailValidationResponse> validateEmail(@Body() EmailValidationRequest request);

  @POST('email-phone-link')
  Future<EmailPhoneLinkResponse> emailPhoneLink(@Body() EmailPhoneLinkRequest request);
}
