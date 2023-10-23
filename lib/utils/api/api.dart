import 'package:cotally/utils/constants.dart';

import 'base_api.dart';
import 'gitee.dart';

final giteeApi = GiteeApi();

BaseRepoApi apiOf(Org org) {
  return giteeApi;
}
