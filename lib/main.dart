import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:ui';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soundpool/soundpool.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:translator/translator.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tiengviet/tiengviet.dart';

List listCategory = [];

List listType = [];

const String androidAd = 'ca-app-pub-9467993129762242/1735030175';
const String iosAd = 'ca-app-pub-9467993129762242/5200342904';
int showAdFrequency = 10;
int runAppCount = 1;

// const textColor = Color.fromRGBO(3, 64, 24, 1);
const textColor = Colors.black;
const backgroundColor = Color.fromRGBO(147, 219, 172, 1);
// const backgroundColor = Color.fromRGBO(50,128,80, 1);
// const themeColor = Color.fromRGBO(230, 255, 240, 1);
const themeColor = Color.fromRGBO(240, 240, 240, 1);
final Shader linearGradient = const LinearGradient(
  colors: <Color>[Color.fromRGBO(150,173,10,1), Color.fromRGBO(53,61,1,1)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
const colorizeColors = [
  Colors.black,
  Colors.blue,
  Colors.yellow,
  Colors.green,
];

final Soundpool pool = Soundpool.fromOptions();
late int soundId;
late int soundIdRight;
late int soundIdWrong;

int initLanguageIndex = 0;
late SpeechToText stt;
late FlutterTts flutterTts;
final FocusNode searchFocusNode = FocusNode();

late var box;
late var boxSetting;
late var boxScore;
late var boxHistory;
List<String> ieltsList = <String>[];
List<String> toeflList = <String>[];
List<String> toeicList = <String>[];
List<String> essentialList = <String>[];

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  AwesomeNotifications().initialize(
    'resource://drawable/app_icon',
    [
      NotificationChannel(
        channelKey: 'daily',
        channelName: 'daily',
        channelDescription: 'remind to learn',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        soundSource: 'resource://raw/slow_spring_board',
      ),
      NotificationChannel(
        channelKey: 'word',
        channelName: 'word',
        channelDescription: 'learn by notification',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: false,
      )
    ]
  );
  AwesomeNotifications().actionStream.listen((receivedNotification){
    showWord(receivedNotification.title??'');
  });

  final Controller c = Get.put(Controller());
  await Hive.initFlutter();
  boxSetting = await Hive.openBox('setting');
  box = await Hive.openBox('data');
  boxScore = await Hive.openBox('score');
  boxHistory = await Hive.openBox('history');

  String response = await rootBundle.loadString('assets/ielts.json');
  var data = await json.decode(response);
  ieltsList = data.cast<String>();
  response = await rootBundle.loadString('assets/toeic.json');
  data = await json.decode(response);
  toeicList = data.cast<String>();
  response = await rootBundle.loadString('assets/toefl.json');
  data = await json.decode(response);
  toeflList = data.cast<String>();
  response = await rootBundle.loadString('assets/essential.json');
  data = await json.decode(response);
  essentialList = data.cast<String>();
  response = await rootBundle.loadString('assets/allWords.json');
  data = await json.decode(response);
  c.wordArray = RxList(data.cast<String>());
  response = await rootBundle.loadString('assets/category.json');
  listCategory = await json.decode(response);
  response = await rootBundle.loadString('assets/type.json');
  listType = await json.decode(response);

  runAppCount = await boxSetting.get('runAppCount') ?? runAppCount;
  await boxSetting.put('runAppCount',runAppCount+1);
  if (runAppCount<100){
    showAdFrequency = 20 - runAppCount~/10;
  }else{
    showAdFrequency = 10;
  }

  c.notifyDaily = RxBool(await boxSetting.get('notifyDaily') ?? false);
  c.selectedTime = RxString(await boxSetting.get('timeDaily') ?? '20:00');
  c.notifyWord = RxBool(await boxSetting.get('notifyWord') ?? false);
  c.enableSound = RxBool(await boxSetting.get('enableSound') ?? true);
  c.initSpeak = RxBool(await boxSetting.get('initSpeak') ?? true);
  c.word = RxString(await boxSetting.get('word') ?? 'hello');
  c.speakSpeed = RxDouble(await boxSetting.get('speakSpeed') ?? 0.4);
  c.target = RxInt(await boxSetting.get('target') ?? 10);
  c.notificationInterval = RxInt(await boxSetting.get('notificationInterval') ?? 60);
  c.language = RxString(await boxSetting.get('language') ?? (Get.deviceLocale.toString() != 'vi_VN'? 'EN':'VN'));
  c.changeLanguage(c.language.string);
  if (c.language.string == 'VN'){
    initLanguageIndex = 0;
  }else{
    initLanguageIndex = 1;
  }
  bool isIntroduce = await boxSetting.get('isIntroduce') ?? true;

  if (c.notifyWord.value){
    await AwesomeNotifications().dismissNotificationsByChannelKey('word');
    await AwesomeNotifications().cancelSchedulesByChannelKey('word');
    showNotificationWord();
  }

  soundId = await rootBundle.load("assets/tap.mp3").then((ByteData soundData) {
    return pool.load(soundData);
  });
  soundIdRight = await rootBundle.load("assets/right.mp3").then((ByteData soundData) {
    return pool.load(soundData);
  });
  soundIdWrong = await rootBundle.load("assets/wrong.mp3").then((ByteData soundData) {
    return pool.load(soundData);
  });

  runApp(
    GetMaterialApp(
      title: "BeDict",
      home: isIntroduce? const WelcomePage(): MainScreen(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class Controller extends GetxController {

  late StreamSubscription subscription;
  var available = false.obs;
  // List<ProductDetails> products = <ProductDetails>[].obs;
  late Package package;

  @override
  void onInit() async {
    stt = SpeechToText();
    speechEnabled = RxBool(await stt.initialize(
      onError: (err)  {
        Get.snackbar('voice recognize error',err.errorMsg.replaceAll('_', ' '));
      },
      onStatus: (status){
        if (stt.isNotListening){
          isListening = false.obs;
          update();
        }
        if (stt.isListening){
          isListening = true.obs;
          update();
        }
      },
    ));
    flutterTts = FlutterTts();
    if (Platform.isIOS) {
      await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
      ]);
    }
    initPlatformState();
    super.onInit();
  }

  @override
  void onClose() {
    pool.dispose();
    box.close();
    boxScore.close();
    boxHistory.close();
    boxSetting.close();
    // subscription.cancel();
    flutterTts.stop();
    stt.cancel();
    super.onClose();
  }

  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    if (Platform.isAndroid) {
      await Purchases.setup("goog_NiexvvPotedNffCUwntyLAIJWQf");
    } else if (Platform.isIOS) {
      await Purchases.setup("appl_pUnNPLWiWILWJyLBXuVTcpdwHhf");
    }
    final bool _available = await Purchases.isConfigured;
    available = RxBool(_available);
    if (!available.value) {
      return;
    }
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        // Display current offering with offerings.current
        package = offerings.current!.availablePackages[0];
      }
    } on PlatformException catch (_) {
      // optional error handling
    }
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      bool isPro = purchaserInfo.entitlements.all["yearly"]?.isActive?? false;
      isVip = RxBool(isPro);
      if (isPro){
        expire = RxInt(DateTime.parse(purchaserInfo.entitlements.all["yearly"]?.expirationDate??DateTime.now().toString()).millisecondsSinceEpoch);
      }
      update;
    } on PlatformException catch (_) {
      // Error fetching purchaser info
    }
  }

  var bundle = ''.obs;
  var part = 0.obs;

  var nowDuration = 0.obs;
  var fromScreen = 0.obs;
  var translateIn = ''.obs;
  var translateOut = ''.obs;
  var languageIn = 'English'.obs;
  var languageOut = 'Tiếng Việt'.obs;
  var currentPage = 0.obs;
  var currentTab = 0.obs;
  var nowIndex = 0.obs;
  var nowWord = 0.obs;
  var lastHistoryIndex = 0.obs;
  var learnRight = false.obs;
  var right = false.obs;
  var isSearch = false.obs;
  var playing = true.obs;
  var nowMean = 0.obs;
  var expire = 0.obs;
  var indexScorePage = 0.obs;
  var indexHistoryPage = 0.obs;
  List<String> listWordScore = <String>[].obs;
  var startDay = (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch).obs;
  var endDay = (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch+86400000).obs;
  var startDayHistory = (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch).obs;
  var endDayHistory = (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch+86400000).obs;
  var isStartDayOpen = false.obs;
  var isEndDayOpen = false.obs;
  var isStartDayHistory = false.obs;
  var isEndDayHistory = false.obs;
  var notificationInterval = 60.obs;
  var isListening = false.obs;
  var isVip = false.obs;
  var enableSound = true.obs;
  var speechEnabled = false.obs;
  var initSpeak = false.obs;
  var initState = true.obs;
  var language = 'VN'.obs;
  var locale = 'en-US'.obs;
  var listenString = ''.obs;
  List mean = [].obs;
  List meanVN = [].obs;
  List meanEN = [].obs;
  List imageURL = [].obs;
  var word = ''.obs;
  var typeState = 1.obs;
  var pronun = ''.obs;

  var category = 'all category'.obs;

  var type = 'all type'.obs;

  List<String> wordArray = <String>[].obs;

  var wordScore = 0.obs;
  var pronunScore = 0.obs;
  var speakScore = 0.obs;
  var meanScore = 0.obs;

  var duration = 86400000;
  List<History> listHistory = <History> [].obs;
  List<Score> listLearned = <Score> [].obs;
  List<String> listWordScorePage = <String> [].obs;

  var notifyDaily = false.obs;
  var notifyWord = false.obs;
  var selectedTime = '20:00'.obs;
  var target = 10.obs;

  var speakSpeed = 0.4.obs;

  var isAdShowing = false.obs;

  var drawerInitSpeak = 'Tự động phát âm'.obs;
  var drawerEnableSound = 'Âm nền'.obs;
  var drawerHistory = 'Lịch sử tìm kiếm'.obs;
  var drawerScore = 'Thống kê từ đã học'.obs;
  var drawerDaily = 'Nhắc nhở học'.obs;
  var drawerTime = 'Chọn thời điểm'.obs;
  var drawerTarget = 'Mục tiêu (từ/ngày)'.obs;
  var drawerWord = 'Học từ qua thông báo'.obs;
  var drawerSpeech = 'Tốc độ phát âm'.obs;
  var drawerLanguage = 'Ngôn ngữ'.obs;
  var drawerPolicy = 'Chính sách và quyền riêng tư'.obs;
  var drawerContact = 'Liên hệ'.obs;
  var drawerUpgrade = 'Nâng cấp bỏ quảng cáo'.obs;
  var learnTitle = 'Học'.obs;
  var learnWordGuide = 'sắp xếp ký tự để được từ đúng'.obs;
  var learnPronunGuide = 'sắp xếp ký tự để được phát âm đúng'.obs;
  var learnSpeakGuide = 'gõ vào Micro, nói từ chứa '.obs;
  var learnWrongTitle = 'Rất tiếc!'.obs;
  var learnMeanGuide = 'gõ vào ảnh tương ứng với nghĩa'.obs;
  var all = 'Tất cả'.obs;
  var scoreId = 'Từ'.obs;
  var scoreWord = 'Viết'.obs;
  var scorePronun = 'Âm'.obs;
  var scoreSpeak = 'Nói'.obs;
  var scoreMean = 'Nghĩa'.obs;
  var scoreTotal = 'Tổng'.obs;
  var hint = 'tìm kiếm...'.obs;
  var notFound = 'không tìm thấy'.obs;
  var learnedWordsTodayTitle = 'mục tiêu:'.obs;
  var loadingBody = 'Đang tải từ điển, vui lòng đợi trong giây lát'.obs;
  var loadingFailTitle = 'Tải lỗi'.obs;
  var loadingFailBody = 'Đảm bảo có kết nối Internet, vui lòng tải lại sau'.obs;
  var welcomeBody = 'Chào mừng bạn đến với BeDict - từ điển thú vị chờ bạn khám phá'.obs;

  changeLanguage(String newLanguage) async {
    language = RxString(newLanguage);
    if (language.string == 'VN'){
      initLanguageIndex = 0;
      listCategory.sort((a, b) => TiengViet.parse(a[1]).compareTo(TiengViet.parse(b[1])));
      if (category.string != 'all category'){
        for (int i=0;i<listCategory.length;i++){
          if (listCategory[i][0] == bundle.string){
            bundle = RxString(listCategory[i][1]);
            break;
          }
        }
      }
      if (type.string != 'all type'){
        for (int i=0;i<listType.length;i++){
          if (listType[i][0] == bundle.string){
            bundle = RxString(listType[i][1]);
            break;
          }
        }
      }
      await boxSetting.put('language','VN');
      if (bundle.string == 'ESSENTIAL'){
        bundle = 'CƠ BẢN'.obs;
      }
      mean = meanVN;
      typeState = 1.obs;
      drawerInitSpeak = 'Tự động phát âm'.obs;
      drawerEnableSound = 'Âm nền'.obs;
      drawerHistory = 'Lịch sử tìm kiếm'.obs;
      drawerScore = 'Thống kê từ đã học'.obs;
      drawerDaily = 'Nhắc nhở học'.obs;
      drawerTime = 'Chọn thời điểm'.obs;
      drawerTarget = 'Mục tiêu (từ/ngày)'.obs;
      drawerWord = 'Học từ qua thông báo'.obs;
      drawerSpeech = 'Tốc độ phát âm'.obs;
      drawerLanguage = 'Ngôn ngữ'.obs;
      drawerPolicy = 'Chính sách và quyền riêng tư'.obs;
      drawerContact = 'Liên hệ'.obs;
      drawerUpgrade = 'Nâng cấp bỏ quảng cáo'.obs;
      learnTitle = 'Học'.obs;
      learnWordGuide = 'sắp xếp ký tự để được từ đúng'.obs;
      learnPronunGuide = 'sắp xếp ký tự để được phát âm đúng'.obs;
      learnSpeakGuide = 'gõ vào Micro, nói từ chứa '.obs;
      learnWrongTitle = 'Rất tiếc!'.obs;
      learnMeanGuide = 'gõ vào ảnh tương ứng với nghĩa'.obs;
      learnedWordsTodayTitle = 'mục tiêu:'.obs;
      all = 'Tất cả'.obs;
      scoreId = 'Từ'.obs;
      scoreWord = 'Viết'.obs;
      scorePronun = 'Âm'.obs;
      scoreSpeak = 'Nói'.obs;
      scoreMean = 'Nghĩa'.obs;
      scoreTotal = 'Tổng'.obs;
      hint = 'tìm kiếm...'.obs;
      notFound = 'không tìm thấy'.obs;
      loadingBody = 'Đang tải từ điển, vui lòng đợi trong giây lát'.obs;
      loadingFailTitle = 'Tải lỗi'.obs;
      loadingFailBody = 'Đảm bảo có kết nối Internet, vui lòng tải lại sau'.obs;
      welcomeBody = 'Chào mừng bạn đến với BeDict - từ điển thú vị chờ bạn khám phá'.obs;
    }else{
      initLanguageIndex = 1;
      listCategory.sort((a, b) => a[0].compareTo(b[0]));
      if (category.string != 'all category'){
        for (int i=0;i<listCategory.length;i++){
          if (listCategory[i][1] == bundle.string){
            bundle = RxString(listCategory[i][0]);
            break;
          }
        }
      }
      if (type.string != 'all type'){
        for (int i=0;i<listType.length;i++){
          if (listType[i][1] == bundle.string){
            bundle = RxString(listType[i][0]);
            break;
          }
        }
      }
      await boxSetting.put('language','EN');
      if (bundle.string == 'CƠ BẢN'){
        bundle = 'ESSENTIAL'.obs;
      }
      mean = meanEN;
      typeState = 0.obs;
      drawerInitSpeak = 'Automatic speaking'.obs;
      drawerEnableSound = 'Sound'.obs;
      drawerHistory = 'Search history'.obs;
      drawerScore = 'Learned words'.obs;
      drawerDaily = 'Remind to learn'.obs;
      drawerTime = 'Pick time'.obs;
      drawerTarget = 'Target (words/day)'.obs;
      drawerWord = 'Learn throught notification'.obs;
      drawerSpeech = 'Speech speed'.obs;
      drawerLanguage = 'Language'.obs;
      drawerPolicy = 'Terms, conditions and privacy policy'.obs;
      drawerContact = 'Contact'.obs;
      drawerUpgrade = 'Upgrade to remove ads'.obs;
      learnTitle = 'Learn'.obs;
      learnWordGuide = 'arrange characters to make right word'.obs;
      learnPronunGuide = 'arrange characters to make right pronun'.obs;
      learnSpeakGuide = 'tap Micro, say word(s) contains '.obs;
      learnWrongTitle = 'Sorry!'.obs;
      learnMeanGuide = 'tap the image fit following mean'.obs;
      learnedWordsTodayTitle = 'target:'.obs;
      all = 'All'.obs;
      scoreId = 'Word'.obs;
      scoreWord = 'Write'.obs;
      scorePronun = 'Pronun'.obs;
      scoreSpeak = 'Speak'.obs;
      scoreMean = 'Mean'.obs;
      scoreTotal = 'Total'.obs;
      hint = 'search...'.obs;
      notFound = 'not found'.obs;
      loadingBody = 'Loading dictionary data, please wait a moment'.obs;
      loadingFailTitle = 'Fail'.obs;
      loadingFailBody = 'Make sure you have Internet connect, please try again later'.obs;
      welcomeBody = 'Welcome you to BeDict - interesting dictionary is waiting for you to discover'.obs;
    }
    update();
  }
  Future layWord(String newWord) async {
    word = RxString(newWord);
    await boxSetting.put('word',word.string);
    // searchField.text = word.string;
    Score currentScore = await getScore(word.string);
    wordScore = RxInt(currentScore.word);
    pronunScore = RxInt(currentScore.pronun);
    speakScore = RxInt(currentScore.speak);
    meanScore = RxInt(currentScore.mean);
    await insertHistory(word.string);
    var dataRaw = await box.get(word.string);
    if (dataRaw['pronun'] != ''){
      pronun = RxString(dataRaw['pronun'].split('/')[1]);
    }else{
      pronun = ''.obs;
    }
    meanEN.clear();
    meanVN.clear();
    imageURL.clear();
    List listMean = jsonDecode(dataRaw['mean']).toList();
    for(var i = 0; i<listMean.length; i++) {
      if (checkSubMean(listMean[i].cast<String>())){
        List meanENAdd = [];
        List meanVNAdd = [];
        for(var j = 0; j< listMean[i].length; j++) {
          String meanENElement = '';
          if (listMean[i][j].contains('#')){
            meanENElement = listMean[i][j].split('#')[1];
          }else{
            meanENElement = listMean[i][j];
          }
          meanENAdd.add(meanENElement);
          String meanVNElement = jsonDecode(dataRaw['meanVN'])[i][j];
          meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
          meanVNElement = meanVNElement + listMean[i][j].substring(listMean[i][j].length-1);
          meanVNAdd.add(meanVNElement);
        }
        meanEN.add(meanENAdd);
        meanVN.add(meanVNAdd);
        if (i>=jsonDecode(dataRaw['imageURL']).length){
          imageURL.add('bedict.png');
        }else{
          imageURL.add(jsonDecode(dataRaw['imageURL'])[i]);
        }
      }
    }
    nowMean = 0.obs;
    if (language.string == 'VN'){
      mean = meanVN;
    }else{
      mean = meanEN;
    }
    update();
    if (initSpeak.value) _speak(word.string);
  }

}

