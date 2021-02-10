import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zap_architecture_flutter/zap_architecture_flutter.dart';

/// Created by Musa Usman on 04.07.2020
/// Copyright © 2020 Musa Usman. All rights reserved.

class StatusIndicator<T extends StatusMixin> extends StatelessWidget {
  final ContentBuilderCallback<T> builder;
  final LoadingBuilderCallback<T> loadingBuilder;
  final ErrorBuilderCallback<T> errorBuilder;
  final bool isSliver;

  const StatusIndicator(
      {Key key, @required this.builder, this.loadingBuilder, this.errorBuilder})
      : this.isSliver = false,
        super(key: key);

  const StatusIndicator.sliver(
      {Key key, @required this.builder, this.loadingBuilder, this.errorBuilder})
      : this.isSliver = true,
        super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<T>(
        builder: (T bloc) {
          if (bloc.status.loading)
            return _sliverSafe(
              child: loadingBuilder != null
                  ? loadingBuilder(context)
                  : Text("Loading: ${bloc.status.error}"),
            );
          else if (bloc.status.error)
            return _sliverSafe(
              child: errorBuilder != null
                  ? errorBuilder(context, bloc.status.friendlyErrorMessage)
                  : Text("Error: ${bloc.status.error}"),
            );
          else
            return _content(context, bloc);
        },
      );

  dynamic _sliverSafe({@required Widget child}) => isSliver
      ? SliverFillRemaining(
          child: child,
        )
      : child;

  dynamic _content(BuildContext context, T bloc) {
    dynamic content = builder(context, bloc);

    if (content is SliverList)
      return content;
    else
      return _sliverSafe(child: content);
  }
}

typedef Widget ContentBuilderCallback<T extends StatusMixin>(
    BuildContext context, T bloc);

typedef Widget LoadingBuilderCallback<T extends StatusMixin>(
    BuildContext context);

typedef Widget ErrorBuilderCallback<T extends StatusMixin>(
    BuildContext context, String friendlyErrorMessage);
