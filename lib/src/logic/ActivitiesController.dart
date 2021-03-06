import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../src/data/version1/PartyActivityV1.dart';
import '../../src/persistence/IActivitiesPersistence.dart';
import './IActivitiesController.dart';
import './ActivitiesCommandSet.dart';

class ActivitiesController
    implements
        IActivitiesController,
        IConfigurable,
        IReferenceable,
        ICommandable {
  static final ConfigParams _defaultConfig = ConfigParams.fromTuples([
    'dependencies.persistence',
    'pip-services-activities:persistence:*:*:1.0'
  ]);
  IActivitiesPersistence persistence;
  ActivitiesCommandSet commandSet;
  DependencyResolver dependencyResolver =
      DependencyResolver(ActivitiesController._defaultConfig);

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    dependencyResolver.configure(config);
  }

  /// Set references to component.
  ///
  /// - [references]    references parameters to be set.
  @override
  void setReferences(IReferences references) {
    dependencyResolver.setReferences(references);
    persistence = dependencyResolver
        .getOneRequired<IActivitiesPersistence>('persistence');
  }

  /// Gets a command set.
  ///
  /// Return Command set
  @override
  CommandSet getCommandSet() {
    commandSet ??= ActivitiesCommandSet(this);
    return commandSet;
  }

  /// Gets a page of party activities retrieved by a given filter.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items
  /// - [paging]            (optional) paging parameters
  /// Return Future that receives a data page
  /// Throws error.
  @override
  Future<DataPage<PartyActivityV1>> getPartyActivities(
      String correlationId, FilterParams filter, PagingParams paging) {
    return persistence.getPageByFilter(correlationId, filter, paging);
  }

  /// Logs party activity.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [activity]              an activity to be logged.
  /// Return         (optional) Future that receives logged activity or error.
  @override
  Future<PartyActivityV1> logPartyActivity(
      String correlationId, PartyActivityV1 activity) {
    activity.time = DateTimeConverter.toNullableDateTime(activity.time);
    activity.time = activity.time ?? DateTime.now();
    return persistence.create(correlationId, activity);
  }

  /// Logs batch of party activities.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [activities]              a list of activities to be logged.
  /// Return         (optional) Future that receives logged activities or error.
  @override
  Future<List<PartyActivityV1>> batchPartyActivities(
      String correlationId, List<PartyActivityV1> activities) async {
    activities
        .forEach((activity) => persistence.create(correlationId, activity));
    return activities;
  }

  /// Deletes party activities that match to a given filter.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items.
  /// Return                Future that receives null for success.
  /// Throws error
  @override
  Future deletePartyActivities(String correlationId, dynamic filter) {
    return persistence.deleteByFilter(correlationId, filter);
  }
}
