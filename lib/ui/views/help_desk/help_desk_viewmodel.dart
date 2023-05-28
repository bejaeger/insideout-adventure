import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/faqs/faqs.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class HelpDeskViewModel extends BaseModel {
  final FirestoreApi firestoreApi = locator<FirestoreApi>();
  final log = getLogger("HelpDeskViewModel");

  FAQs faqs = FAQs(answers: [], questions: []);
  List<bool> isExpanded = [];

  Future getData() async {
    setBusy(true);
    faqs = await firestoreApi.getFaqs();
    if (faqs.answers.length != faqs.questions.length) {
      // this means something went wrong in the database
      faqs = FAQs(answers: [], questions: []);
    }
    isExpanded = List.generate(faqs.answers.length, (_) => false);
    setBusy(false);
  }

  void expansionCallback(int panelIndex, bool expanded) {
    isExpanded[panelIndex] = !expanded;
    notifyListeners();
  }
}
