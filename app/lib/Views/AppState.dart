import 'dart:async';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/AppSettings.dart';
import 'package:schulplaner8/Views/Help.dart';
import 'package:schulplaner8/Views/ManagePlanner.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/models/app_settings_data.dart';
import 'package:schulplaner8/configuration/configuration_bloc.dart';
import 'package:schulplaner8/dynamic_links/src/bloc/dynamic_link_bloc.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:authentification/authentification_blocs.dart';

import 'home_of_app.dart';
import 'sign_in_notice.dart';

class SimpleItem {
  IconData? iconData;
  Color? color;
  String? id;
  String? name;
  SimpleItem({this.id, this.name, this.iconData, this.color});
}

class AppSettingsStateHead extends StatefulWidget {
  final DynamicLinksBloc dynamicLinksLogic;
  final AuthentificationBloc authentificationBloc;
  final AppSettingsBloc appSettingsBloc;

  const AppSettingsStateHead({
    Key? key,
    required this.dynamicLinksLogic,
    required this.authentificationBloc,
    required this.appSettingsBloc,
  }) : super(key: key);

  @override
  _AppSettingsState createState() => _AppSettingsState(
      dynamicLinksLogic, authentificationBloc, appSettingsBloc);
}

class _AppSettingsState extends State<AppSettingsStateHead>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final DynamicLinksBloc dynamicLinksLogic;
  final AuthentificationBloc authentificationBloc;
  final AppSettingsBloc appSettingsBloc;

  _AppSettingsState(
    this.dynamicLinksLogic,
    this.authentificationBloc,
    this.appSettingsBloc,
  );

  late Timer _timerLink;

  @override
  void initState() {
    super.initState();
    widget.dynamicLinksLogic.initDynamicLinks();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // This delay is need for iOS, to catch the dynamic link
      _timerLink = Timer(const Duration(milliseconds: 500), () {
        widget.dynamicLinksLogic.initDynamicLinks();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final appSettingsBloc = BlocProvider.of<AppSettingsBloc>(context);
    final navigationBloc = NavigationBloc.of(context);
    return StreamBuilder<AppSettingsData>(
      stream: appSettingsBloc.appSettingsData,
      initialData: appSettingsBloc.currentValue,
      builder: (context, snapshot) {
        final appSettingsData = snapshot.data;
        return MaterialApp(
          onGenerateTitle: (BuildContext context) =>
              MyAppLocalizations.of(context)!.apptitle,
          localizationsDelegates: [
            const MyAppLocalizationsDelegate(),
            const CupertinoEnDefaultLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'), // English
            const Locale('de', 'DE'), // German
            // ... other locales the app supports
          ],
          locale: appSettingsData?.languagecode != null
              ? Locale(appSettingsData!.languagecode!)
              : null,
          theme: appSettingsData?.getThemeData() ??
              ThemeData(
                primaryColor: Colors.teal,
                accentColor: Colors.redAccent,
                brightness: Brightness.light,
                bottomSheetTheme: bottomSheetTheme,
                dialogTheme: dialogTheme,
                backgroundColor: getBackgroundColor(context),
                scaffoldBackgroundColor: getBackgroundColor(context),
              ),
          navigatorObservers: [
            //if (!PlatformCheck.isMacOS)
            // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
          ],
          debugShowCheckedModeBanner: false,
          home: HomeOfApp(),
          navigatorKey: navigationBloc.navigatorKey,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SelectPlannerView extends StatefulWidget {
  SelectPlannerView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => SelectPlannerViewState();
}

class SelectPlannerViewState extends State<SelectPlannerView> {
  @override
  Widget build(BuildContext context) {
    final plannerLoaderBloc = BlocProvider.of<PlannerLoaderBloc>(context);
    final configurationBloc = ConfigurationBloc.get(context);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),
                  SignInNotice(),
                  CircleAvatar(
                    backgroundColor: getAccentColor(context),
                    radius: 44.0,
                    child: Icon(
                      Icons.school,
                      size: 44.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    getString(context).selectplanner,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Card(
                      elevation: 12.0,
                      margin: EdgeInsets.all(6.0),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (((plannerLoaderBloc.loadAllPlannerStatusValue
                                  .getAllPlanner())
                              .isNotEmpty)) ...[
                            for (final it in plannerLoaderBloc
                                .loadAllPlannerStatusValue
                                .getAllPlanner())
                              ListTile(
                                title: Text(it.name),
                                leading: Icon(Icons.school),
                                onTap: () {
                                  plannerLoaderBloc.setActivePlanner(it.id);
                                },
                              ),
                          ] else
                            ListTile(
                              leading: Icon(Icons.help_outline),
                              title: Text(
                                getString(context).noplannersavailable,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          StreamBuilder<bool>(
                              stream: configurationBloc.isSignInPossibleStream,
                              initialData:
                                  configurationBloc.isSignInPossibleValue,
                              builder: (context, isSignInPossibleSnapshot) {
                                final isSignInPossible =
                                    isSignInPossibleSnapshot.data!;
                                if (!isSignInPossible) {
                                  return Container();
                                }
                                return InkWell(
                                  onTap: () {
                                    pushWidget(
                                        context,
                                        NewPlannerView(
                                          plannerLoaderBloc: plannerLoaderBloc,
                                          activateplanner: true,
                                        ));
                                  },
                                  child: SizedBox(
                                    height: 72.0,
                                    child: Center(
                                      child: FlatButton.icon(
                                        icon: Icon(
                                          Icons.add,
                                          size: 28.0,
                                        ),
                                        label: Text(
                                          getString(context).newplanner,
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        onPressed: null,
                                        disabledTextColor:
                                            getAccentColor(context),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 12.0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0))),
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: LabeledIconButtonSmall(
                            onTap: () {
                              pushWidget(context, HelpView());
                            },
                            iconData: Icons.help,
                            name: getString(context).help,
                          )),
                          Expanded(
                              child: LabeledIconButtonSmall(
                            onTap: () {
                              pushWidget(context, AppSettingsView());
                            },
                            iconData: Icons.settings,
                            name: getString(context).settings,
                          )),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
