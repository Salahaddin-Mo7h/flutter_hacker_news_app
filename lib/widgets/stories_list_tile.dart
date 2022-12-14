import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../blocs/stories_provider.dart';
import '../models/item_model.dart';
import 'loading_container.dart';
import 'package:url_launcher/url_launcher.dart';

class StoriesListTile extends StatelessWidget {
  final int itemId;

  StoriesListTile({this.itemId});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            }

            return buildCard(context, itemSnapshot.data);
          },
        );
      }
    );
  }

  /*Widget ListWidget(BuildContext context, ItemModel model){
    return  CoverFlow(itemBuilder: widgetBuilder,
        dismissedCallback: disposeDismissed,
        currentItemChangedCallback: (int index) {
        buildCard(context, model);
    });
  }*/


  Widget buildCard(BuildContext context, ItemModel item) {
    return Card(
      elevation: 12.0,
      margin:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
        decoration: BoxDecoration(color: Color(0xFF163450)),
        child: buildTile(context, item),

      ),
    );
  }


  Widget buildTile(BuildContext context, ItemModel item) {
    final children = <Widget>[];
    
    children.add(const Padding(padding: EdgeInsets.only(top: 8),));
    if (item.descendants == null) {
      children.addAll([
        const Padding(padding: EdgeInsets.only(top: 8),),
        Transform.rotate(
          angle: pi / 2,
          child: const Icon(Icons.link, color: Color(0xFF626EE3))
      )]);
    } else {
      children.addAll([
        Icon(FontAwesome5Solid.comment_alt, color: Color(0xFF626EE3), size: 19.0,),
        Text(
          '${item.descendants}',
          style: TextStyle(
            color: Colors.white, 
            fontFamily: 'Poppins', 
            fontWeight: FontWeight.w600
          )
        )
      ]);
    }

    return ListTile(
      onTap: () async {
        if (item.descendants != null) {
          Navigator.pushNamed(context, '/${item.id}');
        } else {
          var url = item.url;
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        }
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
          border: new Border(
            right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Column(
              children: children,
            ),
      ),
      title: Text(
        item.title,
        style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu', fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: <Widget>[
          Icon(Icons.linear_scale, color: Color(0xFF626EE3)),
          Text((item.descendants == null) ? ' ${item.by}' : ' ${item.score} points', style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu', fontWeight: FontWeight.w400))
        ],
      ),
      trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
    );
  }

}