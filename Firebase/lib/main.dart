
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'tabSpace.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: <NavigatorObserver>[observer], //앱에서 페이지 이동, 클릭등 사용자의 행동을 관찰하는놈
      home: FirebaseApp(
        analytics:analytics,
        observer:observer,
      ),
    );
  }
}

class FirebaseApp extends StatefulWidget {
  const FirebaseApp({Key key, this.analytics, this.observer}) : super(key: key); //여기서 파라메터 받고
  //파라메터받은건 변수명도 똑같이해야함.. (심지어 넘겨주는곳도!)
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;



  @override
  _FirebaseAppState createState() => _FirebaseAppState(analytics,observer);
}

class _FirebaseAppState extends State<FirebaseApp> {

  _FirebaseAppState(this.analytics,this.observer);
  //한번더 생성자 또쳐적어야한다 ㅎㅎ..
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  String _massage = '';

  void setMessage(String massge){

    setState(() {
      _massage = massge;
    });

  }

  Future<void> _sendAnalyticsEvent() async{

    await analytics.logEvent(
        name: 'test_event',
        parameters : <String,dynamic>{
          'String' : 'hello flutter',
          'int' : 100,
        },
    );
    setMessage('Analytics 보내기 성공');
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Example'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            
            RaisedButton(
              child: Text('테스트'),
              // textColor: Colors.white,
              // color: Colors.deepPurpleAccent,
              onPressed: (){
                print('테스트 버튼클릭 _sendAnalyticsEvent실행');
                _sendAnalyticsEvent();
              },
            ),

            Text(_massage, style: const TextStyle(color: Colors.blueAccent)),
            
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton:
        FloatingActionButton
          (child: const Icon(Icons.tab),
          onPressed: (){
            print('floatingActionButton Click');
            Navigator.of(context).push(MaterialPageRoute<TabPage>(
              settings: RouteSettings(name: '/tab'),
              builder: (BuildContext context){

                return TabPage(observer);
              }
            ));
          },),
    );
        
  }
}
