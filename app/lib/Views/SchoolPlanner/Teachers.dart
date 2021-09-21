//
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/teachers/teacher_detail_sheet.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/groups/src/models/teacher.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

class TeacherList extends StatelessWidget {
  final PlannerDatabase plannerDatabase;
  TeacherList({required this.plannerDatabase});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Teacher>>(
        stream: plannerDatabase.teachers.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Teacher> teacherlist = snapshot.data ?? [];
            return UpListView<Teacher>(
              items: teacherlist,
              emptyViewBuilder: (context) => EmptyListState(),
              builder: (context, teacher) {
                return ListTile(
                  title: Text(teacher.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Email: ' + (teacher.email ?? '-')),
                      Text(bothlang(context,
                          de: 'Tel: ' + (teacher.tel ?? '-'),
                          en: 'Phone: ' + (teacher.tel ?? '-'))),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    showTeacherDetail(
                        context: context,
                        plannerdatabase: plannerDatabase,
                        teacherid: teacher.teacherid);
                  },
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pushWidget(context, NewTeacherView(database: plannerDatabase));
        },
        icon: Icon(Icons.add),
        label: Text(getString(context).newteacher),
      ),
    );
  }
}

// ignore: must_be_immutable
class NewTeacherView extends StatelessWidget {
  final PlannerDatabase database;

  bool changedValues = false;
  final bool editMode;
  final String? editteacherid;

  Teacher? data;
  ValueNotifier<Teacher?> notifier = ValueNotifier(null);
  NewTeacherView(
      {required this.database, this.editMode = false, this.editteacherid}) {
    data = editMode
        ? database.teachers.getItem(editteacherid!)
        : Teacher(
            teacherid: database.dataManager.generateTeacherId(),
            name: '',
            tel: '',
            email: '',
          );
    notifier.value = data;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ValueListenableBuilder<Teacher?>(
            valueListenable: notifier,
            builder: (context, _, _2) {
              if (data == null) return CircularProgressIndicator();

              return Scaffold(
                appBar: MyAppHeader(
                    title: editMode
                        ? getString(context).editteacher
                        : getString(context).newteacher),
                body: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    FormHeader(getString(context).general),
                    FormTextField(
                      text: data!.name,
                      valueChanged: (newtext) {
                        data!.name = newtext;
                        changedValues = true;
                      },
                      labeltext: getString(context).name,
                    ),
                    FormSpace(16.0),
                    FormTextField(
                        text: data!.tel,
                        valueChanged: (newtext) {
                          data!.tel = newtext;
                          changedValues = true;
                        },
                        iconData: Icons.phone,
                        labeltext: 'Tel',
                        keyBoardType: TextInputType.phone),
                    FormSpace(16.0),
                    FormTextField(
                      text: data!.email,
                      valueChanged: (newtext) {
                        data!.email = newtext;
                        changedValues = true;
                      },
                      iconData: Icons.alternate_email,
                      labeltext: 'Email',
                      keyBoardType: TextInputType.emailAddress,
                    ),
                    FormSpace(16.0),
                    FormDivider(),
                    FormSpace(64.0),
                  ],
                )),
                floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      if (data!.validate()) {
                        if (editMode) {
                          database.dataManager.ModifyTeacher(data!);
                          Navigator.pop(context);
                        } else {
                          database.dataManager.AddTeacher(data!);
                          Navigator.pop(context);
                        }
                      } else {
                        final infoDialog = InfoDialog(
                          title: getString(context).failed,
                          message: getString(context).pleasecheckdata,
                        );
                        // ignore: unawaited_futures
                        infoDialog.show(context);
                      }
                    },
                    icon: Icon(Icons.done),
                    label: Text(getString(context).done)),
              );
            }),
        onWillPop: () async {
          if (changedValues == false) return true;
          return showConfirmDialog(
                  context: context,
                  title: getString(context).discardchanges,
                  action: getString(context).confirm,
                  richtext: RichText(
                      text: TextSpan(text: getString(context).pleasecheckdata)))
              .then((value) {
            if (value == true) {
              return true;
            } else {
              return false;
            }
          });
        });
  }
}
