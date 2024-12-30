import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lets_go_with_me/business_logic/cubits/create_event_cubit.dart';
import 'package:lets_go_with_me/business_logic/cubits/profile_cubit.dart';
import 'package:lets_go_with_me/core/util/user_preferences.dart';
import 'package:lets_go_with_me/data/models/create_event_model.dart';
import 'package:lets_go_with_me/data/repositories/create_event_repo.dart';

import '../../core/constants/widget_constants.dart';
import '../../core/util/locator.dart';
import '../reusable_widgets/filled_card_text_button.dart';
import '../reusable_widgets/text_form_field_widget.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  late int startDateInMillis;
  late int endDateInMillis;

  var isLoading = false;
  String profilePicUrl = "";

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _eventTitleTextEditingController =
  TextEditingController();
  final TextEditingController _descriptionTextEditingController =
  TextEditingController();
  final TextEditingController _startDateTextEditingController =
  TextEditingController();
  final TextEditingController _endDateTextEditingController =
  TextEditingController();
  final TextEditingController _startPointTextEditingController =
  TextEditingController();
  final TextEditingController _tripLocationTextEditingController =
  TextEditingController();
  final TextEditingController _costTextEditingController =
  TextEditingController();

  late BuildContext buildContext;

  String dropdownValue = '';

  // List of items in our dropdown menu
  var items = [
    'Hyderabad',
    'Mumbai',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateEventCubit(
          createEventRepo: locator<CreateEventRepo>(), networkInfo: locator()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Create Event",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            //form
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: [
                        Container(
                          height: 95,
                          width: 105,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                              const BorderRadius.all(Radius.circular(32.0))),
                          child: BlocConsumer<CreateEventCubit,
                              CreateEventState>(
                            listener: (context, state) async {
                              if (state is SaveEventDetailsSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Trip created successfully."),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                                Navigator.pop(context);
                              }

                              if (state is SaveEventDetailsError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        state
                                            .message),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }

                              if (state is UploadEventProfilePicError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is UploadEventProfilePicInProgress) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else
                              if (state is UploadEventProfilePicSuccess) {
                                profilePicUrl = state.profilePicUrl;
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(32.0),
                                    child: Image.asset(profilePicUrl.replaceAll("/home/vassar-divyanshu/AndroidStudioProjects/Personal/letsgowithme/", "")));
                              }
                              return Stack(children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(32.0),
                                  child: Image.asset(
                                      "assets/images/profile_icon.png"),
                                ),
                                Positioned(
                                    top: 30,
                                    right: 30,
                                    left: 30,
                                    bottom: 30,
                                    child: IconButton(
                                      onPressed: () async {
                                        await _pickImage(context);
                                      },
                                      icon: const Icon(Icons.upload),
                                    ))
                              ]);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Event Title",
                                    style: TextStyle(color: Colors.grey[600]),
                                    children: <TextSpan>[
                                      // Red * to show if the field is mandatory
                                      TextSpan(
                                        text: ' *',
                                        style: normalRedTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 52,
                                  width: 237,
                                  child: TextFormFieldWidget(
                                    inputFormatters: const [],
                                    hintText: "Event title",
                                    textEditingController:
                                    _eventTitleTextEditingController,
                                    onChanged: (val) async {

                                    },
                                    validator: (val) {
                                      return null;
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Description",
                        style: TextStyle(color: Colors.grey[600]),
                        children: <TextSpan>[
                          // Red * to show if the field is mandatory
                          TextSpan(
                            text: ' *',
                            style: normalRedTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return TextFormFieldWidget(
                          inputFormatters: const [],
                          hintText: "Description",
                          textEditingController: _descriptionTextEditingController,
                          onChanged: (val) async {},
                          validator: (val) {
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Start Date",
                        style: TextStyle(color: Colors.grey[600]),
                        children: <TextSpan>[
                          // Red * to show if the field is mandatory
                          TextSpan(
                            text: '*',
                            style: normalRedTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          TextFormFieldWidget(
                            inputFormatters: const [],
                            hintText: "Start Date",
                            textEditingController: _startDateTextEditingController,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: InkWell(
                              onTap: () {
                                _selectDate(context, true);
                              },
                              child: const SizedBox(
                                child: Image(
                                  image: AssetImage(calendar),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: RichText(
                      text: TextSpan(
                        text: "End Date",
                        style: TextStyle(color: Colors.grey[600]),
                        children: <TextSpan>[
                          // Red * to show if the field is mandatory
                          TextSpan(
                            text: '*',
                            style: normalRedTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          TextFormFieldWidget(
                            inputFormatters: const [],
                            hintText: "End Date",
                            textEditingController: _endDateTextEditingController,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: InkWell(
                              onTap: () {
                                _selectDate(context, false);
                              },
                              child: const SizedBox(
                                child: Image(
                                  image: AssetImage(calendar),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Start Point",
                        style: TextStyle(color: Colors.grey[600]),
                        children: <TextSpan>[
                          // Red * to show if the field is mandatory
                          TextSpan(
                            text: '*',
                            style: normalRedTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          // Add Horizontal padding using menuItemStyleData.padding so it matches
                          // the menu padding when button's width is not specified.
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // Add more decoration..
                        ),
                        hint: const Text(
                          'Start Point',
                          style: TextStyle(fontSize: 14),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Start Point';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when selected item is changed.
                          _startPointTextEditingController.text = value!;
                        },
                        onSaved: (value) {
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Trip Location",
                        style: TextStyle(color: Colors.grey[600]),
                        children: <TextSpan>[
                          // Red * to show if the field is mandatory
                          TextSpan(
                            text: '*',
                            style: normalRedTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormFieldWidget(
                        inputFormatters: const [],
                        hintText: "Trip Location",
                        textEditingController: _tripLocationTextEditingController,
                      )),

                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Estimated Cost/Person",
                        style: TextStyle(color: Colors.grey[600]),
                        children: <TextSpan>[
                          // Red * to show if the field is mandatory
                          TextSpan(
                            text: '*',
                            style: normalRedTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          TextFormFieldWidget(
                            inputFormatters: const [],
                            textEditingController: _costTextEditingController,
                            hintText: '',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                            child: InkWell(
                              onTap: () {},
                              child: const SizedBox(
                                child: Icon(Icons.currency_rupee),
                              ),
                            ),
                          ),
                        ],
                      )),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: BlocBuilder<CreateEventCubit, CreateEventState>(
                      builder: (context, state) {
                        return Center(
                          child: GestureDetector(
                            onTap: () async {
                              _submit(context);
                            },
                            child: const FilledCardTextButton(
                              backgroundColor: Color(0xFF1D3075),
                              title: "SAVE & CONTINUE",
                              buttonHeight: 48,
                              buttonWidth: 358,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2300));
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDateTextEditingController.text =
          "${picked.day}/${picked.month}/${picked.year}";
          startDateInMillis = picked.millisecondsSinceEpoch;
        } else {
          _endDateTextEditingController.text =
          "${picked.day}/${picked.month}/${picked.year}";
          endDateInMillis = picked.millisecondsSinceEpoch;
        }
      });
    }
  }

  getDisplayDate(DateTime selectedDate) {
    return DateFormat.yMMMd().format(selectedDate);
  }

  _pickImage(BuildContext context) async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: const Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: const Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker().pickImage(source: imageSource);
      if (file != null) {
        if (!mounted) {
          return;
        }
        await context
            .read<CreateEventCubit>().uploadEventProfilePic(File(file.path));
      }
    }
  }

  Future<void> _submit(BuildContext context) async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();

    final createEventModel = CreateEventModel();
    createEventModel.eventTitle = _eventTitleTextEditingController.text;
    createEventModel.eventDescription = _descriptionTextEditingController.text;
    createEventModel.startDate = startDateInMillis;
    createEventModel.endDate = endDateInMillis;
    createEventModel.startPoint = _startPointTextEditingController.text;
    createEventModel.tripLocation = _tripLocationTextEditingController.text;
    createEventModel.cost = int.parse(_costTextEditingController.text);
    createEventModel.profilePicUrl = profilePicUrl;
    createEventModel.userId = UserPreferences.userid;

    if (!mounted) {
      return;
    }

    await context
        .read<CreateEventCubit>()
        .saveEventDetails(createEventModel);
  }
}
