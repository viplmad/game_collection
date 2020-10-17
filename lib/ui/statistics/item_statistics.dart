import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:charts_flutter/flutter.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_statistics/item_statistics.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/year_picker_dialog.dart';


class StatisticsArguments<T> {
  StatisticsArguments({
    @required this.items,
    @required this.viewTitle,
  });

  final List<T> items;
  final String viewTitle;
}

abstract class ItemStatistics<T extends CollectionItem, D extends ItemData, K extends ItemStatisticsBloc<T, D>> extends StatelessWidget {
  const ItemStatistics({Key key, @required this.items, @required this.viewTitle}) : super(key: key);

  final List<T> items;
  final String viewTitle;

  @override
  Widget build(BuildContext context) {

    return BlocProvider<K>(
      create: (BuildContext context) {
        return statisticsBlocBuilder()..add(LoadGeneralItemStatistics());
      },
      child: statisticsBodyBuilder(),
    );

  }

  K statisticsBlocBuilder();

  ItemStatisticsBody<T, D, K> statisticsBodyBuilder();

}

abstract class ItemStatisticsBody<T extends CollectionItem, D extends ItemData, K extends ItemStatisticsBloc<T, D>> extends StatelessWidget {
  const ItemStatisticsBody({Key key, @required this.viewTitle}) : super(key: key);

  final String viewTitle;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(typesName(context) + ' - ' + viewTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.all_inbox),
            tooltip: GameCollectionLocalisations.of(context).generalString,
            onPressed: () {
              BlocProvider.of<K>(context).add(LoadGeneralItemStatistics());
            },
          ),
          BlocBuilder<K, ItemStatisticsState>(
            builder: (BuildContext context, ItemStatisticsState state) {
              int selectedYear;
              if(state is ItemYearStatisticsLoaded<D>) {
                selectedYear = state.year;
              }

              return IconButton(
                icon: Icon(Icons.date_range),
                tooltip: GameCollectionLocalisations.of(context).changeYearString,
                onPressed: () {
                  showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      return YearPickerDialog(
                        year: selectedYear,
                      );
                    },
                  ).then( (int year) {
                    if (year != null) {
                      BlocProvider.of<K>(context).add(LoadYearItemStatistics(year));
                    }
                  });
                },
              );

            },
          ),
        ],
      ),
      body: BlocBuilder<K, ItemStatisticsState>(
        builder: (BuildContext context, ItemStatisticsState state) {

          if(state is ItemGeneralStatisticsLoaded<D>) {

            return Column(
              children: <Widget>[
                Container(
                  child: ListTile(
                    leading: Icon(Icons.all_inbox),
                    title: Text(GameCollectionLocalisations.of(context).generalString),
                  ),
                  color: Colors.grey,
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        Column(
                          children: statisticsGeneralFieldsBuilder(context, state.itemData),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );

          }
          if(state is ItemYearStatisticsLoaded<D>) {

            return Column(
              children: <Widget>[
                Container(
                  child: ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text(state.year.toString()),
                  ),
                  color: Colors.grey,
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        Column(
                          children: statisticsYearFieldsBuilder(context, state.itemData),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );

          }

          return LinearProgressIndicator();

        },
      ),
    );

  }

  Widget statisticsIntField(BuildContext context, {@required String fieldName, @required int value, int total}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: value.toString(),
      shownPercentage: (total != null && total > 0)?
        GameCollectionLocalisations.of(context).percentageString(((value / total) * 100))
        :
        null,
    );

  }

  Widget statisticsDoubleField({@required String fieldName, @required double value, int total}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: value.toStringAsFixed(2),
    );

  }

  Widget statisticsDurationField(BuildContext context, {@required String fieldName, @required Duration value}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: value != null?
        GameCollectionLocalisations.of(context).durationString(value)
        :
        '',
    );

  }

  Widget statisticsMoneyField(BuildContext context, {@required String fieldName, @required double value, double total}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: GameCollectionLocalisations.of(context).euroString(value),
      shownPercentage: (total != null && total > 0)?
        GameCollectionLocalisations.of(context).percentageString(((value / total) * 100))
        :
        null,
    );

  }

  Widget statisticsGroupField({@required String groupName, @required List<StatisticsField> fields}) {

    return StatisticsFieldGroup(
      groupName: groupName,
      fields: fields,
    );

  }

  Widget statisticsHistogram({@required double height, @required String histogramName, @required List<String> labels, @required List<int> values, List<StatisticsField> Function() trailingBuilder}) {

    return ListTile(
      title: Text(histogramName),
      subtitle: Container(
        height: height,
        child: StatisticsHistogram(
          histogramName: histogramName,
          labels: labels,
          values: values,
        ),
      ),
    );

  }

  String typesName(BuildContext context);
  List<Widget> statisticsGeneralFieldsBuilder(BuildContext context, D data);
  List<Widget> statisticsYearFieldsBuilder(BuildContext context, D data);

}

class StatisticsField extends StatelessWidget {

  const StatisticsField({Key key, @required this.fieldName, @required this.shownValue, this.shownPercentage}) : super(key: key);

  final String fieldName;
  final String shownValue;
  final String shownPercentage;

  @override
  Widget build(BuildContext context) {

    return ListTileTheme.merge(
      child: ListTile(
        title: Text(fieldName),
        trailing: Text((shownValue?? '') + (shownPercentage != null? ' - ' + shownPercentage : '')),
      ),
    );

  }

}

class StatisticsFieldGroup extends StatelessWidget {

  const StatisticsFieldGroup({Key key, @required this.groupName, @required this.fields}) : super(key: key);

  final String groupName;
  final List<StatisticsField> fields;

  @override
  Widget build(BuildContext context) {

    return ExpansionTile(
      title: Text(groupName),
      children: fields,
      initiallyExpanded: false,
    );

  }
}

class StatisticsHistogram extends StatelessWidget {

  const StatisticsHistogram({Key key, @required this.histogramName, @required this.labels, @required this.values, this.trailingBuilder}) : super(key: key);

  final String histogramName;
  final List<String> labels;
  final List<int> values;
  final List<StatisticsField> Function() trailingBuilder;

  @override
  Widget build(BuildContext context) {
    List<SeriesElement> data = [];

    for(int index = 0; index < labels.length; index++) {
      String currentLabel =  labels.elementAt(index);
      int currentValue = values.elementAt(index);

      SeriesElement seriesEle = SeriesElement(currentLabel, currentValue);
      data.add(seriesEle);
    }

    final Series<SeriesElement, String> series = Series<SeriesElement, String>(
      id: histogramName,
      colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
      domainFn: (SeriesElement element, index) => element.label,
      measureFn: (SeriesElement element, index) => element.value,
      data: data,
    );

    final List<Series<SeriesElement, String>> seriesList = [
      series
    ];

    return BarChart(
      seriesList,
      animate: true,
    );
  }

}
class SeriesElement {
  final String label;
  final int value;

  SeriesElement(this.label, this.value);
}