import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insighttalk_backend/apis/expert/expert_apis.dart';
import 'package:insighttalk_backend/apis/userApis/auth_user.dart';
import 'package:insighttalk_backend/modal/modal_expert.dart';
import 'package:insighttalk_frontend/pages/appointment/appointment_controller.dart';
import 'package:intl/intl.dart';

class BookAppointmentView extends StatefulWidget {
  final DsdExpert expertData;
  const BookAppointmentView({required this.expertData, super.key});

  @override
  State<BookAppointmentView> createState() => _BookAppointmentViewState();
}

class _BookAppointmentViewState extends State<BookAppointmentView> {
  final ITUserAuthSDK _itUserAuthSDK = ITUserAuthSDK();
  String selectedCategory = '';

  final DsdAppointmentController _dsdAppointmentController =
      DsdAppointmentController();
  List<DateTime> availableDates = [
    DateTime(2024, 8, 18),
    DateTime(2024, 8, 22),
    DateTime(2024, 8, 24),
    DateTime(2024, 8, 25),
    DateTime(2024, 9, 1),
  ];
  TextEditingController reasonController = TextEditingController();
  List<DateTime> availableTimeSlots = [];
  // Future<void> getExpertData() async {
  //   try {
  //     DsdExpert? fetchedExpertData =
  //         await _dsdExpertApis.fetchExpertById(expertId: widget.expertId);

  //     setState(() {
  //       expertData = fetchedExpertData;

  //       print(expertData!.category![1]);
  //     });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _loadData();
  }

  // Future<void> _loadData() async {
  //   await getExpertData();

  //   if (mounted) {
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointment',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: CachedNetworkImage(
                      imageUrl: widget.expertData.profileImage!,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: 140,
                      height: 140,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.expertData.expertName ?? 'Unknown Expert',
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.expertData.expertise ?? 'Unknown',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 44, 184, 240),
                            size: 20.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            '0.0',
                            style: TextStyle(
                              color: Color.fromARGB(255, 44, 184, 240),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Select Category",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 10,
            ),
            CategorySelector(
              categories: widget.expertData.category!,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category; // Update selected category
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Select Date & Time",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 20,
            ),
            DateTimeSelector(),
            const SizedBox(
              height: 20,
            ),
            const Text("Specify Reason",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration:
                  const InputDecoration(icon: Icon(Icons.note_alt_outlined)),
              controller: reasonController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 4.0,
        elevation: 10.0,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  Text("₹ 60.00", style: TextStyle(fontSize: 20)),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  String userId = _itUserAuthSDK.getUser()!.uid;
                  await _dsdAppointmentController.createAppointment(
                      userId,
                      widget.expertData.id!,
                      Timestamp.now(),
                      reasonController.text,
                      [selectedCategory],
                      60,
                      "20 min");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 10.0),
                  textStyle: const TextStyle(fontSize: 22),
                ),
                child: const Text("Booking"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategorySelector extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<String>
      onCategorySelected; // Callback for category selection

  const CategorySelector({
    super.key,
    required this.categories,
    required this.onCategorySelected, // Accept the callback in the constructor
  });

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = -1;
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: List.generate(
          widget.categories.length,
          (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedIndex == index) {
                    selectedIndex = -1;
                    selectedCategory = '';
                  } else {
                    selectedIndex = index;
                    selectedCategory = widget.categories[index];
                  }
                  widget.onCategorySelected(
                      selectedCategory); // Notify parent of selection
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? const Color.fromRGBO(
                          173,
                          239,
                          255,
                          1,
                        )
                      : Colors.white,
                  border: selectedIndex == index
                      ? Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        )
                      : Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.categories[index],
                  style: selectedIndex == index
                      ? const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        )
                      : const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ), // Text color
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DateTimeSelector extends StatefulWidget {
  const DateTimeSelector({super.key});

  @override
  _DateTimeSelectorState createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  List<DateTime> availableDates = [
    DateTime(2024, 8, 18),
    DateTime(2024, 8, 19),
    DateTime(2024, 8, 20),
    DateTime(2024, 8, 21),
  ];
  List<String> availableTimes = [
    '09:00 AM',
    '11:00 AM',
    '02:00 PM',
    '04:00 PM'
  ];

  DateTime? selectedDate;
  String? selectedTime;
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 6.0,
          children: List.generate(availableDates.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = availableDates[index];
                  selectedTime = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selectedDate == availableDates[index]
                      ? const Color.fromRGBO(173, 239, 255, 1)
                      : Colors.white,
                  border: selectedDate == availableDates[index]
                      ? Border.all(color: Colors.blue, width: 2.0)
                      : Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('EEE').format(availableDates[index]),
                      style: selectedDate == availableDates[index]
                          ? const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w500)
                          : const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      DateFormat('d/M/y').format(availableDates[index]),
                      style: selectedDate == availableDates[index]
                          ? const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w500)
                          : const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8.0,
          children: List.generate(availableTimes.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTime = availableTimes[index];
                  selectedDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
                    '${DateFormat('yyyy-MM-dd').format(selectedDate!)} ${availableTimes[index]}',
                  );
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selectedTime == availableTimes[index]
                      ? const Color.fromRGBO(173, 239, 255, 1)
                      : Colors.white,
                  border: selectedTime == availableTimes[index]
                      ? Border.all(color: Colors.blue, width: 2.0)
                      : Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  availableTimes[index],
                  style: selectedTime == availableTimes[index]
                      ? const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w500)
                      : const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        if (selectedDateTime != null)
          Center(
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.blue,
                ),
                Text(
                  'Appointment: ${DateFormat('E, yyyy-MM-dd | hh:mm a').format(selectedDateTime!)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
