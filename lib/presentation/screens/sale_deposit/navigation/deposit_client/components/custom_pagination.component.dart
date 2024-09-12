import 'package:flutter/material.dart';

class CustomPaginationList<T> extends StatefulWidget {
  final Future<List<T>> Function(int page, int pageSize) fetchItems;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget? loadingWidget;
  final int pageSize;
  final ScrollController? scrollController;
  final bool Function(ScrollNotification)? onNotification;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const CustomPaginationList({
    Key? key,
    required this.fetchItems,
    required this.itemBuilder,
    this.loadingWidget,
    this.pageSize = 10,
    this.scrollController,
    this.onNotification,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);

  @override
  State<CustomPaginationList<T>> createState() =>
      _CustomPaginationListState<T>();
}

class _CustomPaginationListState<T> extends State<CustomPaginationList<T>> {
  List<T> items = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchMoreItems();
  }

  Future<void> _fetchMoreItems() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newItems = await widget.fetchItems(currentPage, widget.pageSize);
      setState(() {
        items.addAll(newItems);
        currentPage++;
        isLoading = false;
        hasMore = newItems.length == widget.pageSize;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error (e.g., show a snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (widget.onNotification?.call(notification) ?? false) {
          return true;
        }
        if (notification is ScrollEndNotification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            _fetchMoreItems();
            return true;
          }
        }
        return false;
      },
      child: ListView.builder(
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        controller: widget.scrollController,
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index < items.length) {
            return widget.itemBuilder(context, items[index]);
          } else if (isLoading) {
            return widget.loadingWidget ??
                const Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
