import 'package:generio/utils/app_constants.dart';
import 'package:generio/utils/query_data.dart';
import 'package:generio/utils/shared_prefs_provider.dart';

class QueryBuilder {
  static final savedProfile = SharedPrefsProvider().profileInfo;
  static String buildQuery(QueryData data) {
    var finalQuery = _generateQuery(data);
    return finalQuery;
  }

  static String _generateQuery(QueryData data) {
    if (data.coverLetterType == AppConstants.typeJobApplication) {
      return _jobApplicationQuery(data);
    } else {
      return '';
    }
  }

  static String _jobApplicationQuery(QueryData data) {
    final instructions =
        "INSTRUCTIONS:- Write **only** the main cover letter message body. - **Pick from my skill pool only those directly relevant to the job description.** - Do NOT list any greeting, subject, sign-off, date, or address. - Focus on how my experience and skills match the requirements for this role. - Keep the tone professional and concise. - Total length must not exceed 300 characters. - On the scale of 0% to 100% where 0% is highly casual & 100% is highly professional, the cover letter should be at ${data.professionalLevel}% . - Strictly use British English spelling. - Always start the cover letter with text : Hello & G'day";

    final fullQuery =
        'Create a professional cover letter body for the position of ${data.positionApplyingFor} at ${data.companyName}. Use this job description : ${data.jobDescription}. My resume summary : $savedProfile. Mention my current profile as ${data.myProfile}. Use instructions : $instructions';

    final modelBehavior =
        'Act as a professional resume make and cover letter curator';
    final instructionsSet = 'System : $modelBehavior. User : $fullQuery';
    return instructionsSet;
  }
}
