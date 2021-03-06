import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exom/homeFuncs.dart';
import 'package:exom/posts/postPage.dart';
import 'package:exom/widgets/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostWid extends StatefulWidget {
  final doc;

  const PostWid({Key key, this.doc}) : super(key: key);
  @override
  _PostWidState createState() => _PostWidState();
}

class _PostWidState extends State<PostWid> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ExContainer(
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sirenov',
                  style: textTheme.caption,
                ),
                SizedBox(height: 4.0),
                Text(
                  '${widget.doc.data['title']}',
                  style: textTheme.headline6,
                ),
                SizedBox(height: 4.0),
                Text(
                  '${widget.doc.data['description']}',
                  style: textTheme.subtitle1,
                ),
                SizedBox(height: 8.0),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    widget.doc.data['tags'].length,
                    (index) => Chip(
                      label: Text(
                        widget.doc.data['tags'][index],
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 36.0,
                  height: 36.0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 4.0),
                Text(
                  '+123',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    height: 2.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 4.0),
                SizedBox(
                  width: 36.0,
                  height: 36.0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () {},
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 36.0,
                  height: 36.0,
                  child: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          bool isYourPost =
                              widget.doc.data['userId'] == userDoc.documentID;
                          return Container(
                            height: 100,
                            width: double.maxFinite,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: double.maxFinite,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Choose the action',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          )),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => DeleteOrReport(
                                                doc: widget.doc,
                                                typeDelete: isYourPost,
                                              ));
                                    },
                                    child: SizedBox(
                                      height: 50,
                                      width: double.maxFinite,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                              isYourPost
                                                  ? 'Delete'
                                                  : 'Report repitition',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              )),
                                          Spacer(),
                                          Icon(
                                              isYourPost
                                                  ? Icons.delete
                                                  : Icons.warning,
                                              color: isYourPost
                                                  ? Colors.red
                                                  : Colors.orange,
                                              size: 25),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteOrReport extends StatefulWidget {
  final bool typeDelete;
  final DocumentSnapshot doc;
  final update;

  const DeleteOrReport({Key key, this.typeDelete, this.doc, this.update})
      : super(key: key);
  @override
  _DeleteOrReportState createState() => _DeleteOrReportState();
}

class _DeleteOrReportState extends State<DeleteOrReport> {
  send() async {
    if (sent == null) {
      sent = false;
      setState(() {});
      var path = Firestore.instance
          .collection('Posts')
          .document(widget.doc.documentID);
      if (widget.typeDelete) {
        await path.delete();
      } else {
        await path.updateData({
          'repetitionReports': FieldValue.arrayUnion([userDoc.documentID]),
        });
      }
      sent = true;
      setState(() {});
    }
  }

  bool sent;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: sent == null
          ? AlertDialog(
              title: Text(
                widget.typeDelete
                    ? 'Are you sure you want to delete this post?'
                    : 'Are you sure you want to report the repitition?',
              ),
              actions: <Widget>[
                FlatButton(
                  color: Colors.teal,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                      child: Text('No',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ))),
                ),
                FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    send();
                  },
                  child: Center(
                    child: Text('Yes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  ),
                ),
              ],
            )
          : !sent
              ? AlertDialog(
                  title: Text('Processing'),
                  content: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.teal),
                    ),
                  ),
                )
              : AlertDialog(
                  title: Text('Done!'),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.teal,
                      child: Center(
                        child: Text('Ok',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (widget.typeDelete) {
                          posts.remove(widget.doc);
                        }
                      },
                    ),
                  ],
                ),
    );
  }
}
