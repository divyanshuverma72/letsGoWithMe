import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LikesWidget extends StatefulWidget {
  const LikesWidget({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.timeStamp,
  });

  final String userName;
  final String userAvatar;
  final int timeStamp;

  @override
  State<LikesWidget> createState() => _LikesWidgetState();
}

class _LikesWidgetState extends State<LikesWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 40.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CircleAvatar(
                  radius: 100.0,
                  backgroundImage:
                  NetworkImage(widget.userAvatar),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 295,
              height: 40,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                              child: Icon(
                                  Icons.access_time, size: 15,)),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat()
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    widget.timeStamp))
                                .toString(),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF525252),
                              fontSize: 10,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
