import 'package:flutter/material.dart';
import 'package:generio/utils/app_constants.dart';
import 'package:generio/utils/query_builder.dart';
import 'package:generio/utils/query_data.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var coverLetterTypeNotifier = ValueNotifier(AppConstants.typeJobApplication);
  var resultContentNotifier = ValueNotifier("");
  var shouldShowLoaderNotifier = ValueNotifier(false);
  var professionalnessScaleNotifier = ValueNotifier(50.0);

  static const coverLetterTypes = [
    AppConstants.typeJobApplication,
    AppConstants.typeLinkedInMessage,
    AppConstants.typeLinkedInConnect,
    // typeFreelancing,
  ];

  static const designations = [
    'Senior Android Developer',
    'Senior Android Engineer',
    'Senior Mobile Developer',
    'Senior Mobile Engineer',
  ];

  static var isCopied = false;

  static var selectedCoverLetterType = coverLetterTypes[0];
  static var selectedDesignation = designations[0];

  var companyNameController = TextEditingController();
  var contactNameController = TextEditingController();
  var positionApplyingForController = TextEditingController();
  var jobDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: dashboardBody(), backgroundColor: Colors.white);
  }

  Widget dashboardBody() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.00),
            child: ColoredBox(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.0),
                  coverLetterTypeFrame(),
                  SizedBox(height: 30.0),
                  designationsFrame(),
                  SizedBox(height: 50.0),
                  ValueListenableBuilder(
                    valueListenable: coverLetterTypeNotifier,
                    builder: (context, value, child) {
                      return typeSpecificFrame(value);
                    },
                  ),
                  SizedBox(height: 50.0),
                  generateButton(),
                  resetButton(),
                  SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
        ),
        VerticalDivider(thickness: 1, color: Color(0xFFEEEEEE)),
        Expanded(flex: 6, child: outputFrame()),
      ],
    );
  }

  Widget outputFrame() {
    return ValueListenableBuilder(
      valueListenable: resultContentNotifier,
      builder: (context, String resultContent, child) {
        return ValueListenableBuilder(
          valueListenable: shouldShowLoaderNotifier,
          builder: (context, bool shouldShowProgress, child) {
            return Stack(
              alignment: Alignment.bottomRight,
              children: [
                Visibility(
                  visible: !shouldShowProgress,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 50.0),
                          SelectableText(
                            resultContent,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 50.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.directional(
                    end: 30.0,
                    bottom: 30.0,
                  ),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: FloatingActionButton(
                      onPressed: () {
                        _handleCopyFabClick();
                      },
                      shape: CircleBorder(),
                      backgroundColor: isCopied
                          ? Colors.green
                          : Colors.lightBlueAccent,
                      key: ValueKey(isCopied),
                      child: Icon(
                        isCopied ? Icons.done : Icons.copy,
                        key: ValueKey(isCopied ? 'done' : 'copy'),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: shouldShowProgress,
                  child: Center(
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Lottie.asset(
                        'assets/lottie/generating_content.json',
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _handleCopyFabClick() async {
    if (resultContentNotifier.value.isEmpty) return;

    Clipboard.setData(ClipboardData(text: resultContentNotifier.value));

    if (isCopied) return;

    setState(() {
      isCopied = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isCopied = false;
    });
  }

  Widget typeSpecificFrame(String type) {
    Widget respectiveWidget = Container();
    if (type == AppConstants.typeJobApplication) {
      respectiveWidget = jobApplicationFrame();
    } else if (type == AppConstants.typeLinkedInMessage ||
        type == AppConstants.typeLinkedInConnect) {
      respectiveWidget = linkedInMessageFrame();
    } else {
      respectiveWidget = freelancingFrame();
    }

    return respectiveWidget;
  }

  Widget jobApplicationFrame() {
    return Column(
      children: [
        editText(
          hintText: 'Organisation Name',
          controller: companyNameController,
        ),
        SizedBox(height: 30.0),
        editText(
          hintText: 'Position Applying For',
          controller: positionApplyingForController,
        ),
        SizedBox(height: 30.0),
        editText(
          hintText: 'Job Description',
          controller: jobDescriptionController,
          lines: 5,
        ),
        SizedBox(height: 30.0),
        Column(
          children: [
            ValueListenableBuilder(
              valueListenable: professionalnessScaleNotifier,
              builder: (context, double sliderValue, child) {
                return Slider(
                  value: sliderValue,
                  onChanged: (value) => {
                    professionalnessScaleNotifier.value = value,
                  },
                  min: 0,
                  max: 100,
                  divisions: 10,
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Casual'), Text('Professional')],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget linkedInMessageFrame() {
    return Column(
      children: [
        editText(
          hintText: 'Organisation Name',
          controller: companyNameController,
        ),
        SizedBox(height: 30.0),
        editText(
          hintText: 'Position Applying For',
          controller: positionApplyingForController,
        ),
        SizedBox(height: 30.0),
        editText(hintText: 'Contact Person', controller: contactNameController),
      ],
    );
  }

  Widget freelancingFrame() {
    return Column();
  }

  Widget editText({required hintText, required controller, int lines = 1}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        maxLines: lines,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget generateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: FilledButton(
        onPressed: () => _generate(),
        child: Text('Generate'),
      ),
    );
  }

  Widget resetButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: TextButton(onPressed: () => _reset(), child: Text('Reset')),
    );
  }

  _generate() {
    if (selectedCoverLetterType == AppConstants.typeJobApplication) {
      if (companyNameController.text.isEmpty) return;
      if (positionApplyingForController.text.isEmpty) return;
      if (jobDescriptionController.text.isEmpty) return;
    } else if (selectedCoverLetterType == AppConstants.typeLinkedInMessage ||
        selectedCoverLetterType == AppConstants.typeLinkedInConnect) {
      if (companyNameController.text.isEmpty) return;
      if (positionApplyingForController.text.isEmpty) return;
      if (contactNameController.text.isEmpty) return;
    }

    final queryData = QueryData(
      coverLetterType: selectedCoverLetterType,
      myProfile: selectedDesignation,
      companyName: companyNameController.text,
      positionApplyingFor: positionApplyingForController.text,
      jobDescription: jobDescriptionController.text,
      professionalLevel: professionalnessScaleNotifier.value,
    );
    final query = QueryBuilder.buildQuery(queryData);
    _makeApiCall(query);
  }

  _reset() {
    companyNameController.text = '';
    positionApplyingForController.text = '';
    contactNameController.text = '';
    resultContentNotifier.value = '';
    jobDescriptionController.text = '';
    setState(() {
      selectedCoverLetterType = coverLetterTypes[0];
      selectedDesignation = designations[0];
    });
  }

  Widget coverLetterTypeFrame() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        frameTitle('Choose type of cover letter'),
        Column(
          children: coverLetterTypes
              .map(
                (type) => radioButtonTile(
                  type: type,
                  selectedGroupValue: selectedCoverLetterType,
                  doOnChanged: (value) {
                    selectedCoverLetterType = value;
                    coverLetterTypeNotifier.value = selectedCoverLetterType;
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  RadioListTile<String> radioButtonTile({
    required type,
    required selectedGroupValue,
    required Function(String) doOnChanged,
  }) {
    return RadioListTile(
      value: type,
      title: Text(
        type,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16.0),
      ),
      groupValue: selectedGroupValue,
      onChanged: (value) {
        setState(() {
          doOnChanged(value!);
        });
      },
    );
  }

  Widget designationsFrame() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        frameTitle('Choose profile'),
        Column(
          children: designations
              .map(
                (type) => radioButtonTile(
                  type: type,
                  selectedGroupValue: selectedDesignation,
                  doOnChanged: (value) {
                    selectedDesignation = value;
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget frameTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  _makeApiCall(String query) async {
    shouldShowLoaderNotifier.value = true;
    final requestBody = {
      "model": "mistralai/mistral-7b-instruct-v0.3",
      "messages": [
        {"role": "user", "content": query},
      ],
      "temperature": 0.7,
    };

    var url = Uri.http('localhost:1234', '/v1/chat/completions');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Specify JSON headers
      },
      body: convert.jsonEncode(requestBody),
    );
    shouldShowLoaderNotifier.value = false;
    if (response.statusCode == 200) {
      final responseData =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      final String? content =
          responseData['choices']?[0]?['message']?['content'];
      resultContentNotifier.value = content ?? '';
    } else {
      resultContentNotifier.value = "Something went wrong";
    }
  }
}


//job posting

// 1. position
// 2. my profile
// 3. Organisation

//LinkedIn message
// 1. position
// 2. my profile
// 3. Organisation
// 4. contact name

//LinkedIn connect
// 1. position
// 2. my profile
// 3. Organisation
// 4. contact name

//Freelancing
// 1. my profile
// 2. job description
// 3. tone