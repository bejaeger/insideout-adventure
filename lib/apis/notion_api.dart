import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/datamodels/feedback/feedback.dart';
import 'package:notion_api/notion.dart';
import 'package:notion_api/notion/general/property.dart';
import 'package:notion_api/notion/general/rich_text.dart';
import 'package:notion_api/notion/objects/pages.dart';
import 'package:notion_api/notion/objects/parent.dart';
import 'package:notion_api/responses/notion_response.dart';
import 'package:afkcredits/app/app.logger.dart';

// ? service/api for notion for different operational tasks
class NotionApi {
  final AppConfigProvider _appConfigProvider = locator<AppConfigProvider>();

  final log = getLogger("NotionApi");

  Future uploadFeedback({required Feedback feedback}) async {
    // uploads page/entry to feedback database on notion
    // @see: https://www.notion.so/fdd1923780ed460c8c213670bd45404e?v=29c5ff15ff424a0ebede114ebaaf3e5c
    // or
    // @see: https://www.notion.so/a24ab0b6691c4b71a3b836fb6f63935b?v=e696cc5722674485800a0deaeaf14f21

    Page page = Page(
      parent: Parent.database(
          id: _appConfigProvider.notionFeedbackDatabaseId), // <- database
      title: Text(feedback.userName),
    );

    // add all properties in feedback
    Map<String, dynamic> jsonFeedback = feedback.toJson();
    jsonFeedback.forEach(
      (key, value) {
        String? valueToAdd;
        if (value is List<String>) {
          List<String> newValue = List.from(value);
          valueToAdd = newValue.join(", ");
        } else {
          valueToAdd = value;
        }
        _addNotionDatabaseTextProperty(
            page: page, name: key, value: valueToAdd);
      },
    );

    return await _uploadNotionPage(
        notionToken: _appConfigProvider.notionFeedbackToken, page: page);
  }

  // ---------------------------------------------------
  // helper functions
  void _addNotionDatabaseTextProperty(
      {required Page page, required String name, required String? value}) {
    page.addProperty(
      name: name,
      property: RichTextProp(
        content: [
          Text(value ?? "-"),
        ],
      ),
    );
  }

  Future _uploadNotionPage(
      {required String notionToken, required Page page}) async {
    NotionClient client = NotionClient(token: notionToken);

    try {
      NotionResponse notionResponse = await client.pages.create(page);
      if (notionResponse.hasError) {
        log.e("Error when pushing data to notion: ${notionResponse.message}");
        return false;
      } else {
        log.v("Pushed entry to notion database");
        return true;
      }
    } catch (e) {
      log.wtf("Error pushing to notion: $e");
      return false;
    }
  }
}
