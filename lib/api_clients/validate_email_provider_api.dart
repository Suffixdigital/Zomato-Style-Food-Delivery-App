import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smart_flutter/model/email_request.dart';
import 'package:smart_flutter/model/email_response.dart';

part 'validate_email_provider_api.g.dart';

@RestApi(baseUrl: 'https://evqveotscootuaaruplk.functions.supabase.co/')
abstract class EmailProviderApi {
  factory EmailProviderApi(Dio dio, {String baseUrl}) = _EmailProviderApi;

  @POST('validate-email-provider')
  Future<EmailValidationResponse> validateEmail(
    @Body() EmailValidationRequest request,
  );
}
