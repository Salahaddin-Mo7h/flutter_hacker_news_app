import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import 'package:bn_refresh_indicator/bn_refresh_indicator.dart';

class Refresh extends StatelessWidget {
  final Widget child;
  final String listType;

  Refresh({this.child, this.listType});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return BnRefreshIndicator(
      backgroundColor: Color(0xFF001528),
      autoRefresh: false,
      nodataWidget: const Text('there is no data'),
      child: child,
      onRefresh: () async {
        await bloc.clearCache();
        switch(listType) {
          case 'newest': await bloc.fetchNewestIds();
          break;
          case 'best': await bloc.fetchBestIds();
          break;
          case 'top': await bloc.fetchTopIds();
          break;
          case 'job': await bloc.fetchJobIds();
          break;
          case 'question': await bloc.fetchQuestionIds();
          break;
        }
      },
    );
  }
}