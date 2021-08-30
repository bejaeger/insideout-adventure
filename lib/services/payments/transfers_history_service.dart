import 'dart:async';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/datamodels/payments/money_transfer_query_config.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/services/users/user_service.dart';

class TransfersHistoryService {
  final log = getLogger("TransfersHistoryService");

  final _firestoreApi = locator<FirestoreApi>();
  final _userService = locator<UserService>();
  User get currentUser => _userService.currentUser;

  // list of latest transactions and their subscriptions
  // Config decides which collection / documents are retrieved
  Map<MoneyTransferQueryConfig, List<MoneyTransfer>> latestTransfers = {};
  Map<MoneyTransferQueryConfig, StreamSubscription?> _transfersSubscriptions =
      {};

  // Get query for transaction for given config.
  Stream<List<MoneyTransfer>> getTransferDataStream(
      {required MoneyTransferQueryConfig config}) {
    // check arguments:
    return _firestoreApi.getTransferDataStream(
        config: config, uid: currentUser.uid);
  }

  // Get transfers for config. Using this function makes only sense
  // if a listener has been added with addTransferDataListener, seebe low
  List<MoneyTransfer> getTransfers({required MoneyTransferQueryConfig config}) {
    if (!latestTransfers.containsKey(config)) {
      log.w(
          "Did not find any transfers for config $config. Please add a listener with 'addTransferDataListener()'. Returning empty list");
      return [];
    } else {
      return latestTransfers[config]!;
    }
  }

  // More generic class to listen to firestore collections for updates.
  // callback can be used to provide notifyListeners from the viewmodel
  // to the service
  void addTransferDataListener(
      {required MoneyTransferQueryConfig config,
      required Completer<void> completer,
      void Function()? callback}) {
    if (_transfersSubscriptions.containsKey(config)) {
      log.v(
          "Stream with config '$config' already listened to, resuming it in case it has been paused!");
      _transfersSubscriptions[config]?.resume();
      completer.complete();
    } else {
      log.i("Setting up listener for transfers with config $config.");
      Stream<List<MoneyTransfer>> snapshot;
      try {
        snapshot = getTransferDataStream(config: config);

        // listen to combined stream and add transactions to controller
        //var completer = Completer<void>();
        _transfersSubscriptions[config] = snapshot.listen(
          (transactions) {
            // Option to make the list unique!
            if (config.makeUniqueRecipient != null) {
              latestTransfers[config] =
                  getMoneyTransfersWithUniqueSender(transactions);
            } else {
              latestTransfers[config] = transactions;
            }
            if (!completer.isCompleted) {
              completer.complete();
            }
            if (callback != null) callback();
            log.v(
                "Listened to ${transactions.length} transfers with config $config. Max returns were specified with ${config.maxNumberReturns}");
          },
        );
      } catch (e) {
        completer.complete();
        rethrow;
      }
    }
  }

  // pause the listener
  void pauseTransferDataListener({required MoneyTransferQueryConfig config}) {
    log.v("Remove transfer data listener with config: '$config'");
    _transfersSubscriptions[config]?.pause();
  }

  // cancel the listener
  void cancelTransferDataListener({required MoneyTransferQueryConfig config}) {
    log.v("Remove transfer data listener with config: '$config'");
    _transfersSubscriptions[config]?.cancel();
    _transfersSubscriptions[config] = null;
  }

  ///////////////////////////////////////////////
  ///
  /// Helpers

  /// Return list with removed duplicates
  List<MoneyTransfer> getMoneyTransfersWithUniqueSender(
      List<MoneyTransfer> transfer) {
    List<MoneyTransfer> returnTransfers = [];
    transfer.forEach((element) {
      if (!returnTransfers.any((returnElement) =>
          returnElement.transferDetails.recipientId ==
          element.transferDetails.recipientId)) returnTransfers.add(element);
    });
    return returnTransfers;
  }

  //////////////////////////
  /// clean-up
  ///
  void clearData() {
    // cancel all listeners and reset list
    _transfersSubscriptions.forEach((key, value) {
      value?.cancel();
    });
    _transfersSubscriptions.clear();

    log.i("Cleared lists of transfers");
  }
}
