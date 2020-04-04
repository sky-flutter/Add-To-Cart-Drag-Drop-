import 'package:cart_drag/menuitem.dart';
import 'package:cart_drag/utils/customcolors.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainApp();
  }
}

class MainApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainApp> with TickerProviderStateMixin {
  double initialBottomSheetSize = 0.1;
  bool isSuccessFul = false;
  List<MenuItem> listMenuItem;
  double draggableBottomSheetHeight = 65.0;
  GlobalKey _draggableBottomsheetKey = GlobalKey<_MyAppState>();
  TabController tabController;
  ScrollController draggableScrollController;
  var isExpanded = false;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    createData();
    tabController = TabController(
      length: 3,
      vsync: this,
    );
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        pageController.animateToPage(tabController.index,
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: CustomColors.colorGray,
        appBar: appbar(),
        body: Stack(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Text(
                      "Hi Chris",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Text("Welcome to your McDonal's menu",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ),
                  customTabBar(),
                  tabBarPages()
                ],
              ),
            ),
            checkoutBottomSheet(),
          ],
        ),
      ),
    );
  }

  createData() {
    listMenuItem = new List();
    for (int i = 0; i < 8; i++) {
      var menuItem = MenuItem();
      menuItem.isSuccessful = false;
      listMenuItem.add(menuItem);
    }
  }

  customTabBar() {
    return TabBar(
      isScrollable: true,
      indicatorColor: Colors.red.shade700,
      indicatorWeight: 2,
      unselectedLabelColor: Colors.black54,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.red.shade700,
      tabs: [
        Tab(text: "Burger"),
        Tab(text: "Chicken & Sandwitches"),
        Tab(text: "Combo Meals"),
      ],
      controller: tabController,
    );
  }
  // draggableScrollController.position.setPixels(controller.position.maxScrollExtent);

  checkoutBottomSheet() {
    var draggableBottomSheet = DraggableScrollableSheet(
      key: _draggableBottomsheetKey,
      builder: (context, ScrollController controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.grey)
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          ),
          child: ListView(
            controller: controller,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.black,
                      ),
                      width: 100,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Text(
                            "Checkout Total",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 30,
                          padding: EdgeInsets.only(right: 8),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(24)),
                          child: Text(
                            "Rs. 0",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: <Widget>[
                              DragTarget(
                                builder:
                                    (context, List<String> data, rejectedData) {
                                  return !listMenuItem[index].isSuccessful
                                      ? Container(
                                          height: 100,
                                          width: 100,
                                          margin: EdgeInsets.all(8),
                                          color: Colors.grey.shade100,
                                        )
                                      : Container(
                                          height: 100,
                                          width: 100,
                                          margin: EdgeInsets.all(8),
                                          child: Image(
                                              image: AssetImage(
                                                  "images/burger2.jpeg")),
                                        );
                                },
                                onWillAccept: (data) {
                                  return true;
                                },
                                onAccept: (String data) {
                                  setState(() {
                                    listMenuItem[int.parse(data)].isSuccessful =
                                        true;
                                  });
                                },
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Visibility(
                                  visible: listMenuItem[index].isSuccessful,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        listMenuItem[index].isSuccessful =
                                            false;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 4, top: 4),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                        itemCount: listMenuItem.length,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 8, right: 8),
                      child: RaisedButton(
                        onPressed: () {},
                        textColor: Colors.white,
                        child: Text("Checkout"),
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
      initialChildSize: initialBottomSheetSize,
      minChildSize: initialBottomSheetSize,
      maxChildSize: 0.48,
    );
    return draggableBottomSheet;
  }

  // checkoutBottomSheet1(context){
  //   showModalBottomSheet(context: context, builder: (context){

  //   },)
  // }

  tabBarPages() {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (position) {
          tabController.index = position;
        },
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          return Container(
            child: listOfTabData(),
            margin: EdgeInsets.only(bottom: draggableBottomSheetHeight),
          );
        },
        itemCount: 3,
      ),
    );
  }

  listOfTabData() {
    // List<Container> listItem = List.generate(10, gridItem());
    return GridView.builder(
        itemCount: listMenuItem.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Draggable(
            child: gridItem(),
            feedback: Container(
              height: 100,
              width: 100,
              child: Image(
                image: AssetImage("images/burger2.jpeg"),
              ),
            ),
            data: "$index",
            onDragStarted: () {
              setState(() {
                initialBottomSheetSize = .4;
              });
            },
            onDragEnd: (details) {
              setState(() {
                initialBottomSheetSize = .1;
              });
            },
            onDraggableCanceled: (v, offset) {
              setState(() {
                initialBottomSheetSize = .1;
              });
            },
          );
        });
  }

  gridItem() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("images/burger2.jpeg"),
            height: 70,
          ),
          SizedBox(
            height: 6,
          ),
          Text("Big Mac", style: TextStyle(color: Colors.black, fontSize: 16)),
          SizedBox(
            height: 4,
          ),
          Text("540 Cal.",
              style: TextStyle(color: Colors.black38, fontSize: 12)),
          SizedBox(
            height: 4,
          ),
          Text("From",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 4,
          ),
          Text(
            "Rs. 31.00",
            style: TextStyle(
                color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  appbar() {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: CustomColors.colorGray,
      actionsIconTheme: IconThemeData(color: Colors.black),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        IconButton(icon: Icon(Icons.shopping_basket), onPressed: () {})
      ],
      title: Row(
        children: <Widget>[
          Icon(Icons.menu),
          SizedBox(
            width: 8,
          ),
          Image(
            image: AssetImage(
              "images/mcdonalds.jpg",
            ),
            width: 40,
            height: 40,
          )
        ],
      ),
    );
  }
}
