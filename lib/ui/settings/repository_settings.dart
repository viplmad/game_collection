import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/connector/image/cloudinary/cloudinary_connector.dart';
import 'package:game_collection/connector/item/sql/postgres/postgres_connector.dart';

import 'package:game_collection/model/repository_radio.dart';

import 'package:game_collection/bloc/repository_settings/repository_settings.dart';
import 'package:game_collection/bloc/repository_settings_radio/repository_settings_radio.dart';

import '../common/show_snackbar.dart';
import '../route_constants.dart';


class RepositorySettings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<RepositorySettingsBloc>(
          create: (BuildContext context) {
            return RepositorySettingsBloc()..add(LoadRepositorySettings());
          },
        ),

        BlocProvider<RepositorySettingsRadioBloc>(
          create: (BuildContext context) {
            return RepositorySettingsRadioBloc();
          },
        ),
      ],

      child: Scaffold(
        appBar: AppBar(
          title: Text("Repository settings"),
        ),
        body: _RepositorySettingsBody(),
      ),
    );

  }

}

class _RepositorySettingsBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        child: BlocListener<RepositorySettingsBloc, RepositorySettingsState>(
          listener: (BuildContext context, RepositorySettingsState state) {
            if(state is RepositorySettingsUpdated) {
              Navigator.pushReplacementNamed(
                context,
                connectRoute,
              );
            }
            if(state is RepositorySettingsNotUpdated) {
              String message = "Unable to update connection";
              showSnackBar(
                scaffoldState: Scaffold.of(context),
                message: message,
                snackBarAction: dialogSnackBarAction(
                  context,
                  label: "More",
                  title: message,
                  content: state.error,
                ),
              );
            }
          },
          child: BlocBuilder<RepositorySettingsRadioBloc, RepositorySettingsRadioState>(
            builder: (BuildContext context, RepositorySettingsRadioState radioState) {

              return BlocBuilder<RepositorySettingsBloc, RepositorySettingsState>(
                builder: (BuildContext context, RepositorySettingsState state) {
                  PostgresInstance postgresInstance;
                  CloudinaryInstance cloudinaryInstance;

                  if(state is RepositorySettingsLoading) {

                    return LinearProgressIndicator();

                  }
                  if(state is RemoteRepositorySettingsLoaded) {
                    postgresInstance = state.postgresInstance;
                    cloudinaryInstance = state.cloudinaryInstance;
                  }

                  return ExpansionPanelList(
                    expansionCallback: (int panelIndex, bool isExpanded) {

                      if(panelIndex == 0) {
                        if(!isExpanded) {

                          BlocProvider.of<RepositorySettingsRadioBloc>(context).add(
                            UpdateRepositorySettingsRadio(RepositorySettingsRadio.Remote),
                          );

                        }
                      } else if(panelIndex == 1) {
                        if(!isExpanded) {

                          BlocProvider.of<RepositorySettingsRadioBloc>(context).add(
                            UpdateRepositorySettingsRadio(RepositorySettingsRadio.Local),
                          );

                        }
                      }

                    },
                    children: [
                      _remoteExpansionPanel(context, radioState.radio, postgresInstance, cloudinaryInstance),
                      _localRepositoryPanel(context, radioState.radio),
                    ],
                  );

                },
              );

            },
          ),
        ),
      ),
    );

  }

  ExpansionPanel _remoteExpansionPanel(BuildContext context, RepositorySettingsRadio radioGroup, [PostgresInstance postgresInstance, CloudinaryInstance cloudinaryInstance]) {

    String _host;
    int _port;
    String _db;
    String _user;
    String _pass;

    String _cloud;
    int _apiKey;
    String _apiSecret;

    return _repositoryExpansionPanel(
      context,
      title: "Remote repository",
      radioGroup: radioGroup,
      radioValue: RepositorySettingsRadio.Remote,
      textForms: [
        _headerText(context, "Postgres"),
        textFormField(
          labelText: 'Host',
          initialValue: postgresInstance?.host,
          onSaved: (String value) {
            _host = value;
          },
        ),
        numberFormField(
          labelText: 'Port',
          initialValue: postgresInstance?.port,
          onSaved: (String value) {
            _port = int.parse(value);
          },
        ),
        textFormField(
          labelText: 'Database',
          initialValue: postgresInstance?.database,
          onSaved: (String value) {
            _db = value;
          },
        ),
        textFormField(
          labelText: 'User',
          initialValue: postgresInstance?.user,
          onSaved: (String value) {
            _user = value;
          },
        ),
        textFormField(
          labelText: 'Password',
          initialValue: postgresInstance?.password,
          obscureText: true,
          onSaved: (String value) {
            _pass = value;
          },
        ),
        _headerText(context, "Cloudinary"),
        textFormField(
          labelText: 'Cloud name',
          initialValue: cloudinaryInstance?.cloudName,
          onSaved: (String value) {
            _cloud = value;
          },
        ),
        numberFormField(
          labelText: 'API Key',
          initialValue: cloudinaryInstance?.apiKey,
          onSaved: (String value) {
            _apiKey = int.parse(value);
          },
        ),
        textFormField(
          labelText: 'API Secret',
          initialValue: cloudinaryInstance?.apiSecret,
          obscureText: true,
          onSaved: (String value) {
            _apiSecret = value;
          },
        ),
      ],
      onUpdate: () {
        BlocProvider.of<RepositorySettingsBloc>(context).add(
          UpdateRemoteConnectionSettings(
            PostgresInstance(
              host: _host,
              port: _port,
              database: _db,
              user: _user,
              password: _pass,
            ),
            CloudinaryInstance(
              cloudName: _cloud,
              apiKey: _apiKey,
              apiSecret: _apiSecret,
            ),
          ),
        );
      }
    );

  }

  ExpansionPanel _localRepositoryPanel(BuildContext context, RepositorySettingsRadio radioGroup) {

    return _repositoryExpansionPanel(
      context,
      title: "Local repository",
      radioGroup: radioGroup,
      radioValue: RepositorySettingsRadio.Local,
      textForms: [
        _headerText(context, "Under construction"),
      ],
    );

  }

  Widget _headerText(BuildContext context, String text) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: Theme.of(context).textTheme.subtitle1),
    );

  }

  Widget textFormField({String labelText, String initialValue, bool obscureText = false, void Function(String) onSaved}) {

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText,
        decoration: _inputDecoration(
          labelText: labelText,
        ),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );

  }

  Widget numberFormField({String labelText, int initialValue, bool obscureText = false, void Function(String) onSaved}) {

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
      child: TextFormField(
        initialValue: initialValue != null? initialValue.toString() : '',
        obscureText: obscureText,
        decoration: _inputDecoration(
          labelText: labelText,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some number';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );

  }

  InputDecoration _inputDecoration({String labelText}) {

    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
    );

  }

  ExpansionPanel _repositoryExpansionPanel(BuildContext context, {RepositorySettingsRadio radioGroup, RepositorySettingsRadio radioValue, String title, List<Widget> textForms, void Function() onUpdate}) {

    final _formKey = GlobalKey<FormState>();

    return ExpansionPanel(
      isExpanded: radioGroup == radioValue,
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          leading: IgnorePointer(
            child: Radio<RepositorySettingsRadio>(
                groupValue: radioGroup,
                value: radioValue,
                onChanged: (_) {}
            ),
          ),
          title: Text(title),
        );
      },
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: textForms..add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text("Save"),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    onUpdate();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );

  }

}
