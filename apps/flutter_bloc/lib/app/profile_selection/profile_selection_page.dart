import 'package:core/ui/profiles_grid.dart';
import 'package:core/models/profile/profiles_data.dart';
import 'package:core/persistence/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_demo_flutter_bloc/app/create_profile/create_profile_page_builder.dart';

class ProfileSelectionPage extends StatelessWidget {
  Future<void> addProfile(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => CreateProfilePageBuilder.create(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profilesData = RepositoryProvider.of<ProfilesData>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile selection'),
      ),
      body: ProfilesGrid(
        profilesData: profilesData,
        onAddProfile: () => addProfile(context),
        onSelectedProfile: (profile) async {
          final localDB = RepositoryProvider.of<LocalDB>(context);
          // the selected profile is an app-state variable.
          // changing this will cause a reload of AppStartupPage
          await localDB.setSelectedProfile(profile);
        },
      ),
    );
  }
}