import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/enums/transfer_dialog_status.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/transfer_dialog_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TransferDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const TransferDialogView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TransferDialogViewModel>.reactive(
      viewModelBuilder: () => TransferDialogViewModel(),
      onModelReady: (model) => model.waitForTransfer(request: request),
      builder: (context, model, child) => Dialog(
        elevation: 0,
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: _BasicDialogContent(
          request: request,
          completer: completer,
          model: model,
        ),
      ),
    );
  }
}

class _BasicDialogContent extends StatelessWidget {
  final dynamic model;
  final DialogRequest request;
  final Function(DialogResponse dialogResponse) completer;

  _BasicDialogContent({
    Key? key,
    required this.request,
    required this.completer,
    required this.model,
  }) : super(key: key);

  final log = getLogger("TransferDialogView");

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: model.isBusy ? 0.0 : 1.0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth(context, percentage: 0.04),
                ),
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 16,
                  right: 16,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    verticalSpaceSmall,
                    Text(model.title ?? '',
                        textAlign: TextAlign.center,
                        style: textTheme(context).headline6),
                    verticalSpaceSmall,
                    Text(model.description ?? '', textAlign: TextAlign.center),
                    verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (model.secondaryButtonTitle != null)
                          TextButton(
                            onPressed: () =>
                                completer(DialogResponse(confirmed: false)),
                            child: Text(
                              model.secondaryButtonTitle!,
                            ),
                          ),
                        Container(
                          width: screenWidth(context, percentage: 0.4),
                          child: InsideOutButton(
                            title: model.mainButtonTitle ?? '',
                            onTap: () =>
                                completer(DialogResponse(confirmed: true)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -28,
                child: CircleAvatar(
                  minRadius: 16,
                  maxRadius: 28,
                  backgroundColor: _getStatusColor(model.status),
                  child: Icon(
                    _getStatusIcon(model.status),
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 50),
              opacity: model.isBusy ? 1.0 : 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: kcPrimaryColor),
                  verticalSpaceMedium,
                  Text("Processing...", style: textTheme(context).headline6),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TransferDialogStatus? status) {
    if (status != null) {
      switch (status) {
        case TransferDialogStatus.error:
          return kcRed;
        case TransferDialogStatus.warning:
          return Colors.amber.shade800;
        default:
          return kcPrimaryColor;
      }
    } else {
      return kcPrimaryColor;
    }
  }

  IconData _getStatusIcon(TransferDialogStatus? status) {
    if (status != null) {
      switch (status) {
        case TransferDialogStatus.error:
          return Icons.close;
        case TransferDialogStatus.warning:
          return Icons.warning_amber;
        default:
          return Icons.check;
      }
    } else {
      return Icons.check;
    }
  }
}
