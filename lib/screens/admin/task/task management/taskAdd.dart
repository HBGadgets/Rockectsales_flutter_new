import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rocketsale_rs/models/task_model/addTask_model.dart';
import '../../../../controllers/task_a_controller/task_add_controller.dart';

class AddTaskPage extends StatefulWidget {
  final String salesmanId;

  const AddTaskPage({super.key, required this.salesmanId});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskAddController controller = Get.put(TaskAddController());

  @override
  void initState() {
    super.initState();
    controller.selectedSalesmanId.value = widget.salesmanId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                ...controller.taskMap.entries.map((entry) {
                  return TextField(
                    decoration: InputDecoration(
                      labelText: 'Task Description ${entry.key}',
                    ),
                    onChanged: (value) =>
                        controller.updateTask(entry.key, value),
                  );
                }).toList(),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: controller.addNewTaskField,
                  child: const Text('+ Add Another Task'),
                ),
                const SizedBox(height: 12),
                TextField(
                  readOnly: true,
                  onTap: () => controller.selectDateTime(context),
                  decoration: const InputDecoration(
                    labelText: 'Deadline',
                    hintText: 'dd-mm-yyyy – hh:mm',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: controller.selectedDateTime.value == null
                        ? ''
                        : DateFormat('dd-MM-yyyy – hh:mm a')
                            .format(controller.selectedDateTime.value!),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  onChanged: (value) => controller.address.value = value,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Geofence>(
                  value: controller.selectedGeofence.value,
                  decoration: const InputDecoration(
                    labelText: 'Select Geofence',
                    //border: OutlineInputBorder(),
                  ),
                  hint: const Text('Select Geofence'),
                  onChanged: (Geofence? value) {
                    controller.selectedGeofence.value = value;
                  },
                  items: controller.geofences.map((geo) {
                    return DropdownMenuItem<Geofence>(
                      value: geo,
                      child: Text(geo.shopName),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 250),
                GestureDetector(
                  onTap: controller.submitTask,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
