import 'package:pip_services_activities/pip_services_activities.dart';

void main(List<String> argument) {
  try {
    var proc = ActivitiesProcess();
    proc.configPath = './config/config.yml';
    proc.run(argument);
  } catch (ex) {
    print(ex);
  }
}

