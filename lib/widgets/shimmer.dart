import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerAnimation extends StatelessWidget {
  const ShimmerAnimation({Key key, this.isChat}) : super(key: key);
  final isChat;

  @override
  Widget build(BuildContext context) {
    return isChat
        ? ListView.builder(
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) =>
                Shimmer.fromColors(
                    baseColor: Theme.of(context).dividerColor,
                    highlightColor: Colors.grey[200],
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Wrap(children: [
                            Container(
                              height: 10,
                              width: 150,
                              color: Colors.white,
                            ),
                          ]),
                          title: Container(
                            height: 10,
                            width: 10,
                            color: Colors.white,
                          ),
                        ))),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    Shimmer.fromColors(
                        baseColor: Theme.of(context).dividerColor,
                        highlightColor: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Container(
                                        width: 100,
                                        height: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                itemCount: 8),
          );
  }
}
