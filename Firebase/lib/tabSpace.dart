import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';

class TabPage extends StatefulWidget {
  
  TabPage(this.observer);
  final FirebaseAnalyticsObserver observer;
  

  @override
  _TabPageState createState() => _TabPageState(observer);
}

class _TabPageState extends State<TabPage>  with SingleTickerProviderStateMixin, RouteAware{
  _TabPageState(this.observer);
  
  final FirebaseAnalyticsObserver observer;
  TabController _controller;
  int seletedIndex = 0;
  
  final List<Tab> tabs = <Tab>[
    
    const Tab(
      text: '1번',
      icon: Icon(Icons.looks_one),
    ),
    
    const Tab(
      text: '2번',
      icon: Icon(Icons.looks_two),
    ),
    
  ];


  @override
  void initState() {
    print('tabSpac의 initState에오ㅓㅁ');
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this,initialIndex: seletedIndex,);

    _controller.addListener(() {
      print('addListener에옴');
      setState(() {
        print('addListener의 setState에옴');
        if(seletedIndex != _controller.index){
          seletedIndex = _controller.index;
          _sendCurrendTab();
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        bottom: TabBar(
          controller: _controller,
          tabs: tabs,
        ),
      ),

      body: TabBarView(
        controller: _controller,
        children: tabs.map((Tab tab){
        return Center(child: Text(tab.text));

        }).toList(), //toList안하니까 에러 오지게터짐
      ),


    );
  }



 //_sendCurrendTab() 함수는 현재화면 이름을 파이어베이스 에넬리틱스에 보낸다, 이로써 사용자가 어떤 화면에 더 많이 접근했는지 알수있다.
  //인덱스는 0부터시작이니 tab/0이면 1버탭 tab/1이면 2ㅂㄴ탭
  void _sendCurrendTab(){
    print('_sendCurrendTab에옴');
    observer.analytics.setCurrentScreen(
        screenName: 'tab/$seletedIndex');
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependcies실행');
    super.didChangeDependencies();
    observer.subscribe(this,ModalRoute.of(context));
  }

  @override
  void dispose() {
    print('dispose실행');
    observer.unsubscribe(this);//구독해지
    super.dispose();
  }
}