class Introduce extends StatelessWidget {
  Introduce({Key? key}) : super(key: key);
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    Get.offAll(()=>const LoadingPage());
  }

  Widget _buildImage(String assetName, [double width = 250]) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset('assets/$assetName', width: width)
    );
  }

  @override
  Widget build(context) {
    final Controller c = Get.put(Controller());
    const bodyStyle = TextStyle(fontSize: 19.0, color: textColor);

    PageDecoration pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700, color: textColor),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
      imageFlex:2
    );

    Future.delayed(Duration.zero, () async {

    });

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        pages: [
          PageViewModel(
            title: c.language.string == 'VN'?'Thế giới muôn màu':'This world is colorful',
            body: c.language.string == 'VN'?'BeDict mô tả cuộc sống muôn màu này.'
                :'BeDict depicts this colorful world.',
            image: _buildImage(c.language.string == 'VN'?'img0.jpg':'img0EN.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: c.language.string == 'VN'?'Gói từ':'Word bundles',
            body: c.language.string == 'VN'?'Những gói từ quan trọng nhất, tất cả đều có hình ảnh, miễn phí.'
                :'Most important word bundles, all with images, free.',
            image: _buildImage(c.language.string == 'VN'?'img1.jpg':'img1EN.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: c.language.string == 'VN'?'Chủ đề':'Categories',
            body: c.language.string == 'VN'?'Hàng trăm chủ đề, bao phủ nhiều mặt, nhiều lĩnh vực. '
                'Chia thành các phần nhỏ, tất cả đều có hình ảnh, miễn phí.'
                :'Hundred categories, cover a lot of aspects, fields. '
                'Divided to some small parts, all with images, free.',
            image: _buildImage(c.language.string == 'VN'?'img2.jpg':'img2EN.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: c.language.string == 'VN'?'Tìm kiếm':'Searching',
            body: c.language.string == 'VN'?'Tìm kiếm tất cả từ trong từ điển đều kèm hình ảnh minh hoạ, miễn phí.'
                :'Search all the words in this dictionary with images, free.',
            image: _buildImage(c.language.string == 'VN'?'img3.jpg':'img3EN.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: c.language.string == 'VN'?'Học':'Learn',
            body: c.language.string == 'VN'?'Học dễ dàng với những trò chơi đơn giản, hiệu quả '
                'cùng hệ thống tính điểm cho đến khi bạn nắm vừng từ hoàn toàn.'
                :'Easy to learn by some easy but helpful games with '
                'marking system until you totally remember the word.',
            image: _buildImage('img4.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: c.language.string == 'VN'?'Thông báo':'Notification',
            body: c.language.string == 'VN'?'Xem từ qua thông báo mọi lúc, kể cả khi thiết bị của bạn không mở khoá.'
                :'See words everytime, even when your device do not open.',
            image: _buildImage(c.language.string == 'VN'?'img5.jpg':'img5EN.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: c.language.string == 'VN'?'Dịch':'Translation',
            body: c.language.string == 'VN'?'Dịch Anh-Việt và ngược lại, bất cứ cụm từ nào.'
                :'Translage English-Vietnamese and reverse, any clause.',
            image: _buildImage('img6.jpg'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        //rtl: true, // Display as right-to-left
        skip: GetBuilder<Controller>(
          builder: (_) => Text(
              c.language.string=='VN'?'Bỏ qua':'Skip',
              style: const TextStyle(color:backgroundColor)
          ),
        ),
        next: const Icon(Icons.arrow_forward,color:backgroundColor),
        done: GetBuilder<Controller>(
          builder: (_) => Text(
              c.language.string=='VN'?'Xong':'Done',
              style: const TextStyle(fontWeight: FontWeight.w600,color:backgroundColor)
          ),
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          activeColor: backgroundColor,
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          // color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    final List<Widget> pages = [
      const SearchPage(),
      TranslatePage(),
      const SettingPage(),
    ];

    WidgetsBinding.instance?.addPostFrameCallback((_) async {

    });

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //i like transaparent :-)
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarIconBrightness: Brightness.light, // status bar icons' color
        systemNavigationBarIconBrightness: Brightness.light, //navigation bar icons' color
      ),
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        body: GetBuilder<Controller>(
          builder: (_) => pages.elementAt(c.currentPage.value),
        ),
        bottomNavigationBar: GetBuilder<Controller>(
          builder: (_) => BottomNavigationBar(
            currentIndex: c.currentPage.value,
            onTap: (int index) {
              c.currentPage = RxInt(index);
              c.update();
            },
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            unselectedItemColor: const Color.fromRGBO(235, 235, 235, 1),
            selectedItemColor: textColor,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.search_rounded),
                backgroundColor: backgroundColor,
                label: c.language.string == 'VN'? 'Tìm kiếm':'Search',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.g_translate_outlined),
                backgroundColor: backgroundColor,
                label: c.language.string == 'VN'? 'Dịch':'Translate',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_rounded),
                backgroundColor: backgroundColor,
                label: c.language.string == 'VN'? 'Cài đặt':'Setting',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List listShowIelts = [];
  List listShowToeic = [];
  List listShowToefl = [];
  List listShowEssential = [];
  int ieltsCount = 0;
  int toeicCount = 0;
  int toeflCount = 0;
  int essentialCount = 0;
  bool initial = true;

  Future getList(int count) async {
    List _listShowIelts = [];
    List _listShowToeic = [];
    List _listShowToefl = [];
    List _listShowEssential = [];
    List<int> listIndex = [];
    while (_listShowIelts.length<count){
      int newIndex = Random().nextInt(ieltsList.length);
      if (!listIndex.contains(newIndex)){
        listIndex.add(newIndex);
        var dataRaw = await box.get(ieltsList[newIndex]);
        _listShowIelts.add(dataRaw);
      }
    }
    listIndex = [];
    while (_listShowToeic.length<count){
      int newIndex = Random().nextInt(toeicList.length);
      if (!listIndex.contains(newIndex)){
        listIndex.add(newIndex);
        var dataRaw = await box.get(toeicList[newIndex]);
        _listShowToeic.add(dataRaw);
      }
    }
    listIndex = [];
    while (_listShowToefl.length<count){
      int newIndex = Random().nextInt(toeflList.length);
      if (!listIndex.contains(newIndex)){
        listIndex.add(newIndex);
        var dataRaw = await box.get(toeflList[newIndex]);
        _listShowToefl.add(dataRaw);
      }
    }
    listIndex = [];
    while (_listShowEssential.length<count){
      int newIndex = Random().nextInt(essentialList.length);
      if (!listIndex.contains(newIndex)){
        listIndex.add(newIndex);
        var dataRaw = await box.get(essentialList[newIndex]);
        _listShowEssential.add(dataRaw);
      }
    }
    int _ieltsCount = 0;
    int _toeicCount = 0;
    int _toeflCount = 0;
    int _essentialCount = 0;
    for (var i=0;i<ieltsList.length;i++){
      var nowWord = await boxScore.get(ieltsList[i]);
      if (nowWord[5]>0){
        _ieltsCount++;
      }
    }
    for (var i=0;i<toeicList.length;i++){
      var nowWord = await boxScore.get(toeicList[i]);
      if (nowWord[5]>0){
        _toeicCount++;
      }
    }
    for (var i=0;i<toeflList.length;i++){
      var nowWord = await boxScore.get(toeflList[i]);
      if (nowWord[5]>0){
        _toeflCount++;
      }
    }
    for (var i=0;i<essentialList.length;i++){
      var nowWord = await boxScore.get(essentialList[i]);
      if (nowWord[5]>0){
        _essentialCount++;
      }
    }
    setState((){
      listShowIelts = _listShowIelts;
      listShowToeic = _listShowToeic;
      listShowToefl = _listShowToefl;
      listShowEssential = _listShowEssential;
      ieltsCount = _ieltsCount;
      toeicCount = _toeicCount;
      toeflCount = _toeflCount;
      essentialCount = _essentialCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    final textFieldController = TextEditingController(text:'');
    List<String> suggestArray = [];

    if (initial){
      getList(MediaQuery.of(context).size.width < 500?5:(MediaQuery.of(context).size.width~/220+3));
    }
    initial = false;

    void getToScore(String bundle) {
      if (!c.isAdShowing.value){
        void toScore() {
          c.bundle = RxString(bundle);
          c.part = 0.obs;
          c.isAdShowing = false.obs;
          c.category = 'all category'.obs;
          c.type = 'all type'.obs;
          Get.offAll(()=> const ScorePage());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getToHome(String bundle, String word) {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.fromScreen = 1.obs;
          c.isSearch = false.obs;
          c.isAdShowing = false.obs;
          c.bundle = RxString(bundle);
          c.category = 'all category'.obs;
          c.type = 'all type'.obs;
          await c.layWord(word);
          Get.offAll(()=>Home());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    Future searchToHome(String word) async {
      if (!c.isAdShowing.value){
        Future toScore() async {
          c.nowWord = RxInt(c.wordArray.indexOf(word));
          c.isAdShowing = false.obs;
          c.isSearch = false.obs;
          c.category = 'all category'.obs;
          c.type = 'all type'.obs;
          c.fromScreen = 0.obs;
          await c.layWord(word);
          Get.offAll(()=>Home());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getToCategory() {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          Get.offAll(()=> const CategoryScreen());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getToType() {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          Get.offAll(()=> const TypeScreen());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    return GestureDetector(
      onTap:(){
        if (searchFocusNode.hasFocus){
          searchFocusNode.unfocus();
        }
        if (c.isSearch.value){
          c.isSearch = false.obs;
          c.update();
        }
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children:[
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.3),
                //     spreadRadius: 0,
                //     blurRadius: 10,
                //     offset: const Offset(0, 2),
                //   ),
                // ],
              ),
              child: Column(
                  children:[
                    SizedBox(height: MediaQuery.of(context).padding.top+10),
                    GetBuilder<Controller>(
                      builder: (_) => Visibility(
                        visible: c.isSearch.value,
                        child: Row(
                            children:[
                              const SizedBox(width:15),
                              Expanded(
                                child: TypeAheadField(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    // controller: searchField,
                                    controller: textFieldController,
                                    autofocus: false,
                                    autocorrect: false,
                                    textInputAction: TextInputAction.done,
                                    focusNode: searchFocusNode,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: textColor,
                                    ),
                                    decoration: InputDecoration(
                                      fillColor: backgroundColor.withOpacity(0.5),
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)
                                        ),
                                      ),
                                      // prefixIcon: Icon(Icons.search_outlined,size:15),
                                      hintText: c.hint.string,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(5),
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.close_rounded),
                                        onPressed:(){
                                          textFieldController.text = '';
                                        }
                                      ),
                                      // icon: Icon(Icons.search),
                                      // isCollapsed: true,
                                    ),
                                    onSubmitted: (value) async {
                                      if (suggestArray.isEmpty){
                                        // searchField.text = c.word.string;
                                        if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                                        Get.snackbar(c.learnWrongTitle.string, c.notFound.string);
                                      }else{
                                        await searchToHome(suggestArray[0]);
                                      }
                                    },
                                  ),
                                  suggestionsBoxVerticalOffset: 10,
                                  noItemsFoundBuilder: (BuildContext context) => ListTile(
                                    title: Text(
                                      c.notFound.string,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    suggestArray = [];
                                    if (pattern == ''){
                                      suggestArray = await getLastSearch();
                                    }
                                    for (var i = 0; i < c.wordArray.length; i++){
                                      if (suggestArray.length > 9){
                                        break;
                                      }
                                      if (c.wordArray[i].toString().toLowerCase().startsWith(pattern.toLowerCase())){
                                        if (!suggestArray.contains(c.wordArray[i])){
                                          suggestArray.add(c.wordArray[i]);
                                        }
                                      }
                                    }
                                    return suggestArray;
                                  },
                                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white.withOpacity(1.0),
                                  ),
                                  itemBuilder: (context, suggestion) {
                                    String mean = '';
                                    String image = 'bedict.png';
                                    var dataRaw = box.get(suggestion.toString());
                                    List listMeans = jsonDecode(dataRaw['mean']);
                                    List listMean = listMeans[0];
                                    List meanENAdd = [];
                                    List meanVNAdd = [];
                                    for(var j = 0; j< listMean.length; j++) {
                                      String meanENElement = '';
                                      if(listMean[j].contains('#')){
                                        meanENElement = listMean[j].split('#')[1];
                                      }else{
                                        meanENElement = listMean[j];
                                      }
                                      meanENAdd.add(meanENElement);
                                      String meanVNElement = jsonDecode(dataRaw['meanVN'])[0][j];
                                      meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
                                      meanVNElement = meanVNElement + listMean[j].substring(listMean[j].length-1);
                                      meanVNAdd.add(meanVNElement);
                                    }
                                    String meanEN = '';
                                    String meanVN = '';
                                    for(var j = 0; j< meanENAdd.length; j++) {
                                      if (j==0){
                                        meanVN = meanVN + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }else{
                                        meanVN = meanVN + ' | ' + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + ' | ' + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }
                                    }
                                    if (c.language.string == 'VN'){
                                      mean = meanVN;
                                    }else{
                                      mean = meanEN;
                                    }
                                    if (jsonDecode(dataRaw['imageURL']).length>0){
                                      image = jsonDecode(dataRaw['imageURL'])[0];
                                    }
                                    return Row(
                                        children: [
                                          const SizedBox(width:10),
                                          Expanded(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                  Text(
                                                    suggestion.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 18.0,
                                                      color: textColor,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height:5),
                                                  Text(
                                                    mean,
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: textColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ]
                                            ),
                                          ),
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(8)
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.6),
                                                    spreadRadius: 0,
                                                    blurRadius: 3,
                                                    offset: const Offset(3, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              width: 70,
                                              height: 50,
                                              child: Stack(
                                                  children:[
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: ImageFiltered(
                                                        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                        child: Opacity(
                                                          opacity: 0.8,
                                                          child: Image(
                                                            image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                            fit: BoxFit.cover,
                                                            width: 70,
                                                            height: 50,
                                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                              return const SizedBox();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image(
                                                        image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                        fit: BoxFit.contain,
                                                        width: 70,
                                                        height: 50,
                                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                          return const SizedBox();
                                                        },
                                                      ),
                                                    ),
                                                    listMeans.length>1?
                                                    Positioned(
                                                        right: 4,
                                                        bottom: 4,
                                                        child: Container(
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withOpacity(0.7),
                                                              borderRadius: const BorderRadius.all(
                                                                  Radius.circular(20)
                                                              ),
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                            child: Text(
                                                              '+ ' + (listMeans.length-1).toString(),
                                                              style: const TextStyle(
                                                                fontSize: 9,
                                                              ),
                                                            )
                                                        )
                                                    )
                                                        : const SizedBox(),
                                                  ]
                                              )
                                          ),
                                        ]
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) async {
                                    // searchField.text = suggestion.toString();
                                    await searchToHome(suggestion.toString());
                                  },
                                  animationDuration: Duration.zero,
                                  debounceDuration: Duration.zero,
                                ),
                              ),
                              const SizedBox(width:15),
                            ]
                        ),
                      ),
                    ),
                    GetBuilder<Controller>(
                      builder: (_) => Visibility(
                        visible: !c.isSearch.value,
                        child: Row(
                          children:[
                            const SizedBox(width: 20),
                            OutlinedButton(
                              style: ButtonStyle(
                                // backgroundColor: MaterialStateProperty.all<Color>(backgroundColor.withOpacity(0.2)),
                                // foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(12)
                                ),
                                shape: MaterialStateProperty.all<OutlinedBorder?>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    )
                                ),
                              ),
                              onPressed: () {
                                getToCategory();
                              },
                              child: Text(
                                  c.language.string == 'VN'? 'Chủ đề':'Category',
                                  style: const TextStyle(
                                    color: textColor,
                                  )
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              style: ButtonStyle(
                                // backgroundColor: MaterialStateProperty.all<Color>(backgroundColor.withOpacity(0.2)),
                                // foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(12)
                                ),
                                shape: MaterialStateProperty.all<OutlinedBorder?>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    )
                                ),
                              ),
                              onPressed: () {
                                getToType();
                              },
                              child: Text(
                                  c.language.string == 'VN'? 'Từ loại':'Type',
                                  style: const TextStyle(
                                    color: textColor,
                                  )
                              ),
                            ),
                            const Expanded(child:SizedBox()),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(backgroundColor.withOpacity(0.5)),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10)
                                ),
                                shape: MaterialStateProperty.all<OutlinedBorder?>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )
                                ),
                              ),
                              onPressed: () {
                                c.isSearch = true.obs;
                                c.update();
                                searchFocusNode.requestFocus();
                              },
                              child: const Icon(
                                Icons.search,
                                size: 20,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ]
              ),
            ),
            Expanded(
              child: GetBuilder<Controller>(
                builder: (_) => Visibility(
                  visible: !c.isSearch.value,
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children:[
                      const SizedBox(height: 5),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: 20),
                            CircularPercentIndicator(
                              radius: 20,
                              lineWidth: 3.0,
                              animation: true,
                              percent: essentialCount/essentialList.length,
                              backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
                              progressColor: backgroundColor,
                              // center: Text(
                              //   c.learnedIelts.length.toString(),
                              //   style: const TextStyle(
                              //     fontSize: 9,
                              //     color: textColor,
                              //   ),
                              // ),
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                if (c.language.string == 'VN'){
                                  getToScore('CƠ BẢN');
                                }else{
                                  getToScore('ESSENTIAL');
                                }
                              },
                              child: Text(
                                c.language.string == 'VN'?'CƠ BẢN':'ESSENTIAL',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Expanded(child: SizedBox(),),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                if (c.language.string == 'VN'){
                                  getToScore('CƠ BẢN');
                                }else{
                                  getToScore('ESSENTIAL');
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                          ]
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width > 500? 220*250/300 + 80: (MediaQuery.of(context).size.width-60)*250/300/2 + 80,
                        child: Row(
                          children: [
                            // const SizedBox(width: 10),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: listShowEssential.length + 1,
                                addAutomaticKeepAlives: false,
                                itemBuilder: (BuildContext context, int index) {
                                  late var dataRaw;
                                  String mean = '';
                                  String image = 'bedict.png';
                                  if (index<listShowEssential.length){
                                    dataRaw = listShowEssential[index];
                                    List listMean = jsonDecode(dataRaw['mean'])[0];
                                    List meanENAdd = [];
                                    List meanVNAdd = [];
                                    for(var j = 0; j< listMean.length; j++) {
                                      String meanENElement = '';
                                      if(listMean[j].contains('#')){
                                        meanENElement = listMean[j].split('#')[1];
                                      }else{
                                        meanENElement = listMean[j];
                                      }
                                      meanENAdd.add(meanENElement);
                                      String meanVNElement = jsonDecode(dataRaw['meanVN'])[0][j];
                                      meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
                                      meanVNElement = meanVNElement + listMean[j].substring(listMean[j].length-1);
                                      meanVNAdd.add(meanVNElement);
                                    }
                                    String meanEN = '';
                                    String meanVN = '';
                                    for(var j = 0; j< meanENAdd.length; j++) {
                                      if (j==0){
                                        meanVN = meanVN + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }else{
                                        meanVN = meanVN + ' | ' + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + ' | ' + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }
                                    }
                                    if (c.language.string == 'VN'){
                                      mean = meanVN;
                                    }else{
                                      mean = meanEN;
                                    }
                                    if (jsonDecode(dataRaw['imageURL']).length>0){
                                      image = jsonDecode(dataRaw['imageURL'])[0];
                                    }
                                  }
                                  return index<listShowEssential.length?
                                  GestureDetector(
                                    onTap: () async {
                                      c.part = RxInt(essentialList.indexOf(dataRaw['word'])~/50);
                                      c.listWordScorePage.clear();
                                      for (var j=0;j<(c.part.value<(essentialList.length/50).ceil()-1?50:(essentialList.length-50*c.part.value));j++){
                                        c.listWordScorePage.add(essentialList[c.part.value*50+j]);
                                      }
                                      c.nowWord = RxInt(c.listWordScorePage.indexOf(dataRaw['word']));
                                      if (c.language.string == 'VN'){
                                        getToHome('CƠ BẢN',dataRaw['word']);
                                      }else{
                                        getToHome('ESSENTIAL',dataRaw['word']);
                                      }
                                    },
                                    child: Column(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(8)
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.6),
                                                    spreadRadius: 0,
                                                    blurRadius: 5,
                                                    offset: const Offset(5, 5), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                              height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                              child: Stack(
                                                  children:[
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: ImageFiltered(
                                                        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                        child: Opacity(
                                                          opacity: 0.8,
                                                          child: Image(
                                                            image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                            fit: BoxFit.cover,
                                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                                            height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                              return const SizedBox();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image(
                                                        image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                        fit: BoxFit.contain,
                                                        width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                                        height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                          return const SizedBox();
                                                        },
                                                      ),
                                                    ),
                                                    jsonDecode(dataRaw['meanVN']).length>1?
                                                    Positioned(
                                                        right: 7,
                                                        bottom: 7,
                                                        child: Container(
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withOpacity(0.7),
                                                              borderRadius: const BorderRadius.all(
                                                                  Radius.circular(20)
                                                              ),
                                                            ),
                                                            height: 40,
                                                            width: 40,
                                                            child: Text(
                                                              '+ ' + (jsonDecode(dataRaw['meanVN']).length-1).toString(),
                                                            )
                                                        )
                                                    )
                                                        : const SizedBox(),
                                                  ]
                                              )
                                          ),
                                          const SizedBox(height: 7),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                            child: Text(
                                              dataRaw['word'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                            child: Text(
                                              mean,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ]
                                    ),
                                  )
                                  :GestureDetector(
                                    onTap: () {
                                      if (c.language.string == 'VN'){
                                        getToScore('CƠ BẢN');
                                      }else{
                                        getToScore('ESSENTIAL');
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.all(10),
                                          // decoration: BoxDecoration(
                                          //   color: Colors.white,
                                          //   borderRadius: const BorderRadius.all(
                                          //       Radius.circular(8)
                                          //   ),
                                          //   boxShadow: [
                                          //     BoxShadow(
                                          //       color: Colors.black.withOpacity(0.6),
                                          //       spreadRadius: 0,
                                          //       blurRadius: 5,
                                          //       offset: const Offset(5, 5), // changes position of shadow
                                          //     ),
                                          //   ],
                                          // ),
                                          width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                          height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2+60,
                                          child: const Text(
                                              '+ 2948',
                                              style: TextStyle(
                                                fontSize: 30,
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(width: 20),
                          CircularPercentIndicator(
                            radius: 20,
                            lineWidth: 3.0,
                            animation: true,
                            percent: ieltsCount/ieltsList.length,
                            backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
                            progressColor: backgroundColor,
                            // center: Text(
                            //   c.learnedIelts.length.toString(),
                            //   style: const TextStyle(
                            //     fontSize: 9,
                            //     color: textColor,
                            //   ),
                            // ),
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              getToScore('IELTS');
                            },
                            child: const Text(
                              'IELTS',
                              style: TextStyle(
                                fontSize: 20,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Expanded(child: SizedBox(),),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              getToScore('IELTS');
                            },
                          ),
                          const SizedBox(width: 10),
                        ]
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width > 500? 220*250/300 + 80: (MediaQuery.of(context).size.width-60)*250/300/2 + 80,
                        child: Row(
                          children: [
                            // const SizedBox(width: 10),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: listShowIelts.length + 1,
                                addAutomaticKeepAlives: false,
                                itemBuilder: (BuildContext context, int index) {
                                  late var dataRaw;
                                  String mean = '';
                                  String image = 'bedict.png';
                                  if (index<listShowIelts.length){
                                    dataRaw = listShowIelts[index];
                                    List listMean = jsonDecode(dataRaw['mean'])[0];
                                    List meanENAdd = [];
                                    List meanVNAdd = [];
                                    for(var j = 0; j< listMean.length; j++) {
                                      String meanENElement = '';
                                      if(listMean[j].contains('#')){
                                        meanENElement = listMean[j].split('#')[1];
                                      }else{
                                        meanENElement = listMean[j];
                                      }
                                      meanENAdd.add(meanENElement);
                                      String meanVNElement = jsonDecode(dataRaw['meanVN'])[0][j];
                                      meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
                                      meanVNElement = meanVNElement + listMean[j].substring(listMean[j].length-1);
                                      meanVNAdd.add(meanVNElement);
                                    }
                                    String meanEN = '';
                                    String meanVN = '';
                                    for(var j = 0; j< meanENAdd.length; j++) {
                                      if (j==0){
                                        meanVN = meanVN + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }else{
                                        meanVN = meanVN + ' | ' + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + ' | ' + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }
                                    }
                                    if (c.language.string == 'VN'){
                                      mean = meanVN;
                                    }else{
                                      mean = meanEN;
                                    }
                                    if (jsonDecode(dataRaw['imageURL']).length>0){
                                      image = jsonDecode(dataRaw['imageURL'])[0];
                                    }
                                  }
                                  return index<listShowIelts.length?
                                  GestureDetector(
                                    onTap: () async {
                                      c.part = RxInt(ieltsList.indexOf(dataRaw['word'])~/50);
                                      c.listWordScorePage.clear();
                                      for (var j=0;j<(c.part.value<(ieltsList.length/50).ceil()-1?50:(ieltsList.length-50*c.part.value));j++){
                                        c.listWordScorePage.add(ieltsList[c.part.value*50+j]);
                                      }
                                      c.nowWord = RxInt(c.listWordScorePage.indexOf(dataRaw['word']));
                                      getToHome('IELTS',dataRaw['word']);
                                    },
                                    child: Column(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(8)
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.6),
                                                    spreadRadius: 0,
                                                    blurRadius: 5,
                                                    offset: const Offset(5, 5), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                              height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                              child: Stack(
                                                  children:[
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: ImageFiltered(
                                                        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                        child: Opacity(
                                                          opacity: 0.8,
                                                          child: Image(
                                                            image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                            fit: BoxFit.cover,
                                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                                            height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                              return const SizedBox();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image(
                                                        image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                        fit: BoxFit.contain,
                                                        width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                                        height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                          return const SizedBox();
                                                        },
                                                      ),
                                                    ),
                                                    jsonDecode(dataRaw['meanVN']).length>1?
                                                    Positioned(
                                                        right: 7,
                                                        bottom: 7,
                                                        child: Container(
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withOpacity(0.7),
                                                              borderRadius: const BorderRadius.all(
                                                                  Radius.circular(20)
                                                              ),
                                                            ),
                                                            height: 40,
                                                            width: 40,
                                                            child: Text(
                                                              '+ ' + (jsonDecode(dataRaw['meanVN']).length-1).toString(),
                                                            )
                                                        )
                                                    )
                                                        : const SizedBox(),
                                                  ]
                                              )
                                          ),
                                          const SizedBox(height: 7),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                            child: Text(
                                              dataRaw['word'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                            child: Text(
                                              mean,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ]
                                    ),
                                  )
                                  :GestureDetector(
                                    onTap: () {
                                      getToScore('IELTS');
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.all(10),
                                          // decoration: BoxDecoration(
                                          //   color: Colors.white,
                                          //   borderRadius: const BorderRadius.all(
                                          //       Radius.circular(8)
                                          //   ),
                                          //   boxShadow: [
                                          //     BoxShadow(
                                          //       color: Colors.black.withOpacity(0.6),
                                          //       spreadRadius: 0,
                                          //       blurRadius: 5,
                                          //       offset: const Offset(5, 5), // changes position of shadow
                                          //     ),
                                          //   ],
                                          // ),
                                          width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                          height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2+60,
                                          child: const Text(
                                              '+ 545',
                                              style: TextStyle(
                                                fontSize: 30,
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: 20),
                            CircularPercentIndicator(
                              radius: 20,
                              lineWidth: 3.0,
                              animation: true,
                              percent: toeicCount/toeicList.length,
                              backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
                              progressColor: backgroundColor,
                              // center: Text(
                              //   c.learnedIelts.length.toString(),
                              //   style: const TextStyle(
                              //     fontSize: 9,
                              //     color: textColor,
                              //   ),
                              // ),
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                getToScore('TOEIC');
                              },
                              child: const Text(
                                'TOEIC',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Expanded(child: SizedBox(),),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                getToScore('TOEIC');
                              },
                            ),
                            const SizedBox(width: 10),
                          ]
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width > 500? 220*250/300 + 80: (MediaQuery.of(context).size.width-60)*250/300/2 + 80,
                        child: Row(
                          children: [
                            // const SizedBox(width: 10),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: listShowToeic.length + 1,
                                addAutomaticKeepAlives: false,
                                itemBuilder: (BuildContext context, int index) {
                                  late var dataRaw;
                                  String mean = '';
                                  String image = 'bedict.png';
                                  if (index<listShowToeic.length){
                                    dataRaw = listShowToeic[index];
                                    List listMean = jsonDecode(dataRaw['mean'])[0];
                                    List meanENAdd = [];
                                    List meanVNAdd = [];
                                    for(var j = 0; j< listMean.length; j++) {
                                      String meanENElement = '';
                                      if(listMean[j].contains('#')){
                                        meanENElement = listMean[j].split('#')[1];
                                      }else{
                                        meanENElement = listMean[j];
                                      }
                                      meanENAdd.add(meanENElement);
                                      String meanVNElement = jsonDecode(dataRaw['meanVN'])[0][j];
                                      meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
                                      meanVNElement = meanVNElement + listMean[j].substring(listMean[j].length-1);
                                      meanVNAdd.add(meanVNElement);
                                    }
                                    String meanEN = '';
                                    String meanVN = '';
                                    for(var j = 0; j< meanENAdd.length; j++) {
                                      if (j==0){
                                        meanVN = meanVN + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }else{
                                        meanVN = meanVN + ' | ' + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + ' | ' + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }
                                    }
                                    if (c.language.string == 'VN'){
                                      mean = meanVN;
                                    }else{
                                      mean = meanEN;
                                    }
                                    if (jsonDecode(dataRaw['imageURL']).length>0){
                                      image = jsonDecode(dataRaw['imageURL'])[0];
                                    }
                                  }
                                  return index<listShowToeic.length?
                                  GestureDetector(
                                    onTap: () async {
                                      c.part = RxInt(toeicList.indexOf(dataRaw['word'])~/50);
                                      c.listWordScorePage.clear();
                                      for (var j=0;j<(c.part.value<(toeicList.length/50).ceil()-1?50:(toeicList.length-50*c.part.value));j++){
                                        c.listWordScorePage.add(toeicList[c.part.value*50+j]);
                                      }
                                      c.nowWord = RxInt(c.listWordScorePage.indexOf(dataRaw['word']));
                                      getToHome('TOEIC',dataRaw['word']);
                                    },
                                    child: Column(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(8)
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.6),
                                                    spreadRadius: 0,
                                                    blurRadius: 5,
                                                    offset: const Offset(5, 5), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                              height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                              child: Stack(
                                                  children:[
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: ImageFiltered(
                                                        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                        child: Opacity(
                                                          opacity: 0.8,
                                                          child: Image(
                                                            image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                            fit: BoxFit.cover,
                                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                                            height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                              return const SizedBox();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image(
                                                        image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                        fit: BoxFit.contain,
                                                        width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                                        height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                          return const SizedBox();
                                                        },
                                                      ),
                                                    ),
                                                    jsonDecode(dataRaw['meanVN']).length>1?
                                                    Positioned(
                                                        right: 7,
                                                        bottom: 7,
                                                        child: Container(
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withOpacity(0.7),
                                                              borderRadius: const BorderRadius.all(
                                                                  Radius.circular(20)
                                                              ),
                                                            ),
                                                            height: 40,
                                                            width: 40,
                                                            child: Text(
                                                              '+ ' + (jsonDecode(dataRaw['meanVN']).length-1).toString(),
                                                            )
                                                        )
                                                    )
                                                        : const SizedBox(),
                                                  ]
                                              )
                                          ),
                                          const SizedBox(height: 7),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                            child: Text(
                                              dataRaw['word'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                            child: Text(
                                              mean,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ]
                                    ),
                                  )
                                  :GestureDetector(
                                    onTap: () {
                                      getToScore('TOEIC');
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.all(10),
                                          // decoration: BoxDecoration(
                                          //   color: Colors.white,
                                          //   borderRadius: const BorderRadius.all(
                                          //       Radius.circular(8)
                                          //   ),
                                          //   boxShadow: [
                                          //     BoxShadow(
                                          //       color: Colors.black.withOpacity(0.6),
                                          //       spreadRadius: 0,
                                          //       blurRadius: 5,
                                          //       offset: const Offset(5, 5), // changes position of shadow
                                          //     ),
                                          //   ],
                                          // ),
                                          width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                          height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2+60,
                                          child: const Text(
                                              '+ 1014',
                                              style: TextStyle(
                                                fontSize: 30,
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: 20),
                            CircularPercentIndicator(
                              radius: 20,
                              lineWidth: 3.0,
                              animation: true,
                              percent: toeflCount/toeflList.length,
                              backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
                              progressColor: backgroundColor,
                              // center: Text(
                              //   c.learnedIelts.length.toString(),
                              //   style: const TextStyle(
                              //     fontSize: 9,
                              //     color: textColor,
                              //   ),
                              // ),
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                getToScore('TOEFL');
                              },
                              child: const Text(
                                'TOEFL',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Expanded(child: SizedBox(),),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                getToScore('TOEFL');
                              },
                            ),
                            const SizedBox(width: 10),
                          ]
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width > 500? 220*250/300 + 80: (MediaQuery.of(context).size.width-60)*250/300/2 + 80,
                        child: Row(
                          children: [
                            // const SizedBox(width: 10),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: listShowToefl.length + 1,
                                addAutomaticKeepAlives: false,
                                itemBuilder: (BuildContext context, int index) {
                                  late var dataRaw;
                                  String mean = '';
                                  String image = 'bedict.png';
                                  if (index<listShowToefl.length){
                                    dataRaw = listShowToefl[index];
                                    List listMean = jsonDecode(dataRaw['mean'])[0];
                                    List meanENAdd = [];
                                    List meanVNAdd = [];
                                    for(var j = 0; j< listMean.length; j++) {
                                      String meanENElement = '';
                                      if(listMean[j].contains('#')){
                                        meanENElement = listMean[j].split('#')[1];
                                      }else{
                                        meanENElement = listMean[j];
                                      }
                                      meanENAdd.add(meanENElement);
                                      String meanVNElement = jsonDecode(dataRaw['meanVN'])[0][j];
                                      meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
                                      meanVNElement = meanVNElement + listMean[j].substring(listMean[j].length-1);
                                      meanVNAdd.add(meanVNElement);
                                    }
                                    String meanEN = '';
                                    String meanVN = '';
                                    for(var j = 0; j< meanENAdd.length; j++) {
                                      if (j==0){
                                        meanVN = meanVN + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }else{
                                        meanVN = meanVN + ' | ' + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + ' | ' + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }
                                    }
                                    if (c.language.string == 'VN'){
                                      mean = meanVN;
                                    }else{
                                      mean = meanEN;
                                    }
                                    if (jsonDecode(dataRaw['imageURL']).length>0){
                                      image = jsonDecode(dataRaw['imageURL'])[0];
                                    }
                                  }
                                  return index<listShowToefl.length?
                                  GestureDetector(
                                    onTap: () async {
                                      c.part = RxInt(toeflList.indexOf(dataRaw['word'])~/50);
                                      c.listWordScorePage.clear();
                                      for (var j=0;j<(c.part.value<(toeflList.length/50).ceil()-1?50:(toeflList.length-50*c.part.value));j++){
                                        c.listWordScorePage.add(toeflList[c.part.value*50+j]);
                                      }
                                      c.nowWord = RxInt(c.listWordScorePage.indexOf(dataRaw['word']));
                                      getToHome('TOEFL',dataRaw['word']);
                                    },
                                    child: Column(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(8)
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.6),
                                                    spreadRadius: 0,
                                                    blurRadius: 5,
                                                    offset: const Offset(5, 5), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                              height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                              child: Stack(
                                                  children:[
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: ImageFiltered(
                                                        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                        child: Opacity(
                                                          opacity: 0.8,
                                                          child: Image(
                                                            image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                            fit: BoxFit.cover,
                                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                                            height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                              return const SizedBox();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image(
                                                        image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                        fit: BoxFit.contain,
                                                        width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                                        height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                          return const SizedBox();
                                                        },
                                                      ),
                                                    ),
                                                    jsonDecode(dataRaw['meanVN']).length>1?
                                                    Positioned(
                                                        right: 7,
                                                        bottom: 7,
                                                        child: Container(
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withOpacity(0.7),
                                                              borderRadius: const BorderRadius.all(
                                                                  Radius.circular(20)
                                                              ),
                                                            ),
                                                            height: 40,
                                                            width: 40,
                                                            child: Text(
                                                              '+ ' + (jsonDecode(dataRaw['meanVN']).length-1).toString(),
                                                            )
                                                        )
                                                    )
                                                        : const SizedBox(),
                                                  ]
                                              )
                                          ),
                                          const SizedBox(height: 7),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                            child: Text(
                                              dataRaw['word'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                            child: Text(
                                              mean,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ]
                                    ),
                                  )
                                  :GestureDetector(
                                    onTap: () {
                                      getToScore('TOEFL');
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.all(10),
                                          // decoration: BoxDecoration(
                                          //   color: Colors.white,
                                          //   borderRadius: const BorderRadius.all(
                                          //       Radius.circular(8)
                                          //   ),
                                          //   boxShadow: [
                                          //     BoxShadow(
                                          //       color: Colors.black.withOpacity(0.6),
                                          //       spreadRadius: 0,
                                          //       blurRadius: 5,
                                          //       offset: const Offset(5, 5), // changes position of shadow
                                          //     ),
                                          //   ],
                                          // ),
                                          width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                          height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2+60,
                                          child: const Text(
                                              '+ 365',
                                              style: TextStyle(
                                                fontSize: 30,
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                    ]
                  ),
                ),
              ),
            ),
          ]
        ),
      )
    );
  }
}

class TranslatePage extends StatelessWidget {
  TranslatePage({Key? key}) : super(key: key);
  final inController = TextEditingController();
  final FocusNode inFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    Future translation() async {
      if (inFocusNode.hasFocus){
        inFocusNode.unfocus();
      }
      if (inController.value.text != ''){
        if (c.languageIn.string == 'English'){
          var translation = await inController.value.text.translate(from:'en',to:'vi');
          c.translateOut = RxString(translation.text);
        }else{
          var translation = await inController.value.text.translate(from:'vi',to:'en');
          c.translateOut = RxString(translation.text);
        }
      }else{
        c.translateOut = ''.obs;
      }
      c.update();
    }

    void onSpeechResult(SpeechRecognitionResult result) async {
      inController.text = result.recognizedWords;
      if (result.finalResult){
        await translation();
      }
    }

    Future startListening(String locale) async {
      await stt.listen(
        onResult: onSpeechResult,
        localeId: locale,
        // partialResults: false,
      );
    }

    void stopListening() async {
      await stt.stop();
    }

    return GestureDetector(
      onTap: () {
        if (inFocusNode.hasFocus){
          inFocusNode.unfocus();
        }
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children:[
            SizedBox(height: MediaQuery.of(context).padding.top+10),
            Row(
              children: [
                Expanded(
                  child: GetBuilder<Controller>(
                    builder: (_) => Text(
                      c.languageIn.string,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.compare_arrows_rounded),
                  onPressed: (){
                    String newLanguage = c.languageIn.string;
                    c.languageIn = RxString(c.languageOut.string);
                    c.languageOut = RxString(newLanguage);
                    c.update();
                  },
                ),
                Expanded(
                  child: GetBuilder<Controller>(
                    builder: (_) => Text(
                      c.languageOut.string,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ]
            ),
            Row(
              children:[
                const SizedBox(width:10),
                Expanded(
                  child: TextFormField(
                    controller: inController,
                    textInputAction: TextInputAction.done,
                    focusNode: inFocusNode,
                    autocorrect: false,
                    maxLines: null,
                    minLines: null,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: c.language.string == 'VN'? 'Nhập văn bản ...':'Type here ...',
                      isDense: true,
                      contentPadding: const EdgeInsets.all(5),
                    ),
                    // onChanged: (text) async {
                    //   await translation();
                    // },
                    // onSubmitted: (text) async {
                    //   await translation();
                    // },
                    onFieldSubmitted: (string) async {
                      await translation();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: (){
                    inController.text = '';
                    c.translateOut = ''.obs;
                    c.update();
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(backgroundColor.withOpacity(0.5)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(0)
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder?>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )
                    ),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded,color:textColor),
                  onPressed: () async {
                    await translation();
                  },
                ),
                const SizedBox(width:10),
              ]
            ),
            const SizedBox(height: 20),
            Row(
              children:[
                GetBuilder<Controller>(
                  builder: (_) => IconButton(
                    icon: Icon(
                      c.speechEnabled.value?
                      c.isListening.value? Icons.mic
                          : Icons.mic_none : Icons.mic_off,
                      size: 35,
                    ),
                    onPressed: () {
                      if (stt.isNotListening){
                        if (c.languageIn.string == 'English'){
                          startListening(c.locale.string);
                        }else{
                          startListening('vi-VN');
                        }
                      }else{
                        stopListening();
                      }
                    },
                ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.volume_up_outlined,
                    size: 35,
                  ),
                  onPressed: () {
                    if (c.languageIn.string == 'English'){
                      _speak(inController.value.text);
                    }else{
                      _speak(c.translateOut.string);
                    }
                  },
                ),
                const Expanded(child:SizedBox()),
              ]
            ),
            Row(
              children:[
                const SizedBox(width:10),
                Expanded(
                  child: Container(
                    color: backgroundColor.withOpacity(0.5),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Flexible(
                          child: GetBuilder<Controller>(
                            builder: (_) => Text(
                              c.translateOut.string,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ]
                    )
                  ),
                ),
                const SizedBox(width:10),
              ]
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: c.isVip.value? const SizedBox():
                SingleChildScrollView(
                  child: SizedBox(
                    height: (MediaQuery.of(context).size.width - 20)*250/300,
                    width: MediaQuery.of(context).size.width - 20,
                    child: BannerAdWidget(
                      adWidth: MediaQuery.of(context).size.width - 20,
                      adHeight: (MediaQuery.of(context).size.width - 20)*250/300,
                    ),
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    Future<void> showTime() async {
      final TimeOfDay? result =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (result != null) {
        c.selectedTime = RxString(result.format(context));
        c.update();
        showNotification();
        await boxSetting.put('timeDaily',c.selectedTime.string);
      }
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) async {

    });

    return Container(
      color: Colors.white,
      child: Column(
        children:[
          SizedBox(height: MediaQuery.of(context).padding.top+10),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  title: GetBuilder<Controller>(
                    builder: (_) => Text(
                      c.isVip.value? 'VIP' : c.drawerUpgrade.string,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    Get.offAll(()=>const MyUpgradePage());
                  },
                ),
                const Divider(height:1),
                ListTile(
                  title: GetBuilder<Controller>(
                    builder: (_) => Text(
                      c.drawerHistory.string,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),),
                  onTap: () {
                    Get.offAll(()=>const HistoryPage());
                  },
                ),
                const Divider(height:1,),
                ListTile(
                  title: GetBuilder<Controller>(
                    builder: (_) => Text(
                      c.drawerScore.string,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),),
                  onTap: () {
                    Get.offAll(()=> const SortPage());
                  },
                ),
                const Divider(height:1,),
                const SizedBox(height:5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<Controller>(
                      builder: (_) => Text(
                        c.drawerDaily.string,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GetBuilder<Controller>(
                      builder: (_) => Switch(
                        value: c.notifyDaily.value,
                        onChanged: (value) async {
                          c.notifyDaily = RxBool(value);
                          c.update();
                          await boxSetting.put('notifyDaily',value);
                          if (value) {
                            showNotification();
                          }else{
                            await AwesomeNotifications().dismiss(0);
                            await AwesomeNotifications().cancelSchedule(0);
                          }
                        },
                        activeTrackColor: themeColor,
                        activeColor: backgroundColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:5),
                GetBuilder<Controller>(
                  builder: (_) => Visibility(
                      visible: c.notifyDaily.value,
                      child: Column(
                          children:[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text(
                                  c.drawerTime.string,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 10,),
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(themeColor),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(0)
                                    ),
                                  ),
                                  child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GetBuilder<Controller>(
                                          builder: (_) => Text(
                                            c.selectedTime.string,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ]
                                  ),
                                  onPressed: () async {
                                    await showTime();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            // GetBuilder<Controller>(
                            //   builder: (_) => Text(
                            //     c.drawerTarget.string,
                            //     style: const TextStyle(
                            //       color: textColor,
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w400,
                            //     ),
                            //     textAlign: TextAlign.center,
                            //   ),),
                            // GetBuilder<Controller>(
                            //   builder: (_) => Slider(
                            //     value: c.target.value.toDouble(),
                            //     min: 5,
                            //     max: 50,
                            //     divisions: 9,
                            //     activeColor: backgroundColor,
                            //     inactiveColor: themeColor,
                            //     thumbColor: backgroundColor,
                            //     label: c.target.value.toString(),
                            //     onChanged: (double value) async {
                            //       c.target = RxInt(value.toInt());
                            //       await boxSetting.put('target',value.toInt());
                            //       c.update();
                            //     },
                            //   ),
                            // ),
                          ]
                      )
                  ),
                ),
                const Divider(height:1),
                const SizedBox(height:5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<Controller>(
                      builder: (_) => Text(
                        c.drawerWord.string,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GetBuilder<Controller>(
                      builder: (_) => Switch(
                        value: c.notifyWord.value,
                        onChanged: (value) async {
                          c.notifyWord = RxBool(value);
                          c.update();
                          await boxSetting.put('notifyWord',value);
                          if (value) {
                            showNotificationWord();
                          }else{
                            await AwesomeNotifications().dismissNotificationsByChannelKey('word');
                            await AwesomeNotifications().cancelSchedulesByChannelKey('word');
                          }
                        },
                        activeTrackColor: themeColor,
                        activeColor: backgroundColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:5),
                GetBuilder<Controller>(
                  builder: (_) => Visibility(
                      visible: c.notifyWord.value,
                      child: Column(
                          children:[
                            GetBuilder<Controller>(
                              builder: (_) => Text(
                                c.language.string == 'VN'?
                                'Thông báo sau mỗi (phút):':
                                'Notify interval (minutes)',
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GetBuilder<Controller>(
                              builder: (_) => Slider(
                                value: c.notificationInterval.value.toDouble(),
                                min: 15,
                                max: 120,
                                divisions: 7,
                                activeColor: backgroundColor,
                                inactiveColor: themeColor,
                                thumbColor: backgroundColor,
                                label: c.notificationInterval.value.toString()
                                    + (c.language.string == 'VN'? ' phút':' minutes'),
                                onChanged: (double value) async {
                                  c.notificationInterval = RxInt(value.toInt());
                                  await boxSetting.put('notificationInterval',value.toInt());
                                  c.update();
                                  await AwesomeNotifications().dismissNotificationsByChannelKey('word');
                                  await AwesomeNotifications().cancelSchedulesByChannelKey('word');
                                  showNotificationWord();
                                },
                              ),
                            ),
                          ]
                      )
                  ),
                ),
                const Divider(height:1,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15,),
                    GetBuilder<Controller>(
                      builder: (_) => Text(
                        c.drawerSpeech.string,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),),
                    GetBuilder<Controller>(
                      builder: (_) => Slider(
                        value: c.speakSpeed.value,
                        min: 0.1,
                        max: 1,
                        divisions: 9,
                        activeColor: backgroundColor,
                        inactiveColor: themeColor,
                        thumbColor: backgroundColor,
                        label: double.parse((c.speakSpeed.value).toStringAsFixed(1)).toString(),
                        onChanged: (double value) async {
                          c.speakSpeed = RxDouble(value);
                          await boxSetting.put('speakSpeed',value);
                          c.update();
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(height:1,),
                const SizedBox(height:5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<Controller>(
                      builder: (_) => Text(
                        c.drawerInitSpeak.string,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),),
                    const SizedBox(width:10),
                    GetBuilder<Controller>(
                      builder: (_) => Switch(
                        activeColor: backgroundColor,
                        activeTrackColor: themeColor,
                        value: c.initSpeak.value,
                        onChanged: (value) async {
                          c.initSpeak = value.obs;
                          c.update();
                          await boxSetting.put('initSpeak',value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:5),
                const Divider(height:1,),
                const SizedBox(height:5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<Controller>(
                      builder: (_) => Text(
                        c.drawerEnableSound.string,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),),
                    const SizedBox(width:10),
                    GetBuilder<Controller>(
                      builder: (_) => Switch(
                        activeColor: backgroundColor,
                        activeTrackColor: themeColor,
                        value: c.enableSound.value,
                        onChanged: (value) async {
                          c.enableSound = value.obs;
                          c.update();
                          await boxSetting.put('enableSound',value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:5),
                const Divider(height:1,),
                const SizedBox(height:15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<Controller>(
                      builder: (_) =>  Text(
                        c.drawerLanguage.string,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),),
                    const SizedBox(width:10),
                    ToggleSwitch(
                      minWidth: 50.0,
                      minHeight: 30.0,
                      fontSize: 14.0,
                      initialLabelIndex: initLanguageIndex,
                      activeBgColor: const [backgroundColor],
                      activeFgColor: Colors.white,
                      inactiveBgColor: const Color.fromRGBO(240, 240, 240, 1),
                      inactiveFgColor: textColor,
                      totalSwitches: 2,
                      changeOnTap: true,
                      labels: const ['VN', 'EN'],
                      onToggle: (index) async {
                        if (index == 0){
                          c.changeLanguage('VN');
                        }else{
                          c.changeLanguage('EN');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height:15),
                const Divider(height:1),
                ListTile(
                  title: GetBuilder<Controller>(
                    builder: (_) =>  Text(
                      c.language.string == 'VN'? 'Tải lại dữ liệu':'Reload data',
                      style: const TextStyle(
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),),
                  onTap: () {
                    Get.offAll(()=>const LoadingPage());
                  },
                ),
                const Divider(height:1),
                ListTile(
                  title: GetBuilder<Controller>(
                    builder: (_) =>  Text(
                      c.drawerPolicy.string,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),),
                  onTap: () {
                    Get.to(()=>const PolicyPage());
                  },
                ),
                const Divider(height:1),
                ListTile(
                  title: GetBuilder<Controller>(
                    builder: (_) =>  Text(
                      c.language.string == 'VN'? 'Điều khoản sử dụng':'Terms of Use',
                      style: const TextStyle(
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),),
                  onTap: () {
                    Get.to(()=>const TermPage());
                  },
                ),
                const Divider(height:1),
                ListTile(
                  title: GetBuilder<Controller>(
                    builder: (_) =>  Text(
                      c.drawerContact.string,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),),
                  onTap: () {
                    Get.offAll(()=>const ContactPage());
                  },
                ),
                // const Divider(height:1),
              ],
            ),
          ),
        ]
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    void getToScore(int i) {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.isAdShowing = false.obs;
          c.bundle = RxString(listCategory[i][c.typeState.value]);
          c.listWordScore = RxList(await getListCategory(listCategory[i][0]));
          c.category = RxString(listCategory[i][0]);
          c.type = 'all type'.obs;
          c.part = 0.obs;
          Get.offAll(()=> const ScorePage());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getToMainScreen() {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.isAdShowing = false.obs;
          Get.offAll(()=> MainScreen());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(()=>MainScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            c.language.string == 'VN'?'Chủ đề':'Category',
            style: TextStyle(
              fontSize: 18,
              color: textColor.withOpacity(0.7),
            ),
            overflow: TextOverflow.ellipsis,
            // textAlign: TextAlign.left,
          ),
          leading: IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: Icon(
              Icons.arrow_back_ios_rounded, size: 20,
              color: textColor.withOpacity(0.7),
            ),
            tooltip: 'Back to MainScreen',
            onPressed: () {
              getToMainScreen();
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body: Container(
          color: Colors.white,
          // padding: EdgeInsets.all(10),
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width~/120,
            addAutomaticKeepAlives: false,
            childAspectRatio: 4/3,
            // mainAxisSpacing: 10,
            // crossAxisSpacing: 10,
            children: List.generate(listCategory.length, (i) {
              String url = '';
              switch (listCategory[i][0]){
                case 'heraldry':
                  url = 'assets/temp/armory2.png';
                  break;
                case 'no category':
                  url = 'assets/temp/no.png';
                  break;
                case 'past participle':
                  url = 'assets/temp/no.png';
                  break;
                case 'internet':
                  url = 'assets/temp/Internet1.png';
                  break;
                case 'bell-ringing':
                  url = 'assets/temp/bob7.png';
                  break;
                default:
                  url = 'assets/temp/' + listCategory[i][0] + '1.png';
              }
              return GestureDetector(
                onTap: () {
                  getToScore(i);
                },
                child: Stack(
                  children:[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: const Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          url,
                          fit: BoxFit.cover,
                          // width: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width-100:400,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                    Column(
                      children:[
                        const Expanded(child:SizedBox()),
                        Container(
                          height: 25,
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: Row(
                            children:[
                              const SizedBox(width:5),
                              Expanded(
                                child: Text(
                                  listCategory[i][c.typeState.value],
                                  // textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width:5),
                            ]
                          ),
                        ),
                      ]
                    ),
                  ]
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class TypeScreen extends StatelessWidget {
  const TypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    void getToScore(int i) {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.isAdShowing = false.obs;
          c.bundle = RxString(listType[i][c.typeState.value]);
          c.listWordScore = RxList(await getListType(listType[i][0]));
          c.category = 'all category'.obs;
          c.type = RxString(listType[i][0]);
          c.part = 0.obs;
          Get.offAll(()=> const ScorePage());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getToMainScreen() {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.isAdShowing = false.obs;
          Get.offAll(()=> MainScreen());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(()=>MainScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            c.language.string == 'VN'?'Từ loại':'Type',
            style: TextStyle(
              fontSize: 18,
              color: textColor.withOpacity(0.7),
            ),
            overflow: TextOverflow.ellipsis,
            // textAlign: TextAlign.left,
          ),
          leading: IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: Icon(
              Icons.arrow_back_ios_rounded, size: 20,
              color: textColor.withOpacity(0.7),
            ),
            tooltip: 'Back to MainScreen',
            onPressed: () {
              getToMainScreen();
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body: Container(
          color: Colors.white,
          height: double.infinity,
          alignment: Alignment.center,
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width~/180,
            addAutomaticKeepAlives: false,
            shrinkWrap: true,
            childAspectRatio: 5/2,
            // mainAxisSpacing: 10,
            // crossAxisSpacing: 10,
            children: List.generate(listType.length, (i) {
              return GestureDetector(
                onTap: () {
                  getToScore(i);
                },
                child: Container(
                  // width: (MediaQuery.of(context).size.width-50)/3,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                        150+Random().nextInt(55),
                        201+Random().nextInt(55),
                        150+Random().nextInt(55),
                        1
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(20)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(8),
                  child: Text(
                    listType[i][c.typeState.value],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      // shadows: <Shadow>[
                      //   Shadow(
                      //     offset: Offset(0.0, 0.0),
                      //     blurRadius: 3.0,
                      //     color: Colors.black,
                      //   ),
                      // ],
                    ),
                    textAlign: TextAlign.center,
                    // overflow: TextOverflow.ellipsis,
                  )
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final GlobalKey<ProcessWidgetState> processKey = GlobalKey<ProcessWidgetState>();

  final ScreenshotController screenshotController = ScreenshotController();

  // final FocusNode searchFocusNodeHome = FocusNode();

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    final textFieldController = TextEditingController(text:'');
    List<String> suggestArray = [];

    Future searchToHome(String word) async {
      if (!c.isAdShowing.value){
        Future toScore() async {
          c.nowWord = RxInt(c.wordArray.indexOf(word));
          c.isAdShowing = false.obs;
          c.isSearch = false.obs;
          c.category = 'all category'.obs;
          c.type = 'all type'.obs;
          c.fromScreen = 0.obs;
          await c.layWord(word);
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getBack() {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          switch (c.fromScreen.value){
            case 0:
              Get.offAll(()=> MainScreen());
              break;
            default:
              Get.offAll(()=> const ScorePage());
          }
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getToLearn() {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          c.currentTab = 0.obs;
          Get.offAll(()=>const LearnWord());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getNext() {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.isAdShowing = false.obs;
          if (c.fromScreen.value ==0){
            if (c.nowWord.value<(c.wordArray.length-1)){
              c.nowWord = RxInt(c.nowWord.value+1);
            }else{
              c.nowWord = 0.obs;
            }
            await c.layWord(c.wordArray[c.nowWord.value]);
          }else{
            if (c.nowWord.value<(c.listWordScorePage.length-1)){
              c.nowWord = RxInt(c.nowWord.value+1);
            }else{
              c.nowWord = 0.obs;
            }
            await c.layWord(c.listWordScorePage[c.nowWord.value]);
          }
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getPrevious() {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.isAdShowing = false.obs;
          if (c.fromScreen.value == 0){
            if (c.nowWord.value>0){
              c.nowWord = RxInt(c.nowWord.value-1);
            }else{
              c.nowWord = RxInt(c.wordArray.length-1);
            }
            await c.layWord(c.wordArray[c.nowWord.value]);
          }else{
            if (c.nowWord.value>0){
              c.nowWord = RxInt(c.nowWord.value-1);
            }else{
              c.nowWord = RxInt(c.listWordScorePage.length-1);
            }
            await c.layWord(c.listWordScorePage[c.nowWord.value]);
          }
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getRandom() {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.isAdShowing = false.obs;
          if (c.fromScreen.value == 0){
            c.nowWord = RxInt(Random().nextInt(c.wordArray.length));
            await c.layWord(c.wordArray[c.nowWord.value]);
          }else{
            c.nowWord = RxInt(Random().nextInt(c.listWordScorePage.length));
            await c.layWord(c.listWordScorePage[c.nowWord.value]);
          }
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getNextMean() {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          if (c.nowMean.value<(c.mean.length-1)){
            c.nowMean = RxInt(c.nowMean.value+1);
            c.update();
          }else{
            c.nowMean = 0.obs;
            c.update();
          }
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getPreviousMean() {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          if (c.nowMean.value>0){
            c.nowMean = RxInt(c.nowMean.value-1);
            c.update();
          }else{
            c.nowMean = RxInt(c.imageURL.length-1);
            c.update();
          }
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    Future waitSpeak(int i) async {
      int duration = 0;
      int wordCount = 0;
      for (var j=0;j<i;j++){
        wordCount += c.mean[c.nowMean.value][j].split(' ').length as int;
      }
      duration += (i+1)*1000 + wordCount*50~/c.speakSpeed.value;
      await Future.delayed(Duration(milliseconds: duration));
    }

    return WillPopScope(
      onWillPop: () async {
        getBack();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, //i like transaparent :-)
            systemNavigationBarColor: Colors.transparent, // navigation bar color
            statusBarIconBrightness: Brightness.light, // status bar icons' color
            systemNavigationBarIconBrightness: Brightness.light, //navigation bar icons' color
          ),
          child: Screenshot(
            controller: screenshotController,
            child: Stack(
              children: [
                GetBuilder<Controller>(
                  builder: (_) => c.imageURL.isNotEmpty?
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Opacity(
                        opacity: 0.8,
                        child: Image(
                          image: NetworkImage('https://bedict.com/' + c.imageURL[c.nowMean.value].replaceAll('\\','')),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(),
                ),
                GetBuilder<Controller>(
                  builder: (_) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(child: child, scale: animation);
                    },
                    child: Container(
                      key: ValueKey<String>(c.nowMean.value.toString()),
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child:c.imageURL.isNotEmpty?
                      SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(20)
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: const Offset(5, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              image: NetworkImage('https://bedict.com/' + c.imageURL[c.nowMean.value].replaceAll('\\','')),
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width-100:400,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                      )
                          :const SizedBox(),
                    ),
                  ),
                ),
                Column (
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:<Widget> [
                    SizedBox(height: MediaQuery.of(context).padding.top + 5),
                    GetBuilder<Controller>(
                      builder: (_) => Visibility(
                        visible: !c.isSearch.value,
                        child: Row(
                            children:[
                              IconButton(
                                padding: const EdgeInsets.all(0.0),
                                icon: const Icon(Icons.arrow_back_ios_rounded, size: 20,),
                                tooltip: 'Back',
                                onPressed: () {
                                  getBack();
                                },
                              ),
                              Expanded(
                                child: Text(
                                  c.fromScreen.value == 0?'':
                                  (c.language.string == 'VN'?'phần ':'part ')
                                      + (c.part.value+1).toString() + ' - '
                                      + c.bundle.string.toLowerCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search, size: 25,),
                                onPressed: () {
                                  c.isSearch = true.obs;
                                  c.update();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share, size: 25,),
                                onPressed: () async {
                                  double pixelRatio = MediaQuery.of(context).devicePixelRatio;
                                  await screenshotController.capture(
                                      delay: const Duration(milliseconds: 10),
                                      pixelRatio: pixelRatio
                                  ).then((image) async {
                                    if (image != null) {
                                      final directory = await getApplicationDocumentsDirectory();
                                      final imagePath = await File('${directory.path}/image.png').create();
                                      await imagePath.writeAsBytes(image);
                                      await Share.shareFiles([imagePath.path]);
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width:20),
                              OutlinedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.transparent
                                  ),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(0)
                                  ),
                                  shape: MaterialStateProperty.all<OutlinedBorder?>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      )
                                  ),
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      const Size.fromHeight(40)
                                  ),
                                ),
                                onPressed: () {
                                  getToLearn();
                                },
                                child: GetBuilder<Controller>(
                                  builder: (_) => Text(
                                    c.language.string == 'VN'? 'Học':'Learn',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(width:15),
                            ]
                        ),
                      ),
                    ),
                    GetBuilder<Controller>(
                      builder: (_) => Visibility(
                        visible: c.isSearch.value,
                        child: Row(
                            children:[
                              const SizedBox(width:15),
                              Expanded(
                                child: TypeAheadField(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    controller: textFieldController,
                                    autofocus: true,
                                    autocorrect: false,
                                    textInputAction: TextInputAction.done,
                                    // focusNode: searchFocusNodeHome,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: textColor,
                                    ),
                                    decoration: InputDecoration(
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(width:1,color:Colors.black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(width:1,color:Colors.black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(width:1,color:Colors.black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)
                                        ),
                                      ),
                                      // prefixIcon: Icon(Icons.search_outlined,size:15),
                                      hintText: c.hint.string,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(5),
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: IconButton(
                                          icon: const Icon(Icons.close_rounded),
                                          onPressed:(){
                                            textFieldController.text = '';
                                          }
                                      ),
                                      // icon: Icon(Icons.search),
                                      // isCollapsed: true,
                                    ),
                                    onSubmitted: (value) async {
                                      if (suggestArray.isEmpty){
                                        // searchField.text = c.word.string;
                                        if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                                        Get.snackbar(c.learnWrongTitle.string, c.notFound.string);
                                      }else{
                                        await searchToHome(suggestArray[0]);
                                      }
                                    },
                                  ),
                                  suggestionsBoxVerticalOffset: 10,
                                  noItemsFoundBuilder: (BuildContext context) => ListTile(
                                    title: Text(
                                      c.notFound.string,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    suggestArray = [];
                                    if (pattern == ''){
                                      suggestArray = await getLastSearch();
                                    }
                                    for (var i = 0; i < c.wordArray.length; i++){
                                      if (suggestArray.length > 9){
                                        break;
                                      }
                                      if (c.wordArray[i].toString().toLowerCase().startsWith(pattern.toLowerCase())){
                                        if (!suggestArray.contains(c.wordArray[i])){
                                          suggestArray.add(c.wordArray[i]);
                                        }
                                      }
                                    }
                                    return suggestArray;
                                  },
                                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white.withOpacity(1.0),
                                  ),
                                  itemBuilder: (context, suggestion) {
                                    String mean = '';
                                    String image = 'bedict.png';
                                    var dataRaw = box.get(suggestion.toString());
                                    List listMeans = jsonDecode(dataRaw['mean']);
                                    List listMean = listMeans[0];
                                    List meanENAdd = [];
                                    List meanVNAdd = [];
                                    for(var j = 0; j< listMean.length; j++) {
                                      String meanENElement = '';
                                      if(listMean[j].contains('#')){
                                        meanENElement = listMean[j].split('#')[1];
                                      }else{
                                        meanENElement = listMean[j];
                                      }
                                      meanENAdd.add(meanENElement);
                                      String meanVNElement = jsonDecode(dataRaw['meanVN'])[0][j];
                                      meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
                                      meanVNElement = meanVNElement + listMean[j].substring(listMean[j].length-1);
                                      meanVNAdd.add(meanVNElement);
                                    }
                                    String meanEN = '';
                                    String meanVN = '';
                                    for(var j = 0; j< meanENAdd.length; j++) {
                                      if (j==0){
                                        meanVN = meanVN + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }else{
                                        meanVN = meanVN + ' | ' + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                                        meanEN = meanEN + ' | ' + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                                      }
                                    }
                                    if (c.language.string == 'VN'){
                                      mean = meanVN;
                                    }else{
                                      mean = meanEN;
                                    }
                                    if (jsonDecode(dataRaw['imageURL']).length>0){
                                      image = jsonDecode(dataRaw['imageURL'])[0];
                                    }
                                    return Row(
                                        children: [
                                          const SizedBox(width:10),
                                          Expanded(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                  Text(
                                                    suggestion.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 18.0,
                                                      color: textColor,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height:5),
                                                  Text(
                                                    mean,
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: textColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ]
                                            ),
                                          ),
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(8)
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.6),
                                                    spreadRadius: 0,
                                                    blurRadius: 3,
                                                    offset: const Offset(3, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              width: 70,
                                              height: 50,
                                              child: Stack(
                                                  children:[
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: ImageFiltered(
                                                        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                        child: Opacity(
                                                          opacity: 0.8,
                                                          child: Image(
                                                            image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                            fit: BoxFit.cover,
                                                            width: 70,
                                                            height: 50,
                                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                              return const SizedBox();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image(
                                                        image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                        fit: BoxFit.contain,
                                                        width: 70,
                                                        height: 50,
                                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                          return const SizedBox();
                                                        },
                                                      ),
                                                    ),
                                                    listMeans.length>1?
                                                    Positioned(
                                                        right: 4,
                                                        bottom: 4,
                                                        child: Container(
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withOpacity(0.7),
                                                              borderRadius: const BorderRadius.all(
                                                                  Radius.circular(20)
                                                              ),
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                            child: Text(
                                                              '+ ' + (listMeans.length-1).toString(),
                                                              style: const TextStyle(
                                                                fontSize: 9,
                                                              ),
                                                            )
                                                        )
                                                    )
                                                        : const SizedBox(),
                                                  ]
                                              )
                                          ),
                                        ]
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) async {
                                    // searchField.text = suggestion.toString();
                                    await searchToHome(suggestion.toString());
                                  },
                                  animationDuration: Duration.zero,
                                  debounceDuration: Duration.zero,
                                ),
                              ),
                              const SizedBox(width:15),
                            ]
                        ),
                      ),
                    ),
                    const SizedBox(height:20),
                    Expanded(
                      child: GestureDetector(
                        onVerticalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
                            getPrevious();
                          }
                          if (details.primaryVelocity! < -0) {
                            getNext();
                          }
                        },
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
                            getPreviousMean();
                          }
                          if (details.primaryVelocity! < 0) {
                            getNextMean();
                          }
                        },
                        onDoubleTap: () {
                          getToLearn();
                        },
                        onTap:() async {
                          if (searchFocusNode.hasFocus){
                            searchFocusNode.unfocus();
                          }
                          if (c.isSearch.value){
                            c.isSearch = false.obs;
                            c.update();
                          }
                          if (processKey.currentState!.controller.isAnimating){
                            processKey.currentState!.controller.stop();
                          }else{
                            processKey.currentState!.controller.forward();
                          }
                        },
                        child: Column(
                            children:[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GetBuilder<Controller>(
                                    builder: (_) => Flexible(
                                      child: AnimatedTextKit(
                                        key: ValueKey<String> (c.word.string),
                                        animatedTexts: [
                                          ColorizeAnimatedText(
                                            c.word.string,
                                            textAlign: TextAlign.center,
                                            speed: const Duration(milliseconds: 300),
                                            textStyle: TextStyle(
                                              fontSize: 50,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w600,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 15,
                                                  color: Colors.black.withOpacity(0.5),
                                                  offset: const Offset(3, 3),
                                                ),
                                              ],
                                            ),
                                            colors: colorizeColors,
                                          ),
                                          ColorizeAnimatedText(
                                            c.pronun.string,
                                            textAlign: TextAlign.center,
                                            speed: const Duration(milliseconds: 300),
                                            textStyle: TextStyle(
                                              fontSize: 50,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w600,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 15,
                                                  color: Colors.black.withOpacity(0.5),
                                                  offset: const Offset(3, 3),
                                                ),
                                              ],
                                            ),
                                            colors: colorizeColors,
                                          ),
                                        ],
                                        isRepeatingAnimation: true,
                                        repeatForever: true,
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(color: Colors.transparent),
                              ),
                              GetBuilder<Controller>(
                                builder: (_) => Row(
                                    children:[
                                      const SizedBox(width:10),
                                      c.mean.isNotEmpty?
                                      Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: c.mean[c.nowMean.value].asMap().entries.map<Widget>((subMean) =>
                                                FutureBuilder(
                                                  // future: Future.delayed(Duration(milliseconds: (subMean.key+1)*1000)),
                                                  future: waitSpeak(subMean.key),
                                                  builder: (context, snapshot) {
                                                    Widget child;

                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      child = const SizedBox();
                                                    } else {
                                                      child = Container(
                                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white.withOpacity(0.3),
                                                          borderRadius: const BorderRadius.all(
                                                              Radius.circular(10)
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const SizedBox(height: 3,),
                                                            Opacity(
                                                              opacity: 0.3,
                                                              child: Text(
                                                                laytuloai(subMean.value.substring(subMean.value.length - 1))[c.typeState.value],
                                                                style: const TextStyle(
                                                                  fontSize: 11,
                                                                  color: textColor,
                                                                ),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 2),
                                                            Text(
                                                              subMean.value.substring(0,subMean.value.length-1),
                                                              style: const TextStyle(
                                                                fontSize: 18,
                                                                color: textColor,
                                                              ),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            const SizedBox(height: 3),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                    return AnimatedSwitcher(
                                                      duration: const Duration(milliseconds: 500),
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                            ).toList(),
                                          )
                                      )
                                          : const SizedBox(),
                                      const SizedBox(width:10),
                                    ]
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                    const SizedBox(height:5),
                    GetBuilder<Controller>(
                      builder: (_) => c.mean.length>1?
                      DotsIndicator(
                          dotsCount: c.mean.length,
                          position: c.nowMean.value.toDouble(),
                          axis: Axis.horizontal,
                          decorator: DotsDecorator(
                            size: const Size.square(9.0),
                            activeSize: const Size(14.0, 9.0),
                            activeColor: Colors.black.withOpacity(0.4),
                            color: Colors.black.withOpacity(0.1),
                            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                            spacing: 19*c.mean.length>MediaQuery.of(context).size.width - 20 ?
                            EdgeInsets.fromLTRB(
                                ((MediaQuery.of(context).size.width-20)/c.mean.length-9)/2,
                                10,
                                ((MediaQuery.of(context).size.width-20)/c.mean.length-9)/2,
                                10
                            )
                                : const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          ),
                          onTap: (index){
                            c.nowMean = RxInt(index.toInt());
                            c.update();
                          }
                      )
                          : const SizedBox(),
                    ),
                    const SizedBox(height:5),
                    GetBuilder<Controller>(
                      builder: (_) => c.mean.isNotEmpty?
                      ProcessWidget(
                        meanLength:c.mean[c.nowMean.value].length,
                        key: processKey,
                      )
                          :const SizedBox(),
                    ),
                    Row(
                        children:[
                          const SizedBox(width:10),
                          ToggleSwitch(
                            minWidth: 35.0,
                            minHeight: 22.0,
                            fontSize: 9.0,
                            initialLabelIndex: initLanguageIndex,
                            activeBgColor: const [backgroundColor],
                            activeFgColor: Colors.white,
                            inactiveBgColor: const Color.fromRGBO(240, 240, 240, 1),
                            inactiveFgColor: textColor,
                            totalSwitches: 2,
                            changeOnTap: true,
                            labels: const ['VN', 'EN'],
                            onToggle: (index) async {
                              if (index == 0){
                                c.changeLanguage('VN');
                              }else{
                                c.changeLanguage('EN');
                              }
                            },
                          ),
                          const SizedBox(width:10),
                          GetBuilder<Controller>(
                            builder: (_) => Text(
                              c.language.string == 'VN'?'nói':'speak',
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          GetBuilder<Controller>(
                            builder: (_) => Switch(
                              activeColor: backgroundColor,
                              activeTrackColor: themeColor,
                              value: c.initSpeak.value,
                              onChanged: (value) async {
                                c.initSpeak = value.obs;
                                c.update();
                                await boxSetting.put('initSpeak',value);
                              },
                            ),
                          ),
                          const SizedBox(width:10),
                          GetBuilder<Controller>(
                            builder: (_) => Text(
                              c.language.string == 'VN'?'tốc độ':'speed',
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: GetBuilder<Controller>(
                              builder: (_) => Slider(
                                value: c.speakSpeed.value,
                                min: 0.1,
                                max: 1,
                                divisions: 9,
                                activeColor: backgroundColor,
                                inactiveColor: themeColor,
                                thumbColor: backgroundColor,
                                label: double.parse((c.speakSpeed.value).toStringAsFixed(1)).toString(),
                                onChanged: (double value) async {
                                  c.speakSpeed = RxDouble(value);
                                  await boxSetting.put('speakSpeed',value);
                                  c.update();
                                },
                              ),
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
                Container(
                  alignment:Alignment.centerRight,
                  child: Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              const Expanded(child: SizedBox()),
                              IconButton(
                                padding: const EdgeInsets.all(0.0),
                                icon: Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  size: 25,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                tooltip: 'next',
                                onPressed: () {
                                  getNext();
                                },
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(0.0),
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  size: 25,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                tooltip: 'random',
                                onPressed: () {
                                  getRandom();
                                },
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(0.0),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 25,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                tooltip: 'previous',
                                onPressed: () {
                                  getPrevious();
                                },
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(0.0),
                                icon: Icon(
                                  Icons.volume_up_outlined,
                                  size: 25,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                tooltip: 'speak',
                                onPressed: () {
                                  _speak(c.word.string);
                                },
                              ),
                              const Expanded(child: SizedBox()),
                            ]
                        ),
                        const Expanded(child: SizedBox()),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              const Expanded(child: SizedBox()),
                              RotatedBox(
                                quarterTurns: -1,
                                child: GetBuilder<Controller>(
                                  builder: (_) => LinearPercentIndicator(
                                    alignment: MainAxisAlignment.center,
                                    width: MediaQuery.of(context).size.height*0.2,
                                    lineHeight: 5.0,
                                    percent: (c.wordScore.value+c.pronunScore.value+c.speakScore.value+c.meanScore.value)/100,
                                    backgroundColor: Colors.black.withOpacity(0.1),
                                    progressColor: Colors.black.withOpacity(0.4),
                                    padding: const EdgeInsets.all(0),
                                    animation: true,
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                            ]
                        ),
                        const SizedBox(width:7),
                      ]
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class ProcessWidget extends StatefulWidget {
  // const ProcessWidget({Key? key}) : super(key: key);

  final int meanLength;

  const ProcessWidget({Key? key,
    required this.meanLength
  }) : super(key: key);

  @override

  State<ProcessWidget> createState() => ProcessWidgetState();
}

class ProcessWidgetState extends State<ProcessWidget> with TickerProviderStateMixin {

  final Controller c = Get.put(Controller());
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      // duration: Duration(seconds: 4+widget.meanLength),
    )..addListener(() {
      if (controller.isCompleted){
        if (c.nowMean.value<(c.mean.length-1)){
          c.nowMean = RxInt(c.nowMean.value+1);
        }else{
          c.nowMean = 0.obs;
        }
        c.update();
      }
      setState(() {});
    });
    // controller.repeat(reverse: false);
    int wordCount = 0;
    for (var j=0;j<c.mean[c.nowMean.value].length;j++){
      wordCount += c.mean[c.nowMean.value][j].split(' ').length as int;
    }
    int duration = 0;
    duration += 3000 + (c.mean[c.nowMean.value].length as int)*1000 + wordCount*50~/c.speakSpeed.value;
    controller.duration = Duration(milliseconds: duration);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProcessWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (Get.currentRoute == '/Home' || Get.currentRoute == '/'){
    //   controller = AnimationController(
    //     vsync: this,
    //     duration: Duration(seconds: 4+widget.meanLength),
    //   )..addListener(() async {
    //     if (controller.isCompleted){
    //       if (c.nowMean.value<(c.mean.length-1)){
    //         c.nowMean = RxInt(c.nowMean.value+1);
    //       }else{
    //         c.nowMean = 0.obs;
    //       }
    //       c.update();
    //     }
    //     setState(() {});
    //   });
    //   controller.forward();
    // }
    int wordCount = 0;
    for (var j=0;j<c.mean[c.nowMean.value].length;j++){
      wordCount += c.mean[c.nowMean.value][j].split(' ').length as int;
    }
    int duration = 0;
    duration += 3000 + (c.mean[c.nowMean.value].length as int)*1000 + wordCount*50~/c.speakSpeed.value;
    controller.duration = Duration(milliseconds: duration);
    controller.reset();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: controller.value,
      backgroundColor: Colors.black.withOpacity(0.1),
      color: Colors.black.withOpacity(0.3),
      semanticsLabel: 'Linear progress indicator',
    );
  }
}

class WriteWidget extends StatefulWidget {
  const WriteWidget({Key? key}) : super(key: key);

  @override
  State<WriteWidget> createState() => _WriteWidgetState();
}

class _WriteWidgetState extends State<WriteWidget> {
  final Controller c = Get.put(Controller());
  List<String> listArrange = [];
  List<String> listRandom = [];

  @override
  void initState() {
    reset();
    super.initState();
  }

  void reset() {
    List<String> newRandom = c.word.string.split('').obs;
    newRandom.shuffle();
    setState((){
      listArrange = [for (int i=0; i<c.word.string.split('').length; i++)''];
      listRandom = newRandom;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(height:10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int index=0; index<c.mean.length; index++)
                    Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(8)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(5, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                        height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                        child: Stack(
                            children:[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Image(
                                      image: NetworkImage('https://bedict.com/' + c.imageURL[index].replaceAll('\\','')),
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                      height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image(
                                  image: NetworkImage('https://bedict.com/' + c.imageURL[index].replaceAll('\\','')),
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                  height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ]
                        )
                    ),
                ]
            ),
          ),
          const SizedBox(height:10),
          GetBuilder<Controller>(
            builder: (_) => LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              width: MediaQuery.of(context).size.width - 20,
              lineHeight: 3,
              percent: c.wordScore.value/25,
              backgroundColor: Colors.black.withOpacity(0.1),
              progressColor: Colors.black.withOpacity(0.3),
              padding: const EdgeInsets.all(0),
              animation: true,
            ),
          ),
          Expanded(
            child: Row(
                children:[
                  const SizedBox(width:20),
                  Expanded(
                    child: Column(
                        children:[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: GetBuilder<Controller>(
                                  builder: (_) => Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      runAlignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        for (int i=0; i<listArrange.length; i++)
                                          GestureDetector(
                                            onTap: () async {
                                              if (listArrange[i] != ''){
                                                if (c.enableSound.value){
                                                  pool.play(soundId);
                                                }
                                                setState((){
                                                  listRandom[listRandom.indexOf('')] = listArrange[i];
                                                  listArrange[i] = '';
                                                });
                                              }
                                            },
                                            child: Neumorphic(
                                              style: listArrange[i] == ''?
                                              NeumorphicStyle(
                                                shape: NeumorphicShape.flat,
                                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                                depth: -5,
                                                lightSource: LightSource.topLeft,
                                                color: Colors.transparent,
                                                intensity: 1,
                                              ):
                                              NeumorphicStyle(
                                                shape: NeumorphicShape.concave,
                                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                                depth: 2,
                                                lightSource: LightSource.bottomRight,
                                                color: Colors.white.withOpacity(0.3),
                                                intensity: 0.4,
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 45,
                                                width: 45,
                                                child: Text(
                                                  listArrange[i],
                                                  style: const TextStyle(
                                                    fontSize: 27,
                                                    color: textColor, //customize color here
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      ]
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: GetBuilder<Controller>(
                                  builder: (_) => Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      runAlignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        for (int i=0; i<listRandom.length; i++)
                                          GestureDetector(
                                            onTap: () async {
                                              if (listRandom[i] != ''){
                                                if (c.enableSound.value){
                                                  pool.play(soundId);
                                                }
                                                setState((){
                                                  listArrange[listArrange.indexOf('')] = listRandom[i];
                                                  listRandom[i] = '';
                                                });
                                                if (!listArrange.contains('')){
                                                  if (listEquals(listArrange,c.word.string.split(''))){
                                                    if (c.wordScore.value<25){
                                                      c.wordScore = RxInt(c.wordScore.value + 1);
                                                      c.update();
                                                      var newScore = Score(
                                                        wordId: c.word.value,
                                                        word: c.wordScore.value,
                                                        pronun: c.pronunScore.value,
                                                        speak: c.speakScore.value,
                                                        mean: c.meanScore.value,
                                                        total: c.wordScore.value + c.pronunScore.value + c.speakScore.value + c.meanScore.value,
                                                        time: DateTime.now().millisecondsSinceEpoch,
                                                      );
                                                      await updateScore(newScore);
                                                    }
                                                    await setRight();
                                                    getNextLearn();
                                                  }else{
                                                    if (c.wordScore.value>0){
                                                      c.wordScore = RxInt(c.wordScore.value - 1);
                                                      c.update();
                                                      var newScore = Score(
                                                        wordId: c.word.value,
                                                        word: c.wordScore.value,
                                                        pronun: c.pronunScore.value,
                                                        speak: c.speakScore.value,
                                                        mean: c.meanScore.value,
                                                        total: c.wordScore.value + c.pronunScore.value + c.speakScore.value + c.meanScore.value,
                                                        time: DateTime.now().millisecondsSinceEpoch,
                                                      );
                                                      await updateScore(newScore);
                                                    }
                                                    await setWrong();
                                                  }
                                                }
                                              }
                                            },
                                            child: Neumorphic(
                                              style: listRandom[i] == ''?
                                              NeumorphicStyle(
                                                shape: NeumorphicShape.flat,
                                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                                depth: -5,
                                                lightSource: LightSource.topLeft,
                                                color: Colors.transparent,
                                                intensity: 1,
                                              ):
                                              NeumorphicStyle(
                                                shape: NeumorphicShape.concave,
                                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                                depth: 2,
                                                lightSource: LightSource.bottomRight,
                                                color: Colors.white.withOpacity(0.3),
                                                intensity: 0.4,
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 45,
                                                width: 45,
                                                child: Text(
                                                  listRandom[i],
                                                  style: const TextStyle(
                                                    fontSize: 27,
                                                    color: textColor, //customize color here
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      ]
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  const SizedBox(width:5),
                ]
            ),
          ),
          const Divider(height:2,thickness:2),
          const SizedBox(height:5),
          Row(
              children:[
                const SizedBox(width:10),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0)
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder?>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(40)
                    ),
                  ),
                  onPressed: () async {
                    reset();
                  },
                  child: GetBuilder<Controller>(
                    builder: (_) => Text(
                      c.language.string == 'VN'? 'Đặt lại':'Reset',
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width:10),
                const Expanded(child: SizedBox()),
                GetBuilder<Controller>(
                  builder: (_) => Text(
                    c.drawerEnableSound.string,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),),
                const SizedBox(width:10),
                GetBuilder<Controller>(
                  builder: (_) => Switch(
                    activeColor: backgroundColor,
                    activeTrackColor: themeColor,
                    value: c.enableSound.value,
                    onChanged: (value) async {
                      c.enableSound = value.obs;
                      c.update();
                      await boxSetting.put('enableSound',value);
                    },
                  ),
                ),
                const SizedBox(width:10),
              ]
          ),
          const SizedBox(height:5),
        ],
      ),
    );
  }
}

class PronunWidget extends StatefulWidget {
  const PronunWidget({Key? key}) : super(key: key);

  @override
  State<PronunWidget> createState() => _PronunWidgetState();
}

class _PronunWidgetState extends State<PronunWidget> {
  final Controller c = Get.put(Controller());
  List<String> listArrange = [];
  List<String> listRandom = [];

  @override
  void initState() {
    reset();
    super.initState();
  }

  void reset() {
    List<String> newRandom = c.pronun.string.split('').obs;
    newRandom.shuffle();
    setState((){
      listArrange = [for (int i=0; i<c.pronun.string.split('').length; i++)''];
      listRandom = newRandom;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(height:10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int index=0; index<c.mean.length; index++)
                    Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(8)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(5, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                        height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                        child: Stack(
                            children:[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Image(
                                      image: NetworkImage('https://bedict.com/' + c.imageURL[index].replaceAll('\\','')),
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                      height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image(
                                  image: NetworkImage('https://bedict.com/' + c.imageURL[index].replaceAll('\\','')),
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width > 500? 220: (MediaQuery.of(context).size.width-60)/2,
                                  height: MediaQuery.of(context).size.width > 500? 220*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ]
                        )
                    ),
                ]
            ),
          ),
          const SizedBox(height:10),
          GetBuilder<Controller>(
            builder: (_) => LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              width: MediaQuery.of(context).size.width - 20,
              lineHeight: 3,
              percent: c.pronunScore.value/25,
              backgroundColor: Colors.black.withOpacity(0.1),
              progressColor: Colors.black.withOpacity(0.3),
              padding: const EdgeInsets.all(0),
              animation: true,
            ),
          ),
          Expanded(
            child: Row(
                children:[
                  const SizedBox(width:20),
                  Expanded(
                    child: Column(
                        children:[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: GetBuilder<Controller>(
                                  builder: (_) => Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      runAlignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        for (int i=0; i<listArrange.length; i++)
                                          GestureDetector(
                                            onTap: () async {
                                              if (listArrange[i] != ''){
                                                if (c.enableSound.value){
                                                  pool.play(soundId);
                                                }
                                                setState((){
                                                  listRandom[listRandom.indexOf('')] = listArrange[i];
                                                  listArrange[i] = '';
                                                });
                                              }
                                            },
                                            child: Neumorphic(
                                              style: listArrange[i] == ''?
                                              NeumorphicStyle(
                                                shape: NeumorphicShape.flat,
                                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                                depth: -5,
                                                lightSource: LightSource.topLeft,
                                                color: Colors.transparent,
                                                intensity: 1,
                                              ):
                                              NeumorphicStyle(
                                                shape: NeumorphicShape.concave,
                                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                                depth: 2,
                                                lightSource: LightSource.bottomRight,
                                                color: Colors.white.withOpacity(0.3),
                                                intensity: 0.4,
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 45,
                                                width: 45,
                                                child: Text(
                                                  listArrange[i],
                                                  style: const TextStyle(
                                                    fontSize: 27,
                                                    color: textColor, //customize color here
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      ]
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: GetBuilder<Controller>(
                                  builder: (_) => Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      runAlignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        for (int i=0; i<listRandom.length; i++)
                                          GestureDetector(
                                            onTap: () async {
                                              if (listRandom[i] != ''){
                                                if (c.enableSound.value){
                                                  pool.play(soundId);
                                                }
                                                setState((){
                                                  listArrange[listArrange.indexOf('')] = listRandom[i];
                                                  listRandom[i] = '';
                                                });
                                                if (!listArrange.contains('')){
                                                  if (listEquals(listArrange,c.pronun.string.split(''))){
                                                    if (c.pronunScore.value<25){
                                                      c.pronunScore = RxInt(c.pronunScore.value + 1);
                                                      c.update();
                                                      var newScore = Score(
                                                        wordId: c.word.value,
                                                        word: c.wordScore.value,
                                                        pronun: c.pronunScore.value,
                                                        speak: c.speakScore.value,
                                                        mean: c.meanScore.value,
                                                        total: c.wordScore.value + c.pronunScore.value + c.speakScore.value + c.meanScore.value,
                                                        time: DateTime.now().millisecondsSinceEpoch,
                                                      );
                                                      await updateScore(newScore);
                                                    }
                                                    await setRight();
                                                    getNextLearn();
                                                  }else{
                                                    if (c.pronunScore.value>0){
                                                      c.pronunScore = RxInt(c.pronunScore.value - 1);
                                                      c.update();
                                                      var newScore = Score(
                                                        wordId: c.word.value,
                                                        word: c.wordScore.value,
                                                        pronun: c.pronunScore.value,
                                                        speak: c.speakScore.value,
                                                        mean: c.meanScore.value,
                                                        total: c.wordScore.value + c.pronunScore.value + c.speakScore.value + c.meanScore.value,
                                                        time: DateTime.now().millisecondsSinceEpoch,
                                                      );
                                                      await updateScore(newScore);
                                                    }
                                                    await setWrong();
                                                  }
                                                }
                                              }
                                            },
                                            child: Neumorphic(
                                              style: listRandom[i] == ''?
                                              NeumorphicStyle(
                                                shape: NeumorphicShape.flat,
                                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                                depth: -5,
                                                lightSource: LightSource.topLeft,
                                                color: Colors.transparent,
                                                intensity: 1,
                                              ):
                                              NeumorphicStyle(
                                                shape: NeumorphicShape.concave,
                                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                                depth: 2,
                                                lightSource: LightSource.bottomRight,
                                                color: Colors.white.withOpacity(0.3),
                                                intensity: 0.4,
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 45,
                                                width: 45,
                                                child: Text(
                                                  listRandom[i],
                                                  style: const TextStyle(
                                                    fontSize: 27,
                                                    color: textColor, //customize color here
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      ]
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  const SizedBox(width:5),
                ]
            ),
          ),
          const Divider(height:2,thickness:2),
          const SizedBox(height:5),
          Row(
              children:[
                const SizedBox(width:10),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0)
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder?>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(40)
                    ),
                  ),
                  onPressed: () async {
                    reset();
                  },
                  child: GetBuilder<Controller>(
                    builder: (_) => Text(
                      c.language.string == 'VN'? 'Đặt lại':'Reset',
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width:10),
                const Expanded(child: SizedBox()),
                GetBuilder<Controller>(
                  builder: (_) => Text(
                    c.drawerEnableSound.string,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),),
                const SizedBox(width:10),
                GetBuilder<Controller>(
                  builder: (_) => Switch(
                    activeColor: backgroundColor,
                    activeTrackColor: themeColor,
                    value: c.enableSound.value,
                    onChanged: (value) async {
                      c.enableSound = value.obs;
                      c.update();
                      await boxSetting.put('enableSound',value);
                    },
                  ),
                ),
                const SizedBox(width:10),
              ]
          ),
          const SizedBox(height:5),
        ],
      ),
    );
  }
}

class SpeakWidget extends StatelessWidget {
  const SpeakWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    void onSpeechResult(SpeechRecognitionResult result) async {
      c.listenString = RxString(result.recognizedWords);
      c.update();
      if (result.finalResult) {
        bool kt = false;
        String word = c.word.string.toLowerCase().replaceAll('-', ' ');
        if (word.contains(' ')){
          if (c.listenString.string.toLowerCase().contains(word)){
            kt = true;
          }
        }else{
          if (c.listenString.string.toLowerCase().split(' ').contains(word)){
            kt = true;
          }
        }
        if (kt){
          if (c.speakScore.value<25){
            c.speakScore = RxInt(c.speakScore.value + 1);
            c.update();
            var newScore = Score(
              wordId: c.word.value,
              word: c.wordScore.value,
              pronun: c.pronunScore.value,
              speak: c.speakScore.value,
              mean: c.meanScore.value,
              total: c.wordScore.value + c.pronunScore.value + c.speakScore.value + c.meanScore.value,
              time: DateTime.now().millisecondsSinceEpoch,
            );
            await updateScore(newScore);
          }
          await setRight();
          getNextLearn();
        }else{
          if (c.speakScore.value>0){
            c.speakScore = RxInt(c.speakScore.value - 1);
            c.update();
            var newScore = Score(
              wordId: c.word.value,
              word: c.wordScore.value,
              pronun: c.pronunScore.value,
              speak: c.speakScore.value,
              mean: c.meanScore.value,
              total: c.wordScore.value + c.pronunScore.value + c.speakScore.value + c.meanScore.value,
              time: DateTime.now().millisecondsSinceEpoch,
            );
            await updateScore(newScore);
          }
          await setWrong();
        }
      }
    }

    Future startListening() async {
      await stt.listen(
        onResult: onSpeechResult,
        localeId: c.locale.string,
        // partialResults: false,
      );
    }

    void stopListening() async {
      await stt.stop();
    }

    Widget localeWidget() {
      return Row(
        children: [
          const SizedBox(
            height: 40,
            child: VerticalDivider(
              width: 20,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Colors.black26,
            ),
          ),
          Expanded(
            flex:2,
            child: GetBuilder<Controller>(
              builder: (_) => DropdownButton<String>(
                value: c.locale.string,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(3, 64, 24, 1),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                iconSize: 20,
                isDense: true,
                isExpanded: true,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  c.locale = RxString(newValue!);
                  c.update();
                },
                items: <String>['en-US', 'en-GB']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),),
          ),
          const SizedBox(
            height: 40,
            child: VerticalDivider(
              width: 20,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Colors.black26,
            ),
          ),
        ],
      );
    }

    Widget speedSpeakWidget() {
      return Row(
          children: [
            const SizedBox(width:20),
            Text(
              c.drawerSpeech.string.toLowerCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(
              child: GetBuilder<Controller>(
                builder: (_) => Slider(
                  value: c.speakSpeed.value,
                  min: 0.1,
                  max: 1,
                  divisions: 9,
                  activeColor: Colors.black.withOpacity(0.5),
                  inactiveColor: Colors.black.withOpacity(0.1),
                  thumbColor: Colors.black.withOpacity(0.1),
                  label: double.parse((c.speakSpeed.value).toStringAsFixed(1)).toString(),
                  onChanged: (double value) async {
                    c.speakSpeed = RxDouble(value);
                    c.update();
                  },
                ),
              ),
            ),
          ]
      );
    }

    Widget pronunWidget() {
      return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Colors.white.withOpacity(0.1)
          ),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(0)
          ),
          shape: MaterialStateProperty.all<OutlinedBorder?>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )
          ),
          fixedSize: MaterialStateProperty.all<Size>(
              const Size.fromHeight(40)
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 3),
            Icon(
              Icons.volume_up_outlined,
              size: 30,
              color: Colors.black.withOpacity(0.5),
            ),
            GetBuilder<Controller>(
              builder: (_) => Text(
                c.pronun.string,
                style: const TextStyle(
                  fontSize: 20,
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(width: 3),
          ],
        ),
        onPressed: () {
          _speak(c.word.string);
        },
      );
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      c.listenString = ''.obs;
      c.update();
    });

    return Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:<Widget> [
            const SizedBox(height:10),
            GetBuilder<Controller>(
              builder: (_) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int index=0; index<c.mean.length; index++)
                        Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(8)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: const Offset(5, 5), // changes position of shadow
                                ),
                              ],
                            ),
                            width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                            height: MediaQuery.of(context).size.width > 420? 180*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                            child: Stack(
                                children:[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: ImageFiltered(
                                      imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                      child: Opacity(
                                        opacity: 0.8,
                                        child: Image(
                                          image: NetworkImage('https://bedict.com/' + c.imageURL[index].replaceAll('\\','')),
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                          height: MediaQuery.of(context).size.width > 420? 180*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return const SizedBox();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image(
                                      image: NetworkImage('https://bedict.com/' + c.imageURL[index].replaceAll('\\','')),
                                      fit: BoxFit.contain,
                                      width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                      height: MediaQuery.of(context).size.width > 420? 180*250/300: (MediaQuery.of(context).size.width-60)*250/300/2,
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                ]
                            )
                        ),
                    ]
                ),
              ),
            ),
            const SizedBox(height:5),
            Column(
                children: [
                  speedSpeakWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width:20),
                      Expanded(
                        flex: 3,
                        child: pronunWidget(),
                      ),
                      const SizedBox(width:5),
                      Expanded(
                        flex: 2,
                        child: localeWidget(),
                      ),
                      const SizedBox(width:5),
                    ],
                  ),
                ]
            ),
            Expanded(
              flex: 3,
              child: Row(
                  children:[
                    const SizedBox(width:20),
                    Expanded(
                        child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: SingleChildScrollView(
                                    child: GetBuilder<Controller>(
                                      builder: (_) => Text(
                                        c.listenString.string,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 35,
                                          color: textColor,
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]
                        )
                    ),
                    const SizedBox(width:20),
                  ]
              ),
            ),
            GetBuilder<Controller>(
              builder: (_) => LinearPercentIndicator(
                alignment: MainAxisAlignment.center,
                width: MediaQuery.of(context).size.width - 44,
                lineHeight: 3,
                percent: c.speakScore.value/25,
                backgroundColor: Colors.black.withOpacity(0.1),
                progressColor: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(0),
                animation: true,
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: (){
                    stt.isNotListening ? startListening() : stopListening();
                  },
                  child: GetBuilder<Controller>(
                    builder: (_) => Icon(
                      c.speechEnabled.value?
                      c.isListening.value? Icons.mic
                          : Icons.mic_none : Icons.mic_off,
                      size: c.speechEnabled.value?
                      c.isListening.value? 150 : 120 : 120,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}

class MeanWidget extends StatefulWidget {
  const MeanWidget({Key? key}) : super(key: key);

  @override
  State<MeanWidget> createState() => _MeanWidgetState();
}

class _MeanWidgetState extends State<MeanWidget> {
  final Controller c = Get.put(Controller());
  List mean = [];
  List meanEN = [];
  List meanVN = [];
  int nowIndex = 0;
  List<List> listImage = [];
  List imageURL = [];
  List<int> listIndex = [];
  List<bool> ktMean = [];

  @override
  void initState() {
    getList();
    super.initState();
  }

  Future getList() async {
    var dataRaw = await box.get(c.word.string);
    meanEN = [];
    meanVN = [];
    List<List> _listImage = [];
    List _imageURL = [];
    List<int> _listIndex = [];
    List listMean = jsonDecode(dataRaw['mean']).toList();
    for(var i = 0; i<listMean.length; i++) {
      List meanENAdd = [];
      List meanVNAdd = [];
      for(var j = 0; j< listMean[i].length; j++) {
        String meanENElement = '';
        if (listMean[i][j].contains('#')){
          meanENElement = listMean[i][j].split('#')[1];
        }else{
          meanENElement = listMean[i][j];
        }
        meanENAdd.add(meanENElement);
        String meanVNElement = jsonDecode(dataRaw['meanVN'])[i][j];
        meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
        meanVNElement = meanVNElement + listMean[i][j].substring(listMean[i][j].length-1);
        meanVNAdd.add(meanVNElement);
      }
      meanEN.add(meanENAdd);
      meanVN.add(meanVNAdd);
      if (i>=jsonDecode(dataRaw['imageURL']).length){
        _imageURL.add('bedict.png');
      }else{
        _imageURL.add(jsonDecode(dataRaw['imageURL'])[i]);
      }
    }
    ktMean = [for (int i=0; i<meanEN.length; i++)false];
    for (var i=0; i<meanEN.length; i++){
      _listIndex.add(i);
    }
    _listIndex.shuffle();
    for (var i=0; i<meanEN.length; i++){
      List<String> subListImage = <String>[];
      subListImage.add(_imageURL[_listIndex[i]]);
      for (var j=0;j<3;j++){
        String newRandomImage = _imageURL[_listIndex[i]];
        while (subListImage.contains(newRandomImage)){
          var newWordData = await box.get(c.wordArray[Random().nextInt(c.wordArray.length)]);
          var newRandomImages = jsonDecode(newWordData['imageURL']);
          if (newRandomImages.length>0){
            newRandomImage = newRandomImages[Random().nextInt(newRandomImages.length)];
          }
        }
        subListImage.add(newRandomImage);
      }
      subListImage.shuffle();
      _listImage.add(subListImage);
    }
    setState((){
      if (c.language.string == 'VN'){
        mean = meanVN;
      }else{
        mean = meanEN;
      }
      imageURL = _imageURL;
      listImage = _listImage;
      listIndex = _listIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.black,
      Colors.blue,
      Colors.yellow,
      Colors.green,
    ];

    return GestureDetector(
      onHorizontalDragEnd: (details) async {
        if (details.primaryVelocity! > 0) {
          if (nowIndex > 0){
            setState((){
              nowIndex = nowIndex - 1;
            });
          }else{
            setState((){
              nowIndex = mean.length-1;
            });
          }
        }
        if (details.primaryVelocity! < 0) {
          if (nowIndex < mean.length - 1){
            setState((){
              nowIndex = nowIndex + 1;
            });
          }else{
            setState((){
              nowIndex = 0;
            });
          }
        }
      },
      child: Container(
        color: Colors.transparent,
        child: mean.isNotEmpty?
        Column(
          children: [
            const SizedBox(height: 20),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetBuilder<Controller>(
                          builder: (_) => Flexible(
                            child: AnimatedTextKit(
                              key: ValueKey<String> (c.word.string),
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  c.word.string,
                                  textAlign: TextAlign.center,
                                  speed: const Duration(milliseconds: 300),
                                  textStyle: TextStyle(
                                    fontSize: 50,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 15,
                                        color: Colors.black.withOpacity(0.5),
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  colors: colorizeColors,
                                ),
                                ColorizeAnimatedText(
                                  c.pronun.string,
                                  textAlign: TextAlign.center,
                                  speed: const Duration(milliseconds: 300),
                                  textStyle: TextStyle(
                                    fontSize: 50,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 15,
                                        color: Colors.black.withOpacity(0.5),
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  colors: colorizeColors,
                                ),
                              ],
                              isRepeatingAnimation: true,
                              repeatForever: true,
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                ]
            ),
            const SizedBox(height: 20),
            GetBuilder<Controller>(
              builder: (_) => Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width*0.95,
                child: Column(
                  children: mean[listIndex[nowIndex]].map<Widget>((subMean) =>
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          // color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.all(
                              Radius.circular(6)
                          ),
                        ),
                        width: MediaQuery.of(context).size.width*0.95,
                        child: Column(
                          children: [
                            const SizedBox(height: 3,),
                            Opacity(
                              opacity: 0.3,
                              child: Text(
                                laytuloai(subMean.substring(subMean.length - 1))[c.typeState.value],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 2,),
                            Text(
                              subMean.substring(0,subMean.length-1),
                              style: const TextStyle(
                                fontSize: 18,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 3,),
                          ],
                        ),
                      ),
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GetBuilder<Controller>(
              builder: (_) => LinearPercentIndicator(
                alignment: MainAxisAlignment.center,
                width: MediaQuery.of(context).size.width - 44,
                lineHeight: 3,
                percent: c.meanScore.value/25,
                backgroundColor: Colors.black.withOpacity(0.1),
                progressColor: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(0),
                animation: true,
              ),
            ),
            Expanded(
                child: Row(
                    children:[
                      const SizedBox(width:5),
                      Expanded(
                          child: Column(
                              children:[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: SingleChildScrollView(
                                        child: Wrap(
                                            spacing: 0,
                                            runSpacing: 0,
                                            runAlignment: WrapAlignment.center,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            direction: Axis.horizontal,
                                            alignment: WrapAlignment.center,
                                            children: [
                                              for (int index=0; index<listImage[nowIndex].length; index++)
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (c.enableSound.value){
                                                      await pool.play(soundId);
                                                    }
                                                    if (listImage[nowIndex][index] == imageURL[listIndex[nowIndex]]){
                                                      ktMean[nowIndex] = true;
                                                      await setRight();
                                                      if (!ktMean.contains(false)){
                                                        if (c.meanScore.value<25){
                                                          c.meanScore = RxInt(c.meanScore.value + 1);
                                                          c.update();
                                                          var newScore = Score(
                                                            wordId: c.word.value,
                                                            word: c.wordScore.value,
                                                            pronun: c.pronunScore.value,
                                                            speak: c.speakScore.value,
                                                            mean: c.meanScore.value,
                                                            total: c.wordScore.value + c.pronunScore.value + c.speakScore.value + c.meanScore.value,
                                                            time: DateTime.now().millisecondsSinceEpoch,
                                                          );
                                                          await updateScore(newScore);
                                                        }
                                                        ktMean.clear();
                                                        for (var i=0;i<mean.length;i++){
                                                          ktMean.add(false);
                                                        }
                                                        getNextLearn();
                                                      }else{
                                                        if (nowIndex < mean.length - 1){
                                                          setState((){
                                                            nowIndex = nowIndex + 1;
                                                          });
                                                        }else{
                                                          setState((){
                                                            nowIndex = 0;
                                                          });
                                                        }
                                                      }
                                                    }else{
                                                      ktMean[nowIndex] = false;
                                                      if (c.meanScore.value>0){
                                                        c.meanScore = RxInt(c.meanScore.value - 1);
                                                        c.update();
                                                        var newScore = Score(
                                                          wordId: c.word.value,
                                                          word: c.wordScore.value,
                                                          pronun: c.pronunScore.value,
                                                          speak: c.speakScore.value,
                                                          mean: c.meanScore.value,
                                                          total: c.wordScore.value + c.pronunScore.value + c.speakScore.value + c.meanScore.value,
                                                          time: DateTime.now().millisecondsSinceEpoch,
                                                        );
                                                        await updateScore(newScore);
                                                      }
                                                      await setWrong();
                                                    }
                                                  },
                                                  child: Container(
                                                      margin: const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: const BorderRadius.all(
                                                            Radius.circular(8)
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.6),
                                                            spreadRadius: 0,
                                                            blurRadius: 5,
                                                            offset: const Offset(5, 5), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      // alignment: Alignment.center,
                                                      width: MediaQuery.of(context).size.width > 505? 220: (MediaQuery.of(context).size.width-65)/2,
                                                      height: MediaQuery.of(context).size.width > 505? 220*250/300: (MediaQuery.of(context).size.width-65)*250/300/2,
                                                      child: Stack(
                                                          children:[
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: ImageFiltered(
                                                                imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                                child: Opacity(
                                                                  opacity: 0.8,
                                                                  child: Image(
                                                                    image: NetworkImage('https://bedict.com/' + listImage[nowIndex][index].replaceAll('\\','')),
                                                                    fit: BoxFit.cover,
                                                                    width: MediaQuery.of(context).size.width > 505? 220: (MediaQuery.of(context).size.width-65)/2,
                                                                    height: MediaQuery.of(context).size.width > 505? 220*250/300: (MediaQuery.of(context).size.width-65)*250/300/2,
                                                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                      return const SizedBox();
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: Image(
                                                                image: NetworkImage('https://bedict.com/' + listImage[nowIndex][index].replaceAll('\\','')),
                                                                fit: BoxFit.contain,
                                                                width: MediaQuery.of(context).size.width > 505? 220: (MediaQuery.of(context).size.width-65)/2,
                                                                height: MediaQuery.of(context).size.width > 505? 220*250/300: (MediaQuery.of(context).size.width-65)*250/300/2,
                                                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                  return const SizedBox();
                                                                },
                                                              ),
                                                            ),
                                                          ]
                                                      )
                                                  ),
                                                )
                                            ]
                                        )
                                    ),
                                  ),
                                ),
                              ]
                          )
                      ),
                    ]
                )
            ),
            GetBuilder<Controller>(
              builder: (_) => DotsIndicator(
                  dotsCount: mean.length,
                  position: nowIndex.toDouble(),
                  decorator: DotsDecorator(
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeColor: Colors.black.withOpacity(0.5),
                    color: Colors.black.withOpacity(0.1),
                    activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    spacing: 19*mean.length>MediaQuery.of(context).size.width - 20 ?
                    EdgeInsets.fromLTRB(
                        ((MediaQuery.of(context).size.width-20)/mean.length-9)/2,
                        10,
                        ((MediaQuery.of(context).size.width-20)/mean.length-9)/2,
                        10
                    )
                        : const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  ),
                  onTap: (index){
                    setState((){
                      nowIndex = index.toInt();
                    });
                  }
              ),
            ),
            const Divider(height:2,thickness:2),
            const SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  ToggleSwitch(
                    minWidth: 35.0,
                    minHeight: 22.0,
                    fontSize: 9.0,
                    initialLabelIndex: initLanguageIndex,
                    activeBgColor: const [backgroundColor],
                    activeFgColor: Colors.white,
                    inactiveBgColor: const Color.fromRGBO(240, 240, 240, 1),
                    inactiveFgColor: textColor,
                    totalSwitches: 2,
                    changeOnTap: true,
                    labels: const ['VN', 'EN'],
                    onToggle: (index) async {
                      if (index == 0){
                        c.changeLanguage('VN');
                        setState((){
                          mean = meanVN;
                        });
                      }else{
                        c.changeLanguage('EN');
                        setState((){
                          mean = meanEN;
                        });
                      }
                    },
                  ),
                ]
            ),
            const SizedBox(height:10),
          ],
        )
        : const SizedBox(),
      ),
    );
  }
}

class LearnWord extends StatelessWidget {
  const LearnWord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    List<Widget> widgetOptions = <Widget>[
      const WriteWidget(),
      const PronunWidget(),
      const SpeakWidget(),
      const MeanWidget(),
    ];

    void getBack() {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          Get.offAll(()=>Home());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getTab(int tab) {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          c.currentTab = RxInt(tab);
          c.update();
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(()=> Home());
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            GetBuilder<Controller>(
              builder: (_) => c.imageURL.isNotEmpty?
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Opacity(
                    opacity: 0.8,
                    child: Image(
                      image: NetworkImage('https://bedict.com/' + c.imageURL[c.nowMean.value].replaceAll('\\','')),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              )
                  : const SizedBox(),
            ),
            GestureDetector(
              onVerticalDragEnd: (details) async {
                if (details.primaryVelocity! > 0) {
                  getPreviousLearn();
                }
                if (details.primaryVelocity! < -0) {
                  getNextLearn();
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Row(
                      children:[
                        IconButton(
                          padding: const EdgeInsets.all(0.0),
                          icon: const Icon(Icons.arrow_back_rounded, size: 20,),
                          tooltip: 'back',
                          onPressed: () {
                            getBack();
                          },
                        ),
                        Expanded(
                          child: GetBuilder<Controller>(
                            builder: (_) => Text(
                              c.currentTab.value == 0?
                              c.learnWordGuide.string:
                              c.currentTab.value == 1?
                              c.learnPronunGuide.string:
                              c.currentTab.value == 2?
                              c.learnSpeakGuide.string + c.word.string:
                              c.learnMeanGuide.string,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ]
                    ),
                    Expanded(
                      child: GetBuilder<Controller>(
                        builder: (_) => Center(
                          child: widgetOptions.elementAt(c.currentTab.value),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ]
                ),
              ),
            ),
            Row(
                children:[
                  Column(
                      children:[
                        const Expanded(child:SizedBox()),
                        GetBuilder<Controller>(
                          builder: (_) => DotsIndicator(
                              dotsCount: 4,
                              axis: Axis.vertical,
                              position: c.currentTab.value.toDouble(),
                              decorator: DotsDecorator(
                                size: const Size.square(9.0),
                                activeSize: const Size(9.0, 14.0),
                                activeColor: Colors.black.withOpacity(0.5),
                                color: Colors.black.withOpacity(0.1),
                                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onTap: (index){
                                getTab(index.toInt());
                              }
                          ),
                        ),
                        const Expanded(child:SizedBox()),
                      ]
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                ]
            ),
            GetBuilder<Controller>(
              builder: (_) => Visibility(
                visible: c.learnRight.value,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.7),
                  child: Icon(
                    c.right.value?Icons.check_rounded:Icons.close_rounded,
                    size: 250,
                    color: c.right.value? backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    const int pageCount = 100;

    Future findHistory() async {
      c.listHistory = await getHistory(c.startDayHistory.value,c.endDayHistory.value);
      c.indexHistoryPage = 0.obs;
      c.update();
    }

    Future.delayed(Duration.zero, () async {
      await findHistory();
    });

    void getSearch(String word) {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.isAdShowing = false.obs;
          c.category = 'all category'.obs;
          c.type = 'all type'.obs;
          c.fromScreen = 0.obs;
          c.nowWord = RxInt(c.wordArray.indexOf(word));
          await c.layWord(word);
          Get.offAll(()=>Home());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(()=>MainScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: GetBuilder<Controller>(
            builder: (_) => Text(
              c.drawerHistory.string.toUpperCase(),
              style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          leading: IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: const Icon(
              Icons.arrow_back_ios_rounded, size: 20,
              // color: textColor.withOpacity(0.7),
            ),
            tooltip: 'Back to MainScreen',
            onPressed: () {
              Get.offAll(()=>MainScreen());
            },
          ),
          actions:[
            PopupMenuButton<String>(
              onSelected: (String word) async {
                if (word == 'xóa' || word == 'delete'){
                  for (int i=0;i<c.listHistory.length;i++){
                    await boxHistory.deleteAt(c.lastHistoryIndex.value-i);
                  }
                }else{
                  await boxHistory.clear();
                }
                c.isStartDayHistory = false.obs;
                c.isEndDayHistory = false.obs;
                await findHistory();
              },
              padding: const EdgeInsets.all(0),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                    value: c.language.string == 'VN'? 'xóa':'delete',
                    padding: const EdgeInsets.fromLTRB(6,0,6,0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            c.language.string == 'VN'? 'xóa':'delete',
                            style: const TextStyle(
                              fontSize: 15,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]
                    )
                ),
                PopupMenuItem<String>(
                    value: c.language.string == 'VN'? 'xóa hết lịch sử':'delete all history',
                    padding: const EdgeInsets.fromLTRB(6,0,6,0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            c.language.string == 'VN'? 'xóa hết lịch sử':'delete all history',
                            style: const TextStyle(
                              fontSize: 15,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]
                    )
                ),
              ],
              // color: themeColor,
              child: const Icon(
                Icons.more_vert,
                size: 25,
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
            ),
          ],
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: GestureDetector(
          onHorizontalDragEnd: (details) async {
            if (details.primaryVelocity! > 0) {
              if (c.indexHistoryPage.value>0){
                c.indexHistoryPage = RxInt(c.indexHistoryPage.value-1);
                c.update();
              }
            }
            if (details.primaryVelocity! < -0) {
              if (c.listHistory.length>pageCount*(c.indexHistoryPage.value+1)){
                c.indexHistoryPage = RxInt(c.indexHistoryPage.value+1);
                c.update();
              }
            }
          },
          child: Container(
            color: Colors.white,
            child: Column(
              children:[
                const SizedBox(height: 15),
                Row(
                    children:[
                      const SizedBox(width:10),
                      Expanded(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(0)
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder?>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(
                                const Size.fromHeight(45)
                            ),
                          ),
                          onPressed: () async {
                            if (c.isEndDayHistory.value){
                              c.isEndDayHistory = false.obs;
                            }
                            c.isStartDayHistory = RxBool(!c.isStartDayHistory.value);
                            c.update();
                          },
                          child: GetBuilder<Controller>(
                            builder: (_) => Text(
                              DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(c.startDayHistory.value)),
                              style: const TextStyle(
                                fontSize: 14,
                                color: textColor,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width:10),
                      const Text(
                        '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width:10),
                      Expanded(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(0)
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder?>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(
                                const Size.fromHeight(45)
                            ),
                          ),
                          onPressed: () async {
                            if (c.isStartDayHistory.value){
                              c.isStartDayHistory = false.obs;
                            }
                            c.isEndDayHistory = RxBool(!c.isEndDayHistory.value);
                            c.update();
                          },
                          child: GetBuilder<Controller>(
                            builder: (_) => Text(
                              DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(c.endDayHistory.value)),
                              style: const TextStyle(
                                fontSize: 14,
                                color: textColor,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width:10),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              backgroundColor
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(0)
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder?>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )
                          ),
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size.fromHeight(45)
                          ),
                        ),
                        onPressed: () async {
                          c.isStartDayHistory = false.obs;
                          c.isEndDayHistory = false.obs;
                          await findHistory();
                        },
                        child: const Text(
                          'ok',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width:10),
                    ]
                ),
                GetBuilder<Controller>(
                  builder: (_) => Visibility(
                    visible: c.isStartDayHistory.value,
                    child: Column(
                        children:[
                          const SizedBox(height:10),
                          SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: DateTime.fromMillisecondsSinceEpoch(c.startDayHistory.value),
                              minimumDate: DateTime(2021,12,25),
                              maximumDate: DateTime.now().add(const Duration(days: 1)),
                              onDateTimeChanged: (DateTime newDateTime) {
                                c.startDayHistory = RxInt(newDateTime.millisecondsSinceEpoch);
                                c.update();
                              },
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
                GetBuilder<Controller>(
                  builder: (_) => Visibility(
                    visible: c.isEndDayHistory.value,
                    child: Column(
                        children:[
                          const SizedBox(height:10),
                          SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: DateTime.fromMillisecondsSinceEpoch(c.endDayHistory.value),
                              minimumDate: DateTime(2021,12,25),
                              maximumDate: DateTime.now().add(const Duration(days: 1)),
                              onDateTimeChanged: (DateTime newDateTime) {
                                c.endDayHistory = RxInt(newDateTime.millisecondsSinceEpoch);
                                c.update();
                              },
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
                Row(
                    children:[
                      GetBuilder<Controller>(
                        builder: (_) => Opacity(
                          opacity: c.indexHistoryPage.value>0? 1: 0.3,
                          child: IconButton(
                            padding: const EdgeInsets.all(0.0),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            ),
                            tooltip: 'previous',
                            onPressed: () {
                              if (c.indexHistoryPage.value>0){
                                c.indexHistoryPage = RxInt(c.indexHistoryPage.value-1);
                                c.update();
                              }
                            },
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      GetBuilder<Controller>(
                        builder: (_) => PopupMenuButton<String>(
                          onSelected: (String word) async {
                            c.indexHistoryPage = RxInt(int.parse(word.split('-')[0])~/pageCount);
                            c.update();
                          },
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            for (int i=0; i<(c.listHistory.length/pageCount).abs(); i++)
                              PopupMenuItem<String>(
                                  value: (pageCount*i+1).toString() + '-' +
                                      (c.listHistory.length~/pageCount>i?
                                      (pageCount*i+pageCount).toString():
                                      (pageCount*i+c.listHistory.length%pageCount).toString()) +
                                      '/' + c.listHistory.length.toString(),
                                  padding: const EdgeInsets.fromLTRB(6,0,6,0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (pageCount*i+1).toString() + '-' +
                                              (c.listHistory.length~/pageCount>i?
                                              (pageCount*i+pageCount).toString():
                                              (pageCount*i+c.listHistory.length%pageCount).toString()) +
                                              '/' + c.listHistory.length.toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: textColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ]
                                  )
                              ),
                          ],
                          // color: themeColor,
                          child: Row(
                              children: [
                                Text(
                                  (pageCount*c.indexHistoryPage.value+(c.listHistory.isEmpty?0:1)).toString() + '-' +
                                      (c.listHistory.length~/pageCount>c.indexHistoryPage.value?
                                      (pageCount*c.indexHistoryPage.value+pageCount).toString():
                                      (pageCount*c.indexHistoryPage.value+c.listHistory.length%pageCount).toString()) +
                                      '/' + c.listHistory.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ]
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      GetBuilder<Controller>(
                        builder: (_) => Opacity(
                          opacity: c.listHistory.length>pageCount*(c.indexHistoryPage.value+1)? 1: 0.3,
                          child: IconButton(
                            padding: const EdgeInsets.all(0.0),
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            ),
                            tooltip: 'next',
                            onPressed: () {
                              if (c.listHistory.length>pageCount*(c.indexHistoryPage.value+1)){
                                c.indexHistoryPage = RxInt(c.indexHistoryPage.value+1);
                                c.update();
                              }
                            },
                          ),
                        ),
                      ),
                    ]
                ),
                Expanded(
                  child: GetBuilder<Controller>(
                    builder: (_) =>  ListView.builder(
                        padding: const EdgeInsets.all(4),
                        addAutomaticKeepAlives: false,
                        itemCount: c.listHistory.length>(c.indexHistoryPage.value+1)*pageCount?
                        pageCount:c.listHistory.length-c.indexHistoryPage.value*pageCount,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  flex:3,
                                  child: Container(
                                    height: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(240, 240, 240, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    margin: const EdgeInsets.all(4),
                                    child: Text(
                                      DateFormat('dd-MM-yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(c.listHistory[c.indexHistoryPage.value*pageCount+index].time)),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex:3,
                                  child: GestureDetector(
                                    onTap: () {
                                      getSearch(c.listHistory[c.indexHistoryPage.value*pageCount+index].word);
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      margin: const EdgeInsets.all(4),
                                      child: Text(
                                        c.listHistory[c.indexHistoryPage.value*pageCount+index].word,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SortPage extends StatelessWidget {
  const SortPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    const int pageCount = 100;

    Future findScore() async {
      c.listLearned = await getListScoreTime(c.startDay.value,c.endDay.value);
      c.indexScorePage = 0.obs;
      c.update();
    }

    void getSearch(String word) {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.isAdShowing = false.obs;
          c.category = 'all category'.obs;
          c.type = 'all type'.obs;
          c.fromScreen = 0.obs;
          c.nowWord = RxInt(c.wordArray.indexOf(word));
          await c.layWord(word);
          Get.offAll(()=>Home());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    Future.delayed(Duration.zero, () async {
      await findScore();
    });

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(()=>MainScreen());
        return false;
      },
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: GetBuilder<Controller>(
            builder: (_) => Text(
              c.drawerScore.string.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              // textAlign: TextAlign.left,
            ),
          ),
          leading: IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: const Icon(
              Icons.arrow_back_ios_rounded, size: 20,
              // color: textColor.withOpacity(0.7),
            ),
            tooltip: 'Back to MainScreen',
            onPressed: () {
              Get.offAll(()=>MainScreen());
            },
          ),
          actions:[
            PopupMenuButton<String>(
              onSelected: (String word) async {
                if (word == 'xóa' || word == 'delete'){
                  for (int i=0;i<c.listLearned.length;i++){
                    await boxScore.put(c.listLearned[i].wordId,[
                      c.listLearned[i].wordId,
                      0, 0, 0, 0, 0,
                      DateTime.now().millisecondsSinceEpoch
                    ]);
                  }
                }else{
                  List<String> listWord = [];
                  for (int i=0;i<boxScore.length;i++){
                    var nowWord = await boxScore.getAt(i);
                    if (nowWord[5]>0){
                      listWord.add(nowWord[0]);
                    }
                  }
                  for (int i=0;i<listWord.length;i++){
                    await boxScore.put(listWord[i],[
                      listWord[i],
                      0, 0, 0, 0, 0,
                      DateTime.now().millisecondsSinceEpoch
                    ]);
                  }
                }
                await findScore();
              },
              padding: const EdgeInsets.all(0),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                    value: c.language.string == 'VN'? 'xóa':'delete',
                    padding: const EdgeInsets.fromLTRB(6,0,6,0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            c.language.string == 'VN'? 'xóa':'delete',
                            style: const TextStyle(
                              fontSize: 15,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]
                    )
                ),
                PopupMenuItem<String>(
                    value: c.language.string == 'VN'? 'xóa hết lịch sử':'delete all history',
                    padding: const EdgeInsets.fromLTRB(6,0,6,0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            c.language.string == 'VN'? 'xóa hết lịch sử':'delete all history',
                            style: const TextStyle(
                              fontSize: 15,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]
                    )
                ),
              ],
              // color: themeColor,
              child: const Icon(
                Icons.more_vert,
                size: 25,
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
            ),
          ],
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: GestureDetector(
          onHorizontalDragEnd: (details) async {
            if (details.primaryVelocity! > 0) {
              if (c.indexScorePage.value>0){
                c.indexScorePage = RxInt(c.indexScorePage.value-1);
                c.update();
              }
            }
            if (details.primaryVelocity! < -0) {
              if (c.listLearned.length>pageCount*(c.indexScorePage.value+1)){
                c.indexScorePage = RxInt(c.indexScorePage.value+1);
                c.update();
              }
            }
          },
          child: Container(
            color: Colors.white,
            child: Column(
              children:[
                const SizedBox(height: 15),
                GetBuilder<Controller>(
                  builder: (_) => Column(
                      children: [
                        Row(
                            children:[
                              const SizedBox(width:10),
                              Expanded(
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                        Colors.white
                                    ),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(0)
                                    ),
                                    shape: MaterialStateProperty.all<OutlinedBorder?>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        )
                                    ),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        const Size.fromHeight(45)
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (c.isEndDayOpen.value){
                                      c.isEndDayOpen = false.obs;
                                    }
                                    c.isStartDayOpen = RxBool(!c.isStartDayOpen.value);
                                    c.update();
                                  },
                                  child: Text(
                                    DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(c.startDay.value)),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(width:10),
                              const Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width:10),
                              Expanded(
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                        Colors.white
                                    ),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(0)
                                    ),
                                    shape: MaterialStateProperty.all<OutlinedBorder?>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        )
                                    ),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        const Size.fromHeight(45)
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (c.isStartDayOpen.value){
                                      c.isStartDayOpen = false.obs;
                                    }
                                    c.isEndDayOpen = RxBool(!c.isEndDayOpen.value);
                                    c.update();
                                  },
                                  child: Text(
                                    DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(c.endDay.value)),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(width:10),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      backgroundColor
                                  ),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(0)
                                  ),
                                  shape: MaterialStateProperty.all<OutlinedBorder?>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      )
                                  ),
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      const Size.fromHeight(45)
                                  ),
                                ),
                                onPressed: () async {
                                  c.isStartDayOpen = false.obs;
                                  c.isEndDayOpen = false.obs;
                                  await findScore();
                                },
                                child: const Text(
                                  'ok',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width:10),
                            ]
                        ),
                        Visibility(
                          visible: c.isStartDayOpen.value,
                          child: Column(
                              children:[
                                const SizedBox(height:10),
                                SizedBox(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.date,
                                    initialDateTime: DateTime.fromMillisecondsSinceEpoch(c.startDay.value),
                                    minimumDate: DateTime(2021,12,25),
                                    maximumDate: DateTime.now().add(const Duration(days: 1)),
                                    onDateTimeChanged: (DateTime newDateTime) {
                                      c.startDay = RxInt(newDateTime.millisecondsSinceEpoch);
                                      c.update();
                                    },
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Visibility(
                          visible: c.isEndDayOpen.value,
                          child: Column(
                              children:[
                                const SizedBox(height:10),
                                SizedBox(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.date,
                                    initialDateTime: DateTime.fromMillisecondsSinceEpoch(c.endDay.value),
                                    minimumDate: DateTime(2021,12,25),
                                    maximumDate: DateTime.now().add(const Duration(days: 1)),
                                    onDateTimeChanged: (DateTime newDateTime) {
                                      c.endDay = RxInt(newDateTime.millisecondsSinceEpoch);
                                      c.update();
                                    },
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ]
                  ),
                ),
                Row(
                    children:[
                      GetBuilder<Controller>(
                        builder: (_) => Opacity(
                          opacity: c.indexScorePage.value>0? 1: 0.3,
                          child: IconButton(
                            padding: const EdgeInsets.all(0.0),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            ),
                            tooltip: 'previous',
                            onPressed: () {
                              if (c.indexScorePage.value>0){
                                c.indexScorePage = RxInt(c.indexScorePage.value-1);
                                c.update();
                              }
                            },
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      GetBuilder<Controller>(
                        builder: (_) => PopupMenuButton<String>(
                          onSelected: (String word) async {
                            c.indexScorePage = RxInt(int.parse(word.split('-')[0])~/pageCount);
                            c.update();
                          },
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            for (int i=0; i<(c.listLearned.length/pageCount).abs(); i++)
                              PopupMenuItem<String>(
                                  value: (pageCount*i+1).toString() + '-' +
                                      (c.listLearned.length~/pageCount>i?
                                      (pageCount*i+pageCount).toString():
                                      (pageCount*i+c.listLearned.length%pageCount).toString()) +
                                      '/' + c.listLearned.length.toString(),
                                  padding: const EdgeInsets.fromLTRB(6,0,6,0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (pageCount*i+1).toString() + '-' +
                                              (c.listLearned.length~/pageCount>i?
                                              (pageCount*i+pageCount).toString():
                                              (pageCount*i+c.listLearned.length%pageCount).toString()) +
                                              '/' + c.listLearned.length.toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: textColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ]
                                  )
                              ),
                          ],
                          // color: themeColor,
                          child: Row(
                              children: [
                                Text(
                                  (pageCount*c.indexScorePage.value+(c.listLearned.isEmpty?0:1)).toString() + '-' +
                                      (c.listLearned.length~/pageCount>c.indexScorePage.value?
                                      (pageCount*c.indexScorePage.value+pageCount).toString():
                                      (pageCount*c.indexScorePage.value+c.listLearned.length%pageCount).toString()) +
                                      '/' + c.listLearned.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ]
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      GetBuilder<Controller>(
                        builder: (_) => Opacity(
                          opacity: c.listLearned.length>pageCount*(c.indexScorePage.value+1)? 1: 0.3,
                          child: IconButton(
                            padding: const EdgeInsets.all(0.0),
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            ),
                            tooltip: 'next',
                            onPressed: () {
                              if (c.listLearned.length>pageCount*(c.indexScorePage.value+1)){
                                c.indexScorePage = RxInt(c.indexScorePage.value+1);
                                c.update();
                              }
                            },
                          ),
                        ),
                      ),
                    ]
                ),
                Expanded(
                  child: GetBuilder<Controller>(
                    builder: (_) =>  ListView.builder(
                        padding: const EdgeInsets.all(4),
                        addAutomaticKeepAlives: false,
                        itemCount: c.listLearned.length>(c.indexScorePage.value+1)*pageCount?
                        pageCount:c.listLearned.length-c.indexScorePage.value*pageCount,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap:(){
                              getSearch(c.listLearned[c.indexScorePage.value*pageCount+index].wordId);
                            },
                            child: Container(
                              // height: 70,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  // const SizedBox(width:10),
                                  Expanded(
                                    child: Text(
                                      c.listLearned[c.indexScorePage.value*pageCount+index].wordId,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        // const SizedBox(width:3),
                                        Expanded(
                                          child: CircularPercentIndicator(
                                            radius: (MediaQuery.of(context).size.width*0.5 - 40)/4,
                                            lineWidth: 3.0,
                                            animation: true,
                                            percent: c.listLearned[c.indexScorePage.value*pageCount+index].word/25,
                                            backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
                                            center: Text(
                                              c.scoreWord.string,
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                                color: textColor,
                                              ),
                                            ),
                                            circularStrokeCap: CircularStrokeCap.round,
                                            progressColor: Colors.purple,
                                          ),
                                        ),
                                        Expanded(
                                          child: CircularPercentIndicator(
                                            radius: (MediaQuery.of(context).size.width*0.5 - 40)/4,
                                            lineWidth: 3.0,
                                            animation: true,
                                            percent: c.listLearned[c.indexScorePage.value*pageCount+index].pronun/25,
                                            backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
                                            center: Text(
                                              c.scorePronun.string,
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                                color: textColor,
                                              ),
                                            ),
                                            circularStrokeCap: CircularStrokeCap.round,
                                            progressColor: Colors.purple,
                                          ),
                                        ),
                                        Expanded(
                                          child: CircularPercentIndicator(
                                            radius: (MediaQuery.of(context).size.width*0.5 - 40)/4,
                                            lineWidth: 3.0,
                                            animation: true,
                                            percent: c.listLearned[c.indexScorePage.value*pageCount+index].speak/25,
                                            backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
                                            center: Text(
                                              c.scoreSpeak.string,
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                                color: textColor,
                                              ),
                                            ),
                                            circularStrokeCap: CircularStrokeCap.round,
                                            progressColor: Colors.purple,
                                          ),
                                        ),
                                        Expanded(
                                          child: CircularPercentIndicator(
                                            radius: (MediaQuery.of(context).size.width*0.5 - 40)/4,
                                            lineWidth: 3.0,
                                            animation: true,
                                            percent: c.listLearned[c.indexScorePage.value*pageCount+index].mean/25,
                                            backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
                                            center: Text(
                                              c.scoreMean.string,
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                                color: textColor,
                                              ),
                                            ),
                                            circularStrokeCap: CircularStrokeCap.round,
                                            progressColor: Colors.purple,
                                          ),
                                        ),
                                        // const SizedBox(width:3),
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(width:10),
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final Controller c = Get.put(Controller());
  final int pageCount = 50;
  List<String> listWord = [];
  List listShow = [];
  List<Score> listScore = [];
  int count = 0;

  @override
  void initState() {
    getList(c.part.value);
    super.initState();
  }

  Future getList(int i) async {
    switch(c.bundle.string) {
      case 'IELTS':
        listWord = ieltsList;
        break;
      case 'TOEIC':
        listWord = toeicList;
        break;
      case 'TOEFL':
        listWord = toeflList;
        break;
      case 'ESSENTIAL':
        listWord = essentialList;
        break;
      case 'CƠ BẢN':
        listWord = essentialList;
        break;
      default:
        listWord = c.listWordScore.toList();
    }
    c.listWordScorePage.clear();
    for (var j=0;j<(i<(listWord.length/pageCount).ceil()-1?pageCount:(listWord.length-pageCount*i));j++){
      c.listWordScorePage.add(listWord[i*pageCount+j]);
    }
    // print(c.listWordScorePage);
    c.part = RxInt(i);
    List _listShow = [];
    List<Score> _listScore = [];
    int _count = 0;
    for (int i=0;i<c.listWordScorePage.length;i++){
      var dataRaw = await box.get(c.listWordScorePage[i]);
      var nowWord = await boxScore.get(c.listWordScorePage[i]);
      if (nowWord[5]>0) _count++;
      _listShow.add(dataRaw);
      _listScore.add(Score(
          wordId: nowWord[0],
          word: nowWord[1],
          pronun: nowWord[2],
          speak: nowWord[3],
          mean: nowWord[4],
          total: nowWord[5],
          time: nowWord[6])
      );
    }
    setState((){
      listShow = _listShow;
      listScore = _listScore;
      count = _count;
    });
  }

  @override
  Widget build(BuildContext context) {

    void getToHome(String word) {
      if (!c.isAdShowing.value){
        void toScore() async {
          c.isAdShowing = false.obs;
          await c.layWord(word);
          c.fromScreen = 1.obs;
          Get.offAll(()=>Home());
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getBack() {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          if (c.category.string != 'all category'){
            Get.offAll(()=> const CategoryScreen());
          }else{
            if (c.type.string != 'all type'){
              Get.offAll(()=> const TypeScreen());
            }else{
              Get.offAll(()=> MainScreen());
            }
          }
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getNext() {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          if (listWord.length>pageCount*(c.part.value+1)){
            c.part = RxInt(c.part.value+1);
            getList(c.part.value);
          }
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    void getPrevious() {
      if (!c.isAdShowing.value){
        void toScore() {
          c.isAdShowing = false.obs;
          if (c.part.value>0){
            c.part = RxInt(c.part.value-1);
            getList(c.part.value);
          }
        }
        int isShow = Random().nextInt(showAdFrequency);
        if (isShow == 0 && !c.isVip.value){
          c.isAdShowing = true.obs;
          InterstitialAd.load(
              adUnitId: Platform.isAndroid ? androidAd:iosAd,
              request: const AdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (InterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {},
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                      ad.dispose();
                      toScore();
                    },
                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      toScore();
                    },
                    onAdImpression: (InterstitialAd ad) {},
                  );
                  ad.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  toScore();
                },
              )
          );
        }else{
          toScore();
        }
      }
    }

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //i like transaparent :-)
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarIconBrightness: Brightness.light, // status bar icons' color
        systemNavigationBarIconBrightness: Brightness.light, //navigation bar icons' color
      ),
      child: WillPopScope(
        onWillPop: () async {
          getBack();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              c.bundle.string,
              style: TextStyle(
                fontSize: 18,
                color: textColor.withOpacity(0.7),
              ),
              overflow: TextOverflow.ellipsis,
              // textAlign: TextAlign.left,
            ),
            leading: IconButton(
              padding: const EdgeInsets.all(0.0),
              icon: Icon(
                Icons.arrow_back_ios_rounded, size: 20,
                color: textColor.withOpacity(0.7),
              ),
              tooltip: 'Back',
              onPressed: () {
                getBack();
              },
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            bottomOpacity: 0.0,
            elevation: 0.0,
          ),
          body: GestureDetector(
            onHorizontalDragEnd: (details) async {
              if (details.primaryVelocity! > 0) {
                getPrevious();
              }
              if (details.primaryVelocity! < -0) {
                getNext();
              }
            },
            child: Container(
              color: Colors.white,
              // width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Column(
                children:[
                  // const SizedBox(height: 5),
                  Row(
                      children:[
                        const SizedBox(width: 20),
                        GetBuilder<Controller>(
                          builder: (_) => CircularPercentIndicator(
                            radius: 20,
                            lineWidth: 3.0,
                            animation: true,
                            percent: count/c.listWordScorePage.length,
                            backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
                            progressColor: backgroundColor,
                            // center: Text(
                            //   c.learnedIelts.length.toString(),
                            //   style: const TextStyle(
                            //     fontSize: 9,
                            //     color: textColor,
                            //   ),
                            // ),
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GetBuilder<Controller>(
                          builder: (_) => PopupMenuButton<String>(
                            onSelected: (String word) async {
                              c.part = RxInt(int.parse(word.substring(5,word.indexOf('/')))-1);
                              c.update();
                              getList(c.part.value);
                            },
                            padding: const EdgeInsets.all(0),
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              for (int i=0; i<(listWord.length/pageCount).ceil(); i++)
                                PopupMenuItem<String>(
                                    value: (c.language.string == 'VN'? 'Phần ':'Part ')
                                        + (i+1).toString()
                                        + '/' + (listWord.length/pageCount).ceil().toString(),
                                    padding: const EdgeInsets.fromLTRB(5,0,5,0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            (c.language.string == 'VN'? 'Phần ':'Part ') + (i+1).toString()
                                                + '/' + (listWord.length/pageCount).ceil().toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: textColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ]
                                    )
                                ),
                            ],
                            // color: themeColor,
                            child: Row(
                                children: [
                                  Text(
                                    (c.language.string == 'VN'? 'Phần ':'Part ') + (c.part.value+1).toString()
                                        + '/' + (listWord.length/pageCount).ceil().toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ]
                            ),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        GetBuilder<Controller>(
                          builder: (_) => Opacity(
                            opacity: c.part.value>0? 1: 0.3,
                            child: IconButton(
                              padding: const EdgeInsets.all(0.0),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                              ),
                              tooltip: 'previous',
                              onPressed: () {
                                getPrevious();
                              },
                            ),
                          ),
                        ),
                        GetBuilder<Controller>(
                          builder: (_) => Opacity(
                            opacity: listWord.length>pageCount*(c.part.value+1)? 1: 0.3,
                            child: IconButton(
                              padding: const EdgeInsets.all(0.0),
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              tooltip: 'next',
                              onPressed: () {
                                getNext();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ]
                  ),
                  Expanded(
                    child: GetBuilder<Controller>(
                      builder: (_) => MediaQuery.of(context).size.width<600?
                      ListView.builder(
                        padding: const EdgeInsets.all(0),
                        addAutomaticKeepAlives: false,
                        itemCount: listShow.length,
                        itemBuilder: (BuildContext context, int i) {
                          String mean = '';
                          String image = 'bedict.png';
                          var dataRaw = listShow[i];
                          List listMeans = jsonDecode(dataRaw['mean']);
                          int count = 0;
                          int firstMean = 0;
                          for (var j=listMeans.length-1;j>=0;j--){
                            if (checkSubMean(listMeans[j].cast<String>())){
                              count++;
                              firstMean = j;
                            }
                          }
                          List listMean = listMeans[firstMean];
                          List meanENAdd = [];
                          List meanVNAdd = [];
                          for(var j = 0; j< listMean.length; j++) {
                            String meanENElement = '';
                            if(listMean[j].contains('#')){
                              meanENElement = listMean[j].split('#')[1];
                            }else{
                              meanENElement = listMean[j];
                            }
                            meanENAdd.add(meanENElement);
                            String meanVNElement = jsonDecode(dataRaw['meanVN'])[firstMean][j];
                            meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
                            meanVNElement = meanVNElement + listMean[j].substring(listMean[j].length-1);
                            meanVNAdd.add(meanVNElement);
                          }
                          String meanEN = '';
                          String meanVN = '';
                          for(var j = 0; j< meanENAdd.length; j++) {
                            if (j==0){
                              meanVN = meanVN + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                              meanEN = meanEN + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                            }else{
                              meanVN = meanVN + ' | ' + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                              meanEN = meanEN + ' | ' + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                            }
                          }
                          if (c.language.string == 'VN'){
                            mean = meanVN;
                          }else{
                            mean = meanEN;
                          }
                          if (jsonDecode(dataRaw['imageURL']).length>firstMean){
                            image = jsonDecode(dataRaw['imageURL'])[firstMean];
                          }
                          return GestureDetector(
                            onTap: () async {
                              c.nowWord = RxInt(i);
                              getToHome(dataRaw['word']);
                            },
                            child: Row(
                                children: [
                                  const SizedBox(width:8),
                                  Container(
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.6),
                                            spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: const Offset(5, 5), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      width: (MediaQuery.of(context).size.width-60)/2,
                                      height: (MediaQuery.of(context).size.width-60)*250/300/2,
                                      child: Stack(
                                          children:[
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: ImageFiltered(
                                                imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                child: Opacity(
                                                  opacity: 0.8,
                                                  child: Image(
                                                    image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                    fit: BoxFit.cover,
                                                    width: (MediaQuery.of(context).size.width-60)/2,
                                                    height: (MediaQuery.of(context).size.width-60)*250/300/2,
                                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                      return const SizedBox();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image(
                                                image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                fit: BoxFit.contain,
                                                width: (MediaQuery.of(context).size.width-60)/2,
                                                height: (MediaQuery.of(context).size.width-60)*250/300/2,
                                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                  return const SizedBox();
                                                },
                                              ),
                                            ),
                                            count>1?
                                            Positioned(
                                                right: 7,
                                                bottom: 7,
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.7),
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(20)
                                                      ),
                                                    ),
                                                    height: 40,
                                                    width: 40,
                                                    child: Text(
                                                      '+ ' + (count-1).toString(),
                                                    )
                                                )
                                            )
                                                : const SizedBox(),
                                          ]
                                      )
                                  ),
                                  const SizedBox(width:10),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[
                                          // const SizedBox(height: 8),
                                          Text(
                                            dataRaw['word'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            dataRaw['pronun'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            mean,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                              children: [
                                                // const SizedBox(width:10),
                                                CircularPercentIndicator(
                                                  radius: (MediaQuery.of(context).size.width-100)/8,
                                                  lineWidth: 2.0,
                                                  animation: true,
                                                  percent: listScore[i].word/25,
                                                  backgroundColor: const Color.fromRGBO(220, 220, 220, 0.3),
                                                  center: Text(
                                                    c.scoreWord.string,
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      color: textColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                  circularStrokeCap: CircularStrokeCap.round,
                                                  progressColor: Colors.purple,
                                                ),
                                                const SizedBox(width:5),
                                                CircularPercentIndicator(
                                                  radius: (MediaQuery.of(context).size.width-100)/8,
                                                  lineWidth: 2.0,
                                                  animation: true,
                                                  percent: listScore[i].pronun/25,
                                                  backgroundColor: const Color.fromRGBO(220, 220, 220, 0.3),
                                                  center: Text(
                                                    c.scorePronun.string,
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      color: textColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                  circularStrokeCap: CircularStrokeCap.round,
                                                  progressColor: Colors.purple,
                                                ),
                                                const SizedBox(width:5),
                                                CircularPercentIndicator(
                                                  radius: (MediaQuery.of(context).size.width-100)/8,
                                                  lineWidth: 2.0,
                                                  animation: true,
                                                  percent: listScore[i].speak/25,
                                                  backgroundColor: const Color.fromRGBO(220, 220, 220, 0.3),
                                                  center: Text(
                                                    c.scoreSpeak.string,
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      color: textColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                  circularStrokeCap: CircularStrokeCap.round,
                                                  progressColor: Colors.purple,
                                                ),
                                                const SizedBox(width:5),
                                                CircularPercentIndicator(
                                                  radius: (MediaQuery.of(context).size.width-100)/8,
                                                  lineWidth: 2.0,
                                                  animation: true,
                                                  percent: listScore[i].mean/25,
                                                  backgroundColor: const Color.fromRGBO(220, 220, 220, 0.3),
                                                  center: Text(
                                                    c.scoreMean.string,
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      color: textColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                  circularStrokeCap: CircularStrokeCap.round,
                                                  progressColor: Colors.purple,
                                                ),
                                                // const SizedBox(width:10),
                                              ]
                                          ),
                                        ]
                                    ),
                                  ),
                                  const SizedBox(width:8),
                                ]
                            ),
                          );
                        },
                      )
                      : GridView.count(
                        crossAxisCount: MediaQuery.of(context).size.width~/300,
                        addAutomaticKeepAlives: false,
                        children: List.generate(listShow.length, (i) {
                          String mean = '';
                          String image = 'bedict.png';
                          var dataRaw = listShow[i];
                          List listMeans = jsonDecode(dataRaw['mean']);
                          int count = 0;
                          int firstMean = 0;
                          for (var j=listMeans.length-1;j>=0;j--){
                            if (checkSubMean(listMeans[j].cast<String>())){
                              count++;
                              firstMean = j;
                            }
                          }
                          List listMean = listMeans[firstMean];
                          List meanENAdd = [];
                          List meanVNAdd = [];
                          for(var j = 0; j< listMean.length; j++) {
                            String meanENElement = '';
                            if(listMean[j].contains('#')){
                              meanENElement = listMean[j].split('#')[1];
                            }else{
                              meanENElement = listMean[j];
                            }
                            meanENAdd.add(meanENElement);
                            String meanVNElement = jsonDecode(dataRaw['meanVN'])[firstMean][j];
                            meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
                            meanVNElement = meanVNElement + listMean[j].substring(listMean[j].length-1);
                            meanVNAdd.add(meanVNElement);
                          }
                          String meanEN = '';
                          String meanVN = '';
                          for(var j = 0; j< meanENAdd.length; j++) {
                            if (j==0){
                              meanVN = meanVN + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                              meanEN = meanEN + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                            }else{
                              meanVN = meanVN + ' | ' + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
                              meanEN = meanEN + ' | ' + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
                            }
                          }
                          if (c.language.string == 'VN'){
                            mean = meanVN;
                          }else{
                            mean = meanEN;
                          }
                          if (jsonDecode(dataRaw['imageURL']).length>firstMean){
                            image = jsonDecode(dataRaw['imageURL'])[firstMean];
                          }
                          return GestureDetector(
                            onTap: () {
                              c.nowWord = RxInt(i);
                              getToHome(dataRaw['word']);
                            },
                            child: Row(
                              children: [
                                const Expanded(child:SizedBox()),
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                            children:[
                                              Container(
                                                  margin: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(8)
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.6),
                                                        spreadRadius: 0,
                                                        blurRadius: 5,
                                                        offset: const Offset(5, 5), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  width: 234,
                                                  height: 195,
                                                  child: Stack(
                                                      children:[
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(8),
                                                          child: ImageFiltered(
                                                            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                            child: Opacity(
                                                              opacity: 0.8,
                                                              child: Image(
                                                                image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                                fit: BoxFit.cover,
                                                                width: 234,
                                                                height: 195,
                                                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                  return const SizedBox();
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(8),
                                                          child: Image(
                                                            image: NetworkImage('https://bedict.com/' + image.replaceAll('\\','')),
                                                            fit: BoxFit.contain,
                                                            width: 234,
                                                            height: 195,
                                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                              return const SizedBox();
                                                            },
                                                          ),
                                                        ),
                                                        count>1?
                                                        Positioned(
                                                            right: 7,
                                                            bottom: 7,
                                                            child: Container(
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white.withOpacity(0.7),
                                                                  borderRadius: const BorderRadius.all(
                                                                      Radius.circular(20)
                                                                  ),
                                                                ),
                                                                height: 40,
                                                                width: 40,
                                                                child: Text(
                                                                  '+ ' + (count-1).toString(),
                                                                )
                                                            )
                                                        )
                                                            : const SizedBox(),
                                                      ]
                                                  )
                                              ),
                                              Column(
                                                  children: [
                                                    // const SizedBox(width:10),
                                                    CircularPercentIndicator(
                                                      radius: 38,
                                                      lineWidth: 2.0,
                                                      animation: true,
                                                      percent: listScore[i].word/25,
                                                      backgroundColor: const Color.fromRGBO(220, 220, 220, 0.3),
                                                      center: Text(
                                                        c.scoreWord.string,
                                                        style: TextStyle(
                                                          fontSize: 10.0,
                                                          color: textColor.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: Colors.purple,
                                                    ),
                                                    const SizedBox(height:5),
                                                    CircularPercentIndicator(
                                                      radius: 38,
                                                      lineWidth: 2.0,
                                                      animation: true,
                                                      percent: listScore[i].pronun/25,
                                                      backgroundColor: const Color.fromRGBO(220, 220, 220, 0.3),
                                                      center: Text(
                                                        c.scorePronun.string,
                                                        style: TextStyle(
                                                          fontSize: 10.0,
                                                          color: textColor.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: Colors.purple,
                                                    ),
                                                    const SizedBox(height:5),
                                                    CircularPercentIndicator(
                                                      radius: 38,
                                                      lineWidth: 2.0,
                                                      animation: true,
                                                      percent: listScore[i].speak/25,
                                                      backgroundColor: const Color.fromRGBO(220, 220, 220, 0.3),
                                                      center: Text(
                                                        c.scoreSpeak.string,
                                                        style: TextStyle(
                                                          fontSize: 10.0,
                                                          color: textColor.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: Colors.purple,
                                                    ),
                                                    const SizedBox(height:5),
                                                    CircularPercentIndicator(
                                                      radius: 38,
                                                      lineWidth: 2.0,
                                                      animation: true,
                                                      percent: listScore[i].mean/25,
                                                      backgroundColor: const Color.fromRGBO(220, 220, 220, 0.3),
                                                      center: Text(
                                                        c.scoreMean.string,
                                                        style: TextStyle(
                                                          fontSize: 10.0,
                                                          color: textColor.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: Colors.purple,
                                                    ),
                                                    // const SizedBox(width:10),
                                                  ]
                                              ),
                                            ]
                                        ),
                                        const SizedBox(height:5),
                                        Row(
                                            children:[
                                              const SizedBox(width:10),
                                              Expanded(
                                                child: Text(
                                                  dataRaw['word'],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width:10),
                                            ]
                                        ),
                                        const SizedBox(height:5),
                                        Row(
                                            children:[
                                              const SizedBox(width:10),
                                              Expanded(
                                                child: Text(
                                                  dataRaw['pronun'],
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  // textAlign: TextAlign.right,
                                                ),
                                              ),
                                              const SizedBox(width:10),
                                            ]
                                        ),
                                        const SizedBox(height:5),
                                        Row(
                                            children:[
                                              const SizedBox(width:10),
                                              Expanded(
                                                child: Text(
                                                  mean,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width:10),
                                            ]
                                        ),
                                      ]
                                  ),
                                ),
                                const Expanded(child:SizedBox()),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyUpgradePage extends StatelessWidget {
  const MyUpgradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Controller c = Get.put(Controller());

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(()=>MainScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: GetBuilder<Controller>(
            builder: (_) => Text(
              c.drawerUpgrade.string.toUpperCase(),
              style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),),
          leading: IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: const Icon(
              Icons.arrow_back_ios_rounded, size: 20,
              // color: textColor.withOpacity(0.7),
            ),
            tooltip: 'Back to MainScreen',
            onPressed: () {
              Get.offAll(()=>MainScreen());
            },
          ),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children:[
              const SizedBox(height:7),
              Row(
                  children:[
                    const SizedBox(width:15),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(8)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: const Offset(1, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 20),
                            GetBuilder<Controller>(
                              builder: (_) => Icon(
                                c.available.value? Icons.check_rounded: Icons.close_rounded,
                                size: 25,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: GetBuilder<Controller>(
                                  builder: (_) => Text(
                                    c.available.value? c.language.value == 'VN'? 'cửa hàng có sẵn': 'the store is available'
                                        : c.language.value == 'VN'? 'cửa hàng không có sẵn': 'the store is not available',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width:5),
                  ]
              ),
              const SizedBox(height:10),
              Row(
                  children:[
                    const SizedBox(width:15),
                    Expanded(
                      child: GetBuilder<Controller>(
                        builder: (_) => Opacity(
                          opacity: c.isVip.value? 0.6:1,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  themeColor
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(0)
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder?>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size.fromHeight(50)
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 20),
                                Icon(
                                  c.isVip.value? Icons.check_rounded: Icons.close_rounded,
                                  size: 25,
                                  color: textColor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      c.isVip.value? c.language.value == 'VN'?
                                      'VIP (hạn đến ' + DateFormat('dd-MM-yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(c.expire.value)) + ')':
                                      'VIP (valid until ' + DateFormat('dd-MM-yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(c.expire.value)) + ')'
                                          : c.language.value == 'VN'? 'đăng kí 01 năm (119k)': 'register for 1 year (4.9\$)',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              if (!c.isVip.value){
                                // final ProductDetails productDetails = c.products[0];
                                // final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
                                // await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
                                try {
                                  PurchaserInfo purchaserInfo = await Purchases.purchasePackage(c.package);
                                  bool isPro = purchaserInfo.entitlements.all["yearly"]?.isActive?? false;
                                  c.isVip = RxBool(isPro);
                                  if (isPro){
                                    c.expire = RxInt(DateTime.parse(purchaserInfo.entitlements.all["yearly"]?.expirationDate??DateTime.now().toString()).millisecondsSinceEpoch);
                                  }
                                  c.update();
                                } on PlatformException catch (e) {
                                  var errorCode = PurchasesErrorHelper.getErrorCode(e);
                                  if (errorCode != PurchasesErrorCode.purchaseCancelledError) {

                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width:15),
                  ]
              ),
              const SizedBox(height:15),
              Row(
                children:[
                  const SizedBox(width:15),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            themeColor
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(0)
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder?>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                            const Size.fromHeight(50)
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          c.language.value == 'VN'?'Khôi phục':'Restore',
                          style: const TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            color: textColor,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (!c.isVip.value){
                          try {
                            PurchaserInfo restoredInfo = await Purchases.restoreTransactions();
                            bool isPro = restoredInfo.entitlements.all["yearly"]?.isActive?? false;
                            c.isVip = RxBool(isPro);
                            if (isPro){
                              c.expire = RxInt(DateTime.parse(restoredInfo.entitlements.all["yearly"]?.expirationDate??DateTime.now().toString()).millisecondsSinceEpoch);
                            }
                            c.update();
                          } on PlatformException catch (_) {
                            // Error restoring purchases
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width:15),
                ]
              ),
              const SizedBox(height:15),
              Row(
                  children:[
                    const SizedBox(width:15),
                    Flexible(
                      child: GetBuilder<Controller>(
                        builder: (_) => Text(
                          c.language.value == 'VN'?
                              'Số tiền 119,000 đồng cho 1 năm sẽ được áp dụng vào tài khoản '
                              + (Platform.isIOS?'iTunes':'google') + ' khi xác nhận. '
                              'Đăng ký sẽ được gia hạn tự động trừ khi bị huỷ trong vòng 24 giờ '
                              'trước cuối kỳ hạn. Bạn có thể huỷ bất cứ lúc nào trong cài đặt '
                              'tài khoản ' + (Platform.isIOS?'iTunes':'google') +
                              '. Quảng cáo sẽ biến mất khi bạn đăng kí. Chi tiết hơn xem Chính sách và quyền riêng tư của chúng tôi'
                                  ' tại https://bedict.com/privacyPolicy.html và Điều khoản'
                                  ' dịch vụ tại https://bedict.com/termOfService.html.'
                              : 'register 1 year using this app without advertisement,'
                              ' helping us distribute this app to people\n'
                              'A 4.9\$ for one year purchase will '
                              'be applied to your ' + (Platform.isIOS?'iTunes':'google') +
                              ' account on confirmation. '
                              'Subscriptions will automatically renew unless '
                              'canceled within 24-hours before the end of the current period. '
                              'You can cancel anytime with your '
                              + (Platform.isIOS?'iTunes':'google') + ' account settings.'
                              ' Advertisements will disappear if you purchase a subscription. '
                              'For more information, '
                              'see our Privacy Policy at https://bedict.com/privacyPolicy.html'
                              ' and Terms of Use at https://bedict.com/termOfService.html.',
                          style: const TextStyle(
                            fontSize: 16,
                            // overflow: TextOverflow.ellipsis,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width:15),
                  ]
              ),
              const Expanded(child:SizedBox()),
              const Divider(height:2,thickness:2),
              const SizedBox(height:10),
              Row(
                  children:[
                    const SizedBox(width:15),
                    Expanded(
                      child: OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(10)
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder?>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              )
                          ),
                          // fixedSize: MaterialStateProperty.all<Size>(
                          //     const Size.fromHeight(40)
                          // ),
                        ),
                        onPressed: () {
                          Get.to(()=>const PolicyPage());
                        },
                        child: GetBuilder<Controller>(
                          builder: (_) => Text(
                            c.language.string == 'VN'? 'Chính sách và quyền riêng tư':'Privacy Policy',
                            style: const TextStyle(
                              color: textColor,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width:15),
                    OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(10)
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder?>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )
                        ),
                        // fixedSize: MaterialStateProperty.all<Size>(
                        //     const Size.fromHeight(40)
                        // ),
                      ),
                      onPressed: () {
                        Get.to(()=>const TermPage());
                      },
                      child: GetBuilder<Controller>(
                        builder: (_) => Text(
                          c.language.string == 'VN'? 'Điều khoản dịch vụ':'Tearms of Use',
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width:15),
                  ]
              ),
              const SizedBox(height:10),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(()=>MainScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: GetBuilder<Controller>(
            builder: (_) => Text(
              c.drawerContact.string.toUpperCase(),
              style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),),
          leading: IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: const Icon(
              Icons.arrow_back_ios_rounded, size: 20,
              // color: textColor.withOpacity(0.7),
            ),
            tooltip: 'Back to MainScreen',
            onPressed: () {
              Get.offAll(()=>MainScreen());
            },
          ),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.account_box_rounded,size:35,color: backgroundColor),
                    SizedBox(width: 10),
                    Text(
                      'Trần Trung Hiếu',
                      style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]
              ),
              const SizedBox(height:10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.phone,size:30,color: backgroundColor),
                    SizedBox(width: 10),
                    Text(
                      '0942245089',
                      style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]
              ),
              const SizedBox(height:10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.mail,size:30,color: backgroundColor),
                    SizedBox(width: 10),
                    Text(
                      'hieupro1106@gmail.com',
                      style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]
              ),
              const SizedBox(height:10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(FontAwesomeIcons.facebook,size:25,color: backgroundColor),
                    SizedBox(width: 10),
                    Text(
                      'facebook.com/dosel.be',
                      style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PolicyPage extends StatelessWidget {
  const PolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<Controller>(
          builder: (_) => Text(
            c.drawerPolicy.string.toUpperCase(),
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),),
        leading: IconButton(
          padding: const EdgeInsets.all(0.0),
          icon: const Icon(
            Icons.arrow_back_ios_rounded, size: 20,
            // color: textColor.withOpacity(0.7),
          ),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          padding: const EdgeInsets.all(8),
          children: [
            const SizedBox(height: 20),
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'This page is used to inform visitors regarding my policies with the collection, use, and'
                          ' disclosure of Personal Information if anyone decided to use my Service.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'If you choose to use my Service, then you agree'
                          ' to the collection and use of information in relation to this'
                          ' policy. The Personal Information that I collect is'
                          ' used for providing and improving the Service.'
                          ' I will not use or share your'
                          ' information with anyone except as described in this Privacy Policy.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'The terms used in this Privacy Policy have the same meanings'
                          ' as in our Terms of Service, which is accessible at'
                          ' BeDict unless otherwise defined in this Privacy Policy.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 20),
            const Text(
              'Information Collection and Use',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'For a better experience, while using our Service,'
                          ' I may require you to provide us with certain'
                          ' personally identifiable information, including but not limited to (RECORD_AUDIO). The'
                          ' information that I request will be'
                          ' retained on your device and is not collected by me in any way.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'The app does use third party services that may collect'
                          'information used to identify you.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'Link to privacy policy of third party service providers'
                          ' used by the app\n Google Play Services: https://www.google.com/policies/privacy/'
                          '\nAdMob https://support.google.com/admob/answer/6128543?hl=en'
                          '\n\nI want to inform you that whenever'
                          ' you use my Service, in a case of an error in the'
                          ' app I collect data and information (through third'
                          ' party products) on your phone called Log Data. This Log Data'
                          ' may include information such as your device Internet'
                          ' Protocol (“IP”) address, device name, operating system'
                          ' version, the configuration of the app when utilizing'
                          ' my Service, the time and date of your use of the'
                          ' Service, and other statistics.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 20),
            const Text(
              'Cookies',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'Cookies are files with a small amount of data that are'
                          ' commonly used as anonymous unique identifiers. These are'
                          ' sent to your browser from the websites that you visit and'
                          ' are stored on your device\'s internal memory.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'This Service does not use these “cookies” explicitly.'
                          ' However, the app may use third party code and libraries that'
                          ' use “cookies” to collect information and improve their'
                          ' services. You have the option to either accept or refuse'
                          ' these cookies and know when a cookie is being sent to your'
                          ' device. If you choose to refuse our cookies, you may not be'
                          ' able to use some portions of this Service.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 20),
            const Text(
              'Service Providers',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'I may employ third-party companies'
                          ' and individuals due to the following reasons:\n'
                          ' To facilitate our Service;\n'
                          ' To provide the Service on our behalf;\n'
                          ' To perform Service-related services; or\n'
                          ' To assist us in analyzing how our Service is used.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'I want to inform users of this'
                          ' Service that these third parties have access to your'
                          ' Personal Information. The reason is to perform the tasks'
                          ' assigned to them on our behalf. However, they are obligated'
                          ' not to disclose or use the information for any other purpose.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 20),
            const Text(
              'Security',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'I value your trust in providing us'
                          ' your Personal Information, thus we are striving to use'
                          ' commercially acceptable means of protecting it. But remember'
                          ' that no method of transmission over the internet, or method'
                          ' of electronic storage is 100% secure and reliable, and'
                          ' I cannot guarantee its absolute security.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 20),
            const Text(
              'Links to Other Sites',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'This Service may contain links to other sites. If you click'
                          ' on a third-party link, you will be directed to that site.'
                          ' Note that these external sites are not operated by'
                          ' me. Therefore, I strongly advise you to'
                          ' review the Privacy Policy of these websites.'
                          ' I have no control over and assume no'
                          ' responsibility for the content, privacy policies, or'
                          ' practices of any third-party sites or services.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 20),
            const Text(
              'Children’s Privacy',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'These Services do not address anyone under the age of 3.'
                          ' I do not knowingly collect personally'
                          ' identifiable information from children under 3. In the case'
                          ' I discover that a child under 3 has provided'
                          ' me with personal information,'
                          ' I immediately delete this from our servers. If you'
                          ' are a parent or guardian and you are aware that your child'
                          ' has provided us with personal information, please contact'
                          ' me so that I will be able to do necessary actions.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 20),
            const Text(
              'Changes to This Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'I may update our Privacy Policy from'
                          'time to time. Thus, you are advised to review this page'
                          'periodically for any changes. I will'
                          'notify you of any changes by posting the new Privacy Policy'
                          'on this page. These changes are effective immediately after'
                          'they are posted on this page.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class TermPage extends StatelessWidget {
  const TermPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<Controller>(
          builder: (_) => Text(
            (c.language.string == 'VN'? 'Điều khoản sử dụng':'Terms of Use').toUpperCase(),
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),),
        leading: IconButton(
          padding: const EdgeInsets.all(0.0),
          icon: const Icon(
            Icons.arrow_back_ios_rounded, size: 20,
            // color: textColor.withOpacity(0.7),
          ),
          tooltip: 'Back to MainScreen',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          padding: const EdgeInsets.all(8),
          children: [
            const SizedBox(height: 20),
            const Text(
              'Terms of Service',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'These Terms of Service and End User License Agreement (this “Agreement”)'
                          ' constitute a legal agreement between you and BeDict '
                          '(“BeDict”, “we”, “our”, or “us”) stating the terms and conditions'
                          ' that govern your use of the mobile, desktop or web-based application'
                          ' provided herewith (the “Application”) and the web site at www.bedict.com'
                          ' (the “Site”). The Application and the Site are referred to together as'
                          ' the “Service.” Please read this Agreement carefully. By downloading,'
                          ' installing, and/or using the Application or accessing and/or using the Site,'
                          ' you agree to be bound by and comply with the terms and conditions of this'
                          ' Agreement. You hereby represent and warrant that you are legally able to'
                          ' form a binding contract with BeDict. If you do not agree to these terms'
                          ' and conditions, do not download, install and/or use the Application or'
                          ' access and/or use the Site. We may at our sole discretion change, add,'
                          ' modify, or delete portions of this Agreement from time to time. Please '
                          'review this Agreement for changes prior to use of the Service. Your continued'
                          ' use of the Service following the posting of changes to this Agreement'
                          ' constitutes your acceptance of any changes. This is an agreement between'
                          ' you and BeDict.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Provision of Access',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'BeDict shall make the Service available to you pursuant to this Agreement'
                          ' during your Subscription Term, solely for your own internal business'
                          ' purposes. You agree that your purchase of the Service is neither'
                          ' contingent upon the delivery of any future functionality or features '
                          'nor dependent upon any oral or written public comments made by BeDict '
                          'with respect to future functionality or features. “Subscription Term” '
                          'means the then-current Initial Term or Renewal Term of your order for '
                          'the Service during which you are authorized to use or access the Service'
                          ' pursuant to the terms set forth in this Agreement, unless earlier '
                          'terminated as set forth in Section 2.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Change or Update to Service; Term; Termination',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'The “Term” of the Agreement shall be the duration of the then-current'
                          ' Initial Term or Renewal Term(s) of your applicable subscription for'
                          ' the Service. For purposes of clarity, the Term of this Agreement will'
                          ' commence on: (i) the effective date specified in your subscription '
                          'order, or (ii) at the time of download of the Application (as applicable),'
                          ' and will continue until you terminate your subscription to the Services,'
                          ' or BeDict terminates this Agreement pursuant to this Section 2. The '
                          '“Initial Term” for each subscription order will commence on the effective'
                          ' date set forth on such order, or at the time of download of the Application'
                          ' (as applicable), and will continue for the subscription period selected by'
                          ' the user. Unless otherwise set forth on the relevant order, each order will'
                          ' automatically renew after the Initial Term for successive monthly or annual'
                          ' periods (each a “Renewal Term”), as applicable, unless you give BeDict prior'
                          ' written notice of your intent not to renew such subscription at least one'
                          ' (1) day prior to the end of the Initial Term or then-current Renewal Term.'
                          ' BeDict may increase the Fees due under orders for the applicable Renewal '
                          'Terms (if any) by providing notice to Customer of such increase at the time'
                          ' of renewal. You are permitted to continue use of the Service from the time'
                          ' of your notice of non-renewal through the end of the then applicable Term.'
                          ' However, BeDict is not obligated to refund to you any prepaid Fees for any Term.'
                          ' BeDict, at its sole discretion, and on a case-by-case base, may opt to refund'
                          ' Fees to its users. BeDict shall have the right for any reason, in its sole'
                          ' discretion, to terminate, change, suspend or discontinue, temporarily or'
                          ' permanently, any aspect of the Service, including but not limited to content'
                          ' or features, without notice to you. We may also impose limits on certain '
                          'features and services or restrict your access to parts or all of the Service'
                          ' with or without notice or liability. From time to time, BeDict may make '
                          'available updates or upgrades to the Service via software download or other'
                          ' means. Such updates or upgrades may occur automatically without the need '
                          'for an act on your part, or it may require you to manually download an '
                          'update or upgrade through the same source from which the Service was originally'
                          ' downloaded. Certain functions of the Service may be modified or discontinued'
                          ' as a result of any such update or upgrade, or may not be available if you'
                          ' have not downloaded all updates and upgrades made available by BeDict or'
                          ' otherwise. BeDict DOES NOT WARRANT THAT THE FUNCTIONS, FEATURES OR CONTENT'
                          ' CONTAINED IN THE SERVICE WILL BE UNINTERRUPTED OR ERROR FREE, THAT DEFECTS'
                          ' WILL BE CORRECTED, OR THAT ANY OTHER SITE OR THE SERVER THAT MAKES IT'
                          ' AVAILABLE IS FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS. If your use'
                          ' of this Service results in the need for servicing or replacing property,'
                          ' material, equipment or data, BeDict is not responsible for those costs.'
                          ' The Service may contain information about BeDict or other products or services.'
                          ' The information in the Service is accurate as of the date the Service'
                          ' is made available to you. Such information about BeDict or other products'
                          ' or services may be updated from time to time, including without limitation,'
                          ' when the Service may be updated or upgraded. You should periodically check'
                          ' whether an updated or upgraded version of the Service is available. You'
                          ' agree that BeDict may terminate your use of this Service, and/or exercise'
                          ' any other remedy available to it, if BeDict reasonably believes that you'
                          ' have violated or acted inconsistently with the letter or spirit of this'
                          ' Agreement, or violated the rights of BeDict or any third party, or for'
                          ' any reason with or without notice to you. You agree that BeDict will not'
                          ' be held liable to you or any third party as a result thereof.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '3. iOS In-App Purchase Terms',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'BeDict subscription details for iOS: Payment will be charged to iTunes Account'
                          ' at confirmation of purchase Subscription automatically renews unless '
                          'auto-renew is turned off at least 24-hours before the end of the current'
                          ' period Account will be charged for renewal within 24-hours prior to the'
                          ' end of the current period, and identify the cost of the renewal Subscriptions'
                          ' may be managed by the user and auto-renewal may be turned off by going'
                          ' to the user\'s Account Settings after purchase Advertisements will disappear'
                          ' when the user purchases a subscription, where applicable.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '4. Limited License to the Service and Content',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'Subject to the terms and conditions of this Agreement, BeDict grants you'
                          ' a personal, limited, non- exclusive and non-transferable license to'
                          ' install and use the Application for purposes on any device that you'
                          ' own or control and as permitted by the Usage Rules set forth in Apple\'s'
                          ' App Store Terms of Service (the “Usage Rules”) or Google\'s Play Store'
                          'Terms of Service for mobile devices specifically. This license does not '
                          'allow you to use the Application on any device that you do not own or '
                          'control, and you may not distribute or make the Application available '
                          'over a network where it could be used by multiple devices at the same time.'
                          ' This license does not entitle you to receive from us hard-copy documentation,'
                          ' support, telephone assistance, or enhancements or updates to the Application,'
                          ' and Apple and Google have no obligation to furnish any maintenance and'
                          ' support services regarding the Application. The terms of this license will'
                          ' govern any upgrades provided by us that replace or supplement the original'
                          ' Application unless such upgrade is accompanied by a separate license in which'
                          ' case the terms of that license will govern. Subject to the terms and conditions'
                          ' of this Agreement, BeDict grants you a personal, limited, non-exclusive,'
                          ' and non-transferable license to use, publish, distribute, and display the'
                          ' pre-approved backgrounds, imagery, and music provided in the Service for'
                          ' the purposes of creating digital media content through the Service (“Licensed'
                          ' Materials”).',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '5. Restrictions',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'You must use the Service in compliance with all applicable laws. You must comply'
                          ' with applicable third-party terms of agreement when using the Service (e.g.,'
                          ' your wireless data service agreement). Your right to use the Service will'
                          ' terminate immediately if you violate any provision of this Agreement.'
                          ' Your rights to use the Service are specified in this Agreement and all'
                          ' rights not expressly granted herein are reserved to BeDict. All rights not'
                          ' expressly granted in Sections 1 and 4 above are exclusively reserved to BeDict.'
                          ' When using the Service, you may not: modify, adapt, copy, translate, create'
                          ' derivative works from, publish, license, sell, or otherwise commercialize'
                          ' the Service, Content (defined below), or any information or software associated'
                          ' with the Service; decompile, reverse-engineer, disassemble or otherwise attempt'
                          ' to derive source code from the Service; remove, obscure or alter BeDict’s'
                          ' copyright notice, trademarks, or other proprietary rights notices affixed'
                          ' to the Service or Content; rent, lease, sublicense, or otherwise transfer rights'
                          ' to the Service; use the Service in any manner that could impair or interfere with'
                          ' the Service; interfere or attempt to interfere with the operation of the Service'
                          ' in any way through any means, software, routine or device including, but not limited'
                          ' to, spamming, hacking, uploading computer viruses or time bombs, or other means;'
                          ' use any robot, spider, other automatic device, or manual process to monitor or'
                          ' copy the Service or Content contained thereon or for any other purpose without'
                          ' our prior express written permission; or take any action that imposes an unreasonable'
                          ' or disproportionately large load on the BeDict infrastructure.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '6. Intellectual Property',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'All intellectual property rights in and to the content, tools, text, logos,'
                          ' marks, data, audio, video, design, codes, layout, “look and feel”, and'
                          ' other content that is included on the Service (“Content“) is owned by'
                          ' BeDict or the applicable third-party intellectual property owners. Except'
                          ' for the rights granted herein with respect to the Licensed Materials,'
                          ' your use of any Content without prior written consent is strictly prohibited.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '7. Fees',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'You shall pay all fees specified in all applicable subscription orders'
                          ' (“Fees”). Except as otherwise specified herein or in any subscription order,'
                          ' all Fees are quoted and payable in United States dollars or VietNam Dong,'
                          ' payment obligations are non-cancelable, and Fees paid are non-refundable.'
                          ' Fees for the Service are based on subscriptions purchased and not actual'
                          ' usage. For purposes of clarity, the subscription purchased cannot be'
                          ' decreased during a Subscription Term. Payments for downloadable versions '
                          'of the Application are made via their respective application stores (Apple'
                          ' App Store or Google Play). BeDict does not have access to, nor retains any'
                          ' credit card information of, any user of the Service.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '8. Third-Party Websites',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'You may be able to link from the Service to third-party websites that take'
                          ' you outside of the Service (“Linked Sites”). BeDict has no responsibility'
                          ' for the information, content, products, services, advertising, code or'
                          ' other material, which may be provided through the Linked Sites. Your'
                          ' interactions with Linked Sites are subject to the terms of service and'
                          ' other policies of those sites, so please use common sense as you navigate'
                          ' the Web and be aware when you leave the Service.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '9. Disclaimers',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'THE SERVICE AND ALL CONTENT, SOFTWARE, FUNCTIONS, MATERIALS, AND INFORMATION'
                          ' MADE AVAILABLE ON OR ACCESSED THROUGH IT, ARE PROVIDED ON AN “AS IS” AND '
                          '“AS AVAILABLE” BASIS WITHOUT WARRANTIES OF ANY KIND. ALL WARRANTIES, EXPRESS,'
                          ' IMPLIED OR STATUTORY, ARE DISCLAIMED, INCLUDING, BUT NOT LIMITED TO, ANY'
                          ' IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,'
                          ' NON-INFRINGEMENT OF THIRD-PARTY RIGHTS, OR ARISING OUT OF COURSE OF CONDUCT,'
                          ' TRADE CUSTOM, OR USAGE. IN ADDITION, BeDict DISCLAIMS (A) ANY ENDORSEMENT'
                          ' OF OR LIABILITY FOR USER SUBMISSIONS, CONTENT, AND LINKED SITES; (B) '
                          'INACCURACY, INCOMPLETENESS OR TIMELINESS OF THE CONTENT; (C) THE TRANSMISSION'
                          ' OF VIRUSES OR THE OCCURRENCE OF DATA CORRUPTION; AND (D) DAMAGES AS A RESULT'
                          ' OF THE TRANSMISSION, USE OR INABILITY TO USE THE SERVICE OR CIRCUMSTANCES OVER'
                          ' WHICH BeDict HAS NO CONTROL. YOU UNDERSTAND AND AGREE THAT THE OPERATION OF'
                          ' THE SERVICE MAY INVOLVE BUGS, ERRORS, PROBLEMS OR OTHER LIMITATIONS. BeDict'
                          ' HAS NO LIABILITY WHATSOEVER FOR YOUR USE OF THE SERVICE OR USE OF ANY I'
                          'NFORMATION OR MATERIALS ACCESSED THROUGH THE SERVICE. NO ADVICE OR INFORMATION,'
                          ' WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM BeDict THROUGH THE SERVICE CREATES'
                          ' ANY WARRANTY, REPRESENTATION OR GUARANTEE. BeDict DOES NOT WARRANT THAT THE'
                          ' FUNCTIONS, FEATURES OR CONTENT CONTAINED IN THE SERVICE WILL BE UNINTERRUPTED'
                          ' OR ERROR FREE, THAT DEFECTS WILL BE CORRECTED, OR THAT ANY OTHER SITE OR THE'
                          ' SERVER THAT MAKES IT AVAILABLE IS FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS.'
                          ' If your use of the Service results in the need for servicing or replacing '
                          'property, material, equipment or data, BeDict is not responsible for those costs.'
                          ' IF YOU ARE DISSATISFIED WITH THE SERVICE, YOUR SOLE AND EXCLUSIVE REMEDY IS'
                          ' TO DISCONTINUE USING THE SERVICE. Your downloading, installation and use of'
                          ' the Service is at your own discretion and risk, and you are solely responsible'
                          ' for any damages to your hardware device(s) or loss of data that results from'
                          ' the downloading, installation or use of the Service.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '10. Disclaimer of Apple’s Liability; Third Party Beneficiary Rights',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'Neither Apple nor Google will be responsible for any claims by you or any third'
                          ' party relating to your possession and/or use of the Application, including'
                          ' but not limited to (i) product-liability claims, (ii) any claims that the'
                          ' Application fails to conform to any applicable legal or regulatory requirement,'
                          ' (iii) claims arising under consumer-protection laws or similar legislation, and'
                          ' (iv) claims by any third party that the Application or your possession and use'
                          ' of the Application infringes the intellectual property rights of the third party.'
                          ' You agree that Apple, Google, and their respective subsidiaries are third-party'
                          ' beneficiaries of this Agreement, and that upon your acceptance of the terms and'
                          ' conditions of this Agreement, Apple and/or Google will have the right (and will'
                          ' be deemed to have accepted the right) to enforce this Agreement against you as a'
                          ' third party beneficiary thereof.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '11. Limitation of Liability; Exclusion of Damages',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'BeDict WILL NOT BE RESPONSIBLE FOR ANY DIRECT, INDIRECT, SPECIAL, CONSEQUENTIAL'
                          ' OR EXEMPLARY DAMAGES, WHETHER FORESEEABLE OR NOT, THAT ARE IN ANY WAY RELATED'
                          ' TO THIS AGREEMENT, ANY VIRUSES AFFECTING THE SERVICE, THE USE OR INABILITY TO'
                          ' USE THE SERVICE, THE RESULTS GENERATED FROM THE USE OF THIS SERVICE, LOSS OF'
                          ' GOODWILL OR PROFITS, LOST BUSINESS, HOWEVER CHARACTERIZED, AND/OR FROM ANY'
                          ' OTHER CAUSE WHATSOEVER. BeDict is not liable for any lost data resulting from'
                          ' use of the Service and/or the enforcement of this Agreement. BeDict disclaims'
                          ' any and all liability for the acts, omissions and conduct of any users on the'
                          ' Service or otherwise related to your use of the Service. BeDict is not'
                          ' responsible for the products, services, actions or failure to act of any'
                          ' other third party in connection with the Service. NOTWITHSTANDING ANYTHING'
                          ' TO THE CONTRARY CONTAINED HEREIN, BeDict’S AGGREGATE LIABILITY TO YOU FOR ANY'
                          ' CAUSE WHATSOEVER AND REGARDLESS OF THE FORM OF THE ACTION, WILL BE LIMITED'
                          ' TO THE AMOUNT YOU PAID TO BeDict, IF ANY, IN THE SIX (6) MONTHS PRIOR TO THE'
                          ' EVENTS GIVING RISE TO YOUR CLAIM.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
            const Text(
              '12. Wireless Access Charges',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
                children: const [
                  Flexible(
                    child: Text(
                      'Certain Application functions may require data access, and the provider'
                          ' of data access for your device may charge you data access fees in connection'
                          ' with your use of the Application. You are solely responsible for any data'
                          ' access or other charges you incur.',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    Future.delayed(Duration.zero, () async {
      final response = await http.get(Uri.parse('https://drive.google.com/uc?export=download&id=1vUu4qZjTS5tpndNEHTBHaE51rr6y0sP_'),headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        List data = json.decode(utf8.decode(response.bodyBytes));
        for (var i=0;i<data.length;i++){
          await box.put(data[i]['word'],data[i]);
          List score = [data[i]['word'],0,0,0,0,0,DateTime.now().millisecondsSinceEpoch];
          await boxScore.put(data[i]['word'],score);
        }
        await boxSetting.put('isIntroduce',false);
        Get.offAll(()=>MainScreen());
      } else {
        Get.defaultDialog(
          title: c.loadingFailTitle.string,
          middleText: c.loadingFailBody.string,
          backgroundColor: themeColor,
          titleStyle: const TextStyle(color: textColor,),
          middleTextStyle: const TextStyle(color: textColor,),
          textConfirm: 'cancel',
          confirmTextColor: textColor,
          buttonColor: Colors.white,
          textCancel: "ok",
          cancelTextColor: textColor,
          barrierDismissible: false,
          radius: 8,
          onConfirm: () async {
            Navigator.pop(context);
          },
          onCancel: () async {
            Navigator.pop(context);
          },
        );
      }
    });

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  backgroundColor: themeColor,
                  valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                  c.loadingBody.string,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: textColor,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    const textColor = Color.fromRGBO(3, 64, 24, 1);
    const backgroundColor = Color.fromRGBO(147, 219, 172, 1);
    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Color(0xff879c03), Color(0xff353d01)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    Future.delayed(Duration.zero, () async {

    });

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(
                          'BeDict',
                          style: TextStyle(
                              fontSize: 100,
                              foreground: Paint()..shader = linearGradient
                          ),
                        ),
                        Text(
                          'Pictorial Dictionary',
                          style: TextStyle(
                              fontSize: 33.4,
                              foreground: Paint()..shader = linearGradient
                          ),
                        ),
                      ]
                  )
              ),
              Row(
                  children: [
                    const SizedBox(width:40),
                    Expanded(
                      child: GetBuilder<Controller>(
                        builder: (_) => Text(
                          c.welcomeBody.string,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width:40),
                  ]
              ),
              const SizedBox(height: 20),
              Opacity(
                opacity: 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<Controller>(
                      builder: (_) =>  Text(
                        c.drawerLanguage.string,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),),
                    const SizedBox(width:20),
                    ToggleSwitch(
                      minWidth: 50.0,
                      minHeight: 30.0,
                      fontSize: 14.0,
                      initialLabelIndex: initLanguageIndex,
                      activeBgColor: const [backgroundColor],
                      activeFgColor: Colors.white,
                      inactiveBgColor: const Color.fromRGBO(240, 240, 240, 1),
                      inactiveFgColor: textColor,
                      totalSwitches: 2,
                      changeOnTap: true,
                      labels: const ['VN', 'EN'],
                      onToggle: (index) async {
                        if (index == 0){
                          c.changeLanguage('VN');
                        }else{
                          c.changeLanguage('EN');
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: backgroundColor,
            child: const Icon(Icons.arrow_forward,size: 30),
            onPressed: () {
              Get.offAll(()=>Introduce());
            }
        ),
      ),
    );
  }
}

class BannerAdWidget extends StatefulWidget {
  // const BannerAdWidget({Key? key}) : super(key: key);

  final double adWidth;
  final double adHeight;

  const BannerAdWidget({Key? key,
    required this.adWidth,
    required this.adHeight
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BannerAdState();
}

class BannerAdState extends State<BannerAdWidget> {
  late BannerAd bannerAd;
  final Completer<BannerAd> nativeAdCompleter = Completer<BannerAd>();
  final Controller c = Get.put(Controller());
  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(
      adUnitId: Platform.isAndroid ? 'ca-app-pub-9467993129762242/5194909402' : 'ca-app-pub-9467993129762242/4031685759',
      request: const AdRequest(),
      size: AdSize(
        width: widget.adWidth.ceil(),
        height: widget.adHeight.ceil(),
      ),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          nativeAdCompleter.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError err) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) => {},
        onAdClosed: (Ad ad) => {},
      ),
      // customOptions: <String, Object>{},
    );
    bannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerAd>(
      future: nativeAdCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<BannerAd> snapshot) {
        Widget child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            child = Container();
            break;
          case ConnectionState.waiting:
            child = Container();
            break;
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: bannerAd);
            } else {
              child = const Text('Error loading ad');
            }
        }
        return child;
      },
    );
  }
}

Future<List<String>> getListType(String type) async {
  List<String> findList = <String>[];
  for (var i=0;i<box.length;i++){
    var nowWord = await box.getAt(i);
    if (nowWord['type'].startsWith(type) || nowWord['type'].contains(' $type')){
      findList.add(nowWord['word']);
    }
  }
  findList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return findList;
}

Future<List<String>> getListCategory(String category) async {
  List<String> findList = <String>[];
  for (var i=0;i<box.length;i++){
    var nowWord = await box.getAt(i);
    if (category == 'no category'){
      if (nowWord['category'] == ','){
        findList.add(nowWord['word']);
      }
    }else{
      if (nowWord['category'].contains(','+ category)){
        findList.add(nowWord['word']);
      }
    }
  }
  findList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return findList;
}

List laytuloai(String kyhieu){
  var tuloai = [];
  switch(kyhieu) {
    case '1':
      tuloai.add('NOUN');
      tuloai.add('DANH TỪ');
      break;
    case '2':
      tuloai.add('VERB');
      tuloai.add('ĐỘNG TỪ');
      break;
    case '3':
      tuloai.add('ADJECTIVE');
      tuloai.add('TÍNH TỪ');
      break;
    case '4':
      tuloai.add('ADVERB');
      tuloai.add('TRẠNG TỪ');
      break;
    case '5':
      tuloai.add('PRONOUN');
      tuloai.add('ĐẠI TỪ');
      break;
    case '6':
      tuloai.add('ABBREVIATION');
      tuloai.add('TỪ VIẾT TẮT');
      break;
    case '7':
      tuloai.add('EXCLAMATION');
      tuloai.add('TỪ CẢM THÁN');
      break;
    case '8':
      tuloai.add('PREPOSITION');
      tuloai.add('GIỚI TỪ');
      break;
    case '9':
      tuloai.add('CONJUNCTION');
      tuloai.add('LIÊN TỪ');
      break;
    case '0':
      tuloai.add('NOUN & VERB');
      tuloai.add('DANH TỪ VÀ ĐỘNG TỪ');
      break;
    case 'a':
      tuloai.add('ADJECTIVE & ADVERB');
      tuloai.add('TÍNH TỪ VÀ TRẠNG TỪ');
      break;
    case 'b':
      tuloai.add('ADVERB & CONJUNCTION');
      tuloai.add('TRẠNG TỪ VÀ LIÊN TỪ');
      break;
    case 'c':
      tuloai.add('PRONOUN, DETERMINER & ADJECTIVE');
      tuloai.add('ĐẠI TỪ, TỪ HẠN ĐỊNH VÀ TÍNH TỪ');
      break;
    case 'd':
      tuloai.add('DETERMINER, PREDETERMINER & PRONOUN');
      tuloai.add('TỪ HẠN ĐỊNH, TỪ CHỈ ĐỊNH VÀ ĐẠI TỪ');
      break;
    case 'e':
      tuloai.add('POSSESSIVE DETERMINER');
      tuloai.add('TỪ HẠN ĐỊNH SỞ HỮU');
      break;
    case 'f':
      tuloai.add('POSSESSIVE PRONOUN');
      tuloai.add('ĐẠI TỪ SỞ HỮU');
      break;
    case 'g':
      tuloai.add('NOUN, ADJECTIVE & ADVERB');
      tuloai.add('DANH TỪ, TÌNH TỪ VÀ TRẠNG TỪ');
      break;
    case 'h':
      tuloai.add('PHRASE');
      tuloai.add('CỤM TỪ');
      break;
    case 'i':
      tuloai.add('CONTRACTION');
      tuloai.add('TỪ RÚT GỌN');
      break;
    case 'j':
      tuloai.add('PREPOSITION & CONJUNCTION');
      tuloai.add('GIỚI TỪ VÀ LIÊN TỪ');
      break;
    case 'k':
      tuloai.add('NOUN, VERB & ADJECTIVE');
      tuloai.add('DANH TỪ, ĐỘNG TỪ VÀ GIỚI TỪ');
      break;
    case 'l':
      tuloai.add('MODAL VERB');
      tuloai.add('ĐỘNG TỪ KHIẾM KHUYẾT');
      break;
    case 'm':
      tuloai.add('DETERMINER');
      tuloai.add('TỪ HẠN ĐỊNH');
      break;
    case 'n':
      tuloai.add('CARDINAL NUMBER');
      tuloai.add('SỐ ĐẾM');
      break;
    case 'o':
      tuloai.add('ORDINAL NUMBER');
      tuloai.add('SỐ THỨ TỰ');
      break;
    case 'p':
      tuloai.add('ADVERB & PREPOSITION');
      tuloai.add('TRẠNG TỪ VÀ GIỚI TỪ');
      break;
    case 'q':
      tuloai.add('ADVERB, PREPOSITION & CONJUNCTION');
      tuloai.add('TRẠNG TỪ, GIỚI TỪ VÀ LIÊN TỪ');
      break;
    case 'r':
      tuloai.add('DETERMINER & PRONOUN');
      tuloai.add('TỪ HẠN ĐỊNH VÀ TRẠNG TỪ');
      break;
    case 's':
      tuloai.add('INFINITIVE PARTICLE');
      tuloai.add('TIỂU TỪ NGUYÊN MẪU');
      break;
    case 'u':
      tuloai.add('PREDETERMINER');
      tuloai.add('TỪ CHỈ ĐỊNH');
      break;
    case 'v':
      tuloai.add('AUXILIARY VERB');
      tuloai.add('TRỢ ĐỘNG TỪ');
      break;
    case 'w':
      tuloai.add('INTERROGATIVE ADVERB');
      tuloai.add('TRẠNG TỪ NGHI VẤN');
      break;
    case 'x':
      tuloai.add('NOUN & EXCLAMATION');
      tuloai.add('DANH TỪ VÀ TỪ CẢM THÁN');
      break;
    case 'y':
      tuloai.add('RELATIVE PRONOUN & DETERMINER');
      tuloai.add('ĐẠI TỪ QUAN HỆ VÀ TỪ HẠN ĐỊNH');
      break;
    case 'z':
      tuloai.add('INTERROGATIVE PRONOUN');
      tuloai.add('ĐẠI TỪ NGHI VẤN');
      break;
    case 'J':
      tuloai.add('ADJECTIVE, PREDETERMINER & PRONOUN');
      tuloai.add('TÍNH TỪ, TỪ CHỈ ĐỊNH VÀ ĐẠI TỪ');
      break;
    case 'K':
      tuloai.add('ADJECTIVE & DETERMINER');
      tuloai.add('TÍNH TỪ VÀ TỪ HẠN ĐỊNH');
      break;
    case 'B':
      tuloai.add('RELATIVE PRONOUN');
      tuloai.add('ĐẠI TỪ QUAN HỆ');
      break;
    case 'W':
      tuloai.add('RELATIVE ADVERB');
      tuloai.add('TRẠNG TỪ QUAN HỆ');
      break;
    case 'R':
      tuloai.add('DETERMINER & INTERROGATIVE PRONOUN');
      tuloai.add('TỪ HẠN ĐỊNH VÀ ĐẠI TỪ NGHI VẤN');
      break;
    default:
    // code block
  }
  return tuloai;
}

void getNextLearn() {
  final Controller c = Get.put(Controller());
  if (!c.isAdShowing.value){
    void toScore() {
      c.isAdShowing = false.obs;
      if (c.currentTab.value<3){
        c.currentTab = RxInt(c.currentTab.value+1);
      }else{
        c.currentTab = 0.obs;
      }
      c.update();
    }
    int isShow = Random().nextInt(showAdFrequency);
    if (isShow == 0 && !c.isVip.value){
      c.isAdShowing = true.obs;
      InterstitialAd.load(
          adUnitId: Platform.isAndroid ? androidAd:iosAd,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              // Keep a reference to the ad so you can show it later.
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (InterstitialAd ad) {},
                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                  ad.dispose();
                  toScore();
                },
                onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                  ad.dispose();
                  toScore();
                },
                onAdImpression: (InterstitialAd ad) {},
              );
              ad.show();
            },
            onAdFailedToLoad: (LoadAdError error) {
              toScore();
            },
          )
      );
    }else{
      toScore();
    }
  }
}

void getPreviousLearn() {
  final Controller c = Get.put(Controller());
  if (!c.isAdShowing.value){
    void toScore() {
      c.isAdShowing = false.obs;
      if (c.currentTab.value>0){
        c.currentTab = RxInt(c.currentTab.value-1);
      }else{
        c.currentTab = 3.obs;
      }
      c.update();
    }
    int isShow = Random().nextInt(showAdFrequency);
    if (isShow == 0 && !c.isVip.value){
      c.isAdShowing = true.obs;
      InterstitialAd.load(
          adUnitId: Platform.isAndroid ? androidAd:iosAd,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              // Keep a reference to the ad so you can show it later.
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (InterstitialAd ad) {},
                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                  ad.dispose();
                  toScore();
                },
                onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                  ad.dispose();
                  toScore();
                },
                onAdImpression: (InterstitialAd ad) {},
              );
              ad.show();
            },
            onAdFailedToLoad: (LoadAdError error) {
              toScore();
            },
          )
      );
    }else{
      toScore();
    }
  }
}

Future _speak(String string) async{
  final Controller c = Get.put(Controller());
  await flutterTts.setLanguage("en-US");
  await flutterTts.setSpeechRate(c.speakSpeed.value);
  // await flutterTts.setVolume(1.0);
  // await flutterTts.setPitch(1.0);
  await flutterTts.awaitSpeakCompletion(true);
  await flutterTts.speak(string);
}

Future setRight() async {
  final Controller c = Get.put(Controller());
  c.learnRight = true.obs;
  c.right = true.obs;
  c.update();
  if (c.enableSound.value){
    await pool.play(soundIdRight);
  }
  await Future.delayed(const Duration(milliseconds:1000));
  c.learnRight = false.obs;
  c.update();
}

Future setWrong() async {
  final Controller c = Get.put(Controller());
  c.learnRight = true.obs;
  c.right = false.obs;
  c.update();
  if (c.enableSound.value){
    await pool.play(soundIdWrong);
  }
  await Future.delayed(const Duration(milliseconds:1000));
  c.learnRight = false.obs;
  c.update();
}

bool checkSubMean(List<String> subMean){
  final Controller c = Get.put(Controller());
  bool ktCategory = false;
  bool ktType = false;
  for(var j = 0; j< subMean.length; j++) {
    if (c.category.string != 'all category' && c.category.string != 'no category'){
      if (subMean[j].contains('#')){
        if(subMean[j].split('#')[0].split(',').contains(c.category.string)){
          ktCategory = true;
        }
      }
    }else{
      ktCategory = true;
    }
    if (c.type.string != 'all type'){
      var currentType = laytuloai(subMean[j].substring(subMean[j].length-1));
      if (c.type.string.contains(' ')){
        if (currentType[0].toLowerCase().contains(c.type.string)){
          ktType = true;
        }
      }else{
        if (currentType[0].toLowerCase().split(' ').contains(c.type.string)){
          ktType = true;
        }
      }
    }else{
      ktType = true;
    }
    if (ktCategory && ktType){
      break;
    }
  }
  if (ktCategory && ktType){
    return true;
  }else{
    return false;
  }
}

Future insertHistory(String wordSearch) async {
  if (wordSearch != ''){
    await boxHistory.put(DateTime.now().toString(),[DateTime.now().millisecondsSinceEpoch,wordSearch]);
  }
}

Future<List<History>> getHistory(int start, int end) async {
  final Controller c = Get.put(Controller());
  List<History> findList = <History>[];
  for (var i=0;i<boxHistory.length;i++){
    var nowWord = await boxHistory.getAt(i);
    if (nowWord[0] > start && nowWord[0] < end){
      c.lastHistoryIndex = RxInt(i);
      findList.add(History(word: nowWord[1], time: nowWord[0]));
    }
  }
  findList.sort((a, b) => b.time.compareTo(a.time));
  return findList;
}

Future<List<String>> getLastSearch() async {
  final Controller c = Get.put(Controller());
  List<String> findList = <String>[];
  bool kt = true;
  int i = boxHistory.length-1;
  if (i<0) kt = false;
  while (kt){
    var nowWord = await boxHistory.getAt(i);
    if (c.wordArray.contains(nowWord[1]) && (!findList.contains(nowWord[1]))){
      findList.add(nowWord[1]);
    }
    i = i-1;
    if (i<0 || findList.length>9){
      kt = false;
    }
  }
  return findList;
}

Future<String> getLastSearchWord() async {
  final Controller c = Get.put(Controller());
  String find = '';
  bool kt = true;
  int i = boxHistory.length-1;
  if (i<0) kt = false;
  while (kt){
    var nowWord = await boxHistory.getAt(i);
    if (c.wordArray.contains(nowWord[1])){
      find = nowWord[1];
    }
    i = i-1;
    if (i<0 || find != ''){
      kt = false;
    }
  }
  return find;
}

Future<Score> getScore(String wordScore) async {
  List score = await boxScore.get(wordScore);
  return Score(
    wordId: score[0],
    word: score[1],
    pronun: score[2],
    speak: score[3],
    mean: score[4],
    total: score[5],
    time: score[6],
  );
}

Future<List<String>> getListScore() async {
  final Controller c = Get.put(Controller());
  List<String> findList = <String>[];
  for (var i=0;i<c.listWordScore.length;i++){
    var nowWord = await boxScore.get(c.listWordScore[i]);
    if (nowWord[5]>0){
      findList.add(nowWord[0]);
    }
  }
  return findList;
}

Future<List<Score>> getListScoreTime(int start,int end) async {
  List<Score> findList = <Score>[];
  for (var i=0;i<boxScore.length;i++){
    var nowWord = await boxScore.getAt(i);
    if (nowWord[6] > start && nowWord[6] < end && nowWord[5]>0){
      findList.add(Score(
          wordId: nowWord[0],
          word: nowWord[1],
          pronun: nowWord[2],
          speak: nowWord[3],
          mean: nowWord[4],
          total: nowWord[5],
          time: nowWord[6])
      );
    }
  }
  findList.sort((a, b) => b.total.compareTo(a.total));
  return findList;
}

Future updateScore(Score dataScore) async {
  await boxScore.put(dataScore.wordId,[
    dataScore.wordId,
    dataScore.word,
    dataScore.pronun,
    dataScore.speak,
    dataScore.mean,
    dataScore.total,
    DateTime.now().millisecondsSinceEpoch
  ]);
}

class Score {
  final String wordId;
  final int word;
  final int pronun;
  final int speak;
  final int mean;
  final int total;
  final int time;

  Score({
    required this.wordId,
    required this.word,
    required this.pronun,
    required this.speak,
    required this.mean,
    required this.total,
    required this.time,
  });
  Map<String, dynamic> toMap() {
    return {
      'wordId': wordId,
      'word': word,
      'pronun': pronun,
      'speak': speak,
      'mean': mean,
      'total': total,
      'time': time,
    };
  }
  @override
  String toString() {
    return 'Dog{wordId: $wordId, word: $word, pronun: $pronun, speak: $speak, mean: $mean, total: $total, time: $time}';
  }
}

class History {
  final int time;
  final String word;

  History({
    required this.time,
    required this.word,
  });
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'word': word,
    };
  }
  @override
  String toString() {
    return 'History{time: $time, word: $word}';
  }
}

Future showNotification() async {
  final Controller c = Get.put(Controller());
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 0,
      channelKey: 'daily',
      title: 'Daily',
      body: 'Time to learn',
    ),
    schedule: NotificationCalendar(
      second: 0, millisecond: 0,
      minute: int.parse(c.selectedTime.string.split(":")[1]),
      hour: int.parse(c.selectedTime.string.split(":")[0]),
      timeZone: localTimeZone, repeats: true,
      allowWhileIdle: true,
    )
  );
}

Future<List<String>> getScoreNotification() async {
  List<String> findList = <String>[];
  List findListScore = [];
  for (var i=0;i<boxScore.length;i++){
    var nowWord = await boxScore.getAt(i);
    if (nowWord[5]>0) findListScore.add(nowWord);
  }
  findListScore.sort((a, b) => a[5].compareTo(b[5]));
  for (var i=0;i<(findListScore.length<10?findListScore.length:10);i++){
    if (!findList.contains(findListScore[i][0])) {
      findList.add(findListScore[i][0]);
    }
  }
  findListScore.sort((a, b) => a[6].compareTo(b[6]));
  for (var i=0;i<(findListScore.length<10?findListScore.length:10);i++){
    if (!findList.contains(findListScore[i][0])) {
      findList.add(findListScore[i][0]);
    }
  }
  return findList;
}

Future showNotificationWord() async {
  List<String> listWord = await getScoreNotification();
  if (listWord.isNotEmpty){
    final Controller c = Get.put(Controller());
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    for (var i=0;i<=960;i+=c.notificationInterval.value){
      var dataRaw = await box.get(listWord[Random().nextInt(listWord.length)]);
      var randomMean = Random().nextInt(jsonDecode(dataRaw['mean']).length);
      List listMean = jsonDecode(dataRaw['mean'])[randomMean];
      List meanENAdd = [];
      List meanVNAdd = [];
      for(var j = 0; j< listMean.length; j++) {
        String meanENElement = '';
        if(listMean[j].contains('#')){
          meanENElement = listMean[j].split('#')[1];
        }else{
          meanENElement = listMean[j];
        }
        meanENAdd.add(meanENElement);
        String meanVNElement = jsonDecode(dataRaw['meanVN'])[randomMean][j];
        meanVNElement = meanVNElement.substring(0,meanVNElement.length - 2);
        meanVNElement = meanVNElement + listMean[j].substring(listMean[j].length-1);
        meanVNAdd.add(meanVNElement);
      }
      String meanEN = '';
      String meanVN = '';
      String mean = '';
      for(var j = 0; j< meanENAdd.length; j++) {
        if (j==0){
          meanVN = meanVN + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
          meanEN = meanEN + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
        }else{
          meanVN = meanVN + ' | ' + meanVNAdd[j].substring(0,meanVNAdd[j].length - 1);
          meanEN = meanEN + ' | ' + meanENAdd[j].substring(0,meanENAdd[j].length - 1);
        }
      }
      if (c.language.string == 'VN'){
        mean = meanVN;
      }else{
        mean = meanEN;
      }
      String image = '';
      if (randomMean>=jsonDecode(dataRaw['imageURL']).length){
        image = 'https://bedict.com/bedict.png';
      }else{
        image = 'https://bedict.com/' + jsonDecode(dataRaw['imageURL'])[randomMean];
      }
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: i,
            channelKey: 'word',
            title: dataRaw['word'],
            body: mean,
            bigPicture: image,
            largeIcon: image,
            hideLargeIconOnExpand: true,
            notificationLayout: NotificationLayout.BigPicture,
          ),
          schedule: NotificationCalendar(
            second: 0, millisecond: 0,
            minute: i % 60,
            hour: 6 + i ~/ 60,
            timeZone: localTimeZone, repeats: true,
            allowWhileIdle: true,
          )
      );
    }
  }
}

Future showWord(String wordShow) async {
  if (wordShow != 'Daily' && wordShow != ''){
    final Controller c = Get.put(Controller());
    c.category = RxString('all category');
    c.type = RxString('all type');
    c.word = RxString(wordShow);
    await c.layWord(c.word.string);
    Get.offAll(()=> Home());
  }else{
    Get.offAll(()=> MainScreen());
  }
}