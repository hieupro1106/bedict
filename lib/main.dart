import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:ui';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
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
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soundpool/soundpool.dart';

List<String> listCategoryVN = ["chủ đề","khả năng","trừu tượng","thành tích","hành động","tuổi tác","nông nghiệp",
"trợ giúp","số lượng","giải phẫu","động vật","vẻ ngoài","khảo cổ học","kiến trúc","khu vực",
"nghệ thuật","khía cạnh","tài sản","chiêm tinh học","thiên văn học","thái độ","thực thể",
"rung chuông","cá cược","hoá sinh học","sinh học","chim","cơ thể","nhà cửa","việc làm ăn",
"tính cách","hoá học","màu sắc","thương mại","liên lạc","hỗn hợp","máy tính","điều kiện",
"châu lục","văn hoá","chửi thề","nhảy","mức độ","nhu cầu","thiết bị","hướng","thảm hoạ",
"bệnh tật","học thuyết","uống","sinh thái học","kinh tế","giáo dục","điện","điện tử",
"nguyên tố","cảm xúc","năng lượng","giải trí","môi trường","sự kiện","câu cảm thán",
"gia đình","lễ hội","hình khối","tài chính","cá","đồ ăn","frequency","fruit","fuel",
"function","future","trò chơi","khoảng trống","địa lý","địa chất","nhà nước","ngữ pháp",
"nhóm","vi phạm","huy hiệu","lịch sử","kỳ nghỉ","công nghiệp","thông tin","thực thể khác người",
"côn trùng","bảo hiểm","mạng internet","vật thể","nghề nghiệp","ngôn ngữ","luật pháp",
"ngôn ngữ học","danh sách","văn học","logic","máy móc","dấu, dấu vết","đống","vật liệu",
"toán học","truyền thông","y tế","vi sinh vật","quân đội","tâm trí","khoáng chất","đạo đức",
"âm nhạc","thần thoại","quốc gia","tự nhiên","hàng hải","phủ định","không gì","hiện tại","con số",
"đại dương","thứ tự","sinh vật","tổ chức","kết quả","thành phần","quá khứ","quá khứ hoàn thành",
"quãng, giai đoạn","người","hiện tượng","triết học","ngữ âm","cụm từ","vật lý","sinh lý học",
"địa điểm","kế hoạch","cây cối","điểm","cảnh sát","chính trị","vị trí","khả năng xảy ra",
"quá trình","đặc điểm","tính chất","chủng tộc","ngưỡng","tôn giáo","quyền","nghi lễ","hoàng gia",
"thuyền buồm","khoa học","hạt","cảm giác","dịch vụ","tình dục, giới tính","tín hiệu","tình thế",
"xã hội","linh hồn","âm thanh","vũ trụ, không gian","thể thao","sân khấu","trạng thái","câu nói",
"văn phòng phẩm","thống kê","câu chuyện","cấu trúc","phong cách","vật chất","chịu đựng",
"siêu nhiên","hệ thống","kỹ thuật","công nghệ","xu hướng","thần học","giả thuyết, lý thuyết",
"sự vật","thời gian","tiêu đề","truyền thống","giao thông","loại, kiểu","đơn vị","đồ dùng",
"tiện ích","giá trị","rau củ","phương tiện","vi rút","chiến tranh","cách thức","vũ khí",
"trang phục","thời tiết","từ","công việc","thế giới","viết lách"];
List<String> listCategoryEN = ["category","ability","abstract","achievement",
"action","age","agriculture","aid","amount","anatomy","animal",
"appearance","archaeology","architecture","area","art",
"aspect","asset","astrology","astronomy","attitude","being","bell-ringing",
"bet","biochemistry","biology","bird","body","building","business",
"character","chemistry","color","commerce","communication",
"compound","computing","condition","continent",
"culture","curse","dance","degree","demand","device","direction",
"disaster","disease","doctrine","drink","ecology","economy","education","electric",
"electronics","element","emotion","energy","entertainment","environment",
"event","exclamation","family","festival",
"figure","finance","fish","food","frequency","fruit","fuel","function","future",
"game","gap","geography","geology","government","grammar","group","guilt","heraldry",
"history","holiday","industry","info","inhuman","insect","insurance","internet",
"item","job","language","law","linguistics","list","literature","logic",
"machine","mark","mass","material","math","media","medicine",
"microorganism","military","mind","mineral","moral",
"music","mythology","nation","nature","nautical","negative","nothing","now","number","ocean",
"organ","organism","organization","outcome","part","past","past participle",
"period","person","phenomena","philosophy","phonetics",
"phrase","physics","physiology","place","plan","plant","point","police","politics",
"position","possibility","process","property",
"quality","race","range","religion","right","ritual","royal","sailing",
"science","seed","sensation","service","sex","signal","situation",
"society","soul","sound","space","sport","stage",
"state","statement","stationery","statistics","story","structure","style","substance",
"suffering","supernatural","system","technical","technology","tendency","theology",
"theory","thing","time","title","tradition","traffic","type","unit","utensil","utility","value",
"vegetable","vehicle","virus","war","way","weapon","wear","weather","word","work","world","writing"];

List<String> listLevelVN = ['tất cả từ', '8.000 từ','5.000 từ','3.000 từ'];
List<String> listLevelEN = ['all words', '8.000 words','5.000 words','3.000 words'];

List<String> listTypeVN = ["từ loại","danh từ","động từ","tính từ","trạng từ","đại từ","từ viết tắt", "từ cảm thán",
  "giới từ","liên từ", "từ hạn định sở hữu","đại từ sở hữu","cụm từ","từ rút gọn",
  "động từ khiếm khuyết","từ hạn định","số đếm","số thứ tự",
  "tiểu từ nguyên mẫu", "từ chỉ định","trợ động từ","trạng từ nghi vấn",
  "đại từ nghi vấn","đại từ quan hệ","trạng từ quan hệ"];
List<String> listTypeEN = ["type","noun","verb","adjective","adverb","pronoun","abbreviation","exclamation",
  "preposition","conjunction", "possessive determiner","possessive pronoun","phrase","contraction",
  "modal verb","determiner","cardinal number","ordinal number",
  "infinitive particle","predeterminer","auxiliary verb","interrogative adverb",
  "interrogative pronoun","relative pronoun","relative adverb"];

const textColor = Color.fromRGBO(3, 64, 24, 1);
const backgroundColor = Color.fromRGBO(147, 219, 172, 1);
const themeColor = Color.fromRGBO(230, 255, 240, 1);

final Soundpool pool = Soundpool.fromOptions();
late int soundId;

int initLanguageIndex = 0;
double statusBarHeight = 0.0;
ScrollController scrollController = ScrollController();

final searchField = TextEditingController();

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NativeAdState();
}

class NativeAdState extends State<NativeAdWidget> {
  late NativeAd _nativeAd;
  // final Completer<NativeAd> nativeAdCompleter = Completer<NativeAd>();

  @override
  void initState() {
    super.initState();

    _nativeAd = NativeAd(
      adUnitId: Platform.isAndroid ? 'ca-app-pub-3940256099942544/2247696110' : 'ca-app-pub-3940256099942544/3986624511',
      request: const AdRequest(),
      factoryId: 'listTile',
      listener: NativeAdListener(
        // onAdLoaded: (Ad ad) {
        //   nativeAdCompleter.complete(ad as NativeAd);
        // },
        // onAdFailedToLoad: (Ad ad, LoadAdError err) {
        //   ad.dispose();
        // },
        // onAdOpened: (Ad ad) => {},
        // onAdClosed: (Ad ad) => {},
      ),
    );

    _nativeAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd.dispose();
  }

  @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<NativeAd>(
  //     future: nativeAdCompleter.future,
  //     builder: (BuildContext context, AsyncSnapshot<NativeAd> snapshot) {
  //       Widget child;
  //
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.none:
  //         case ConnectionState.waiting:
  //         case ConnectionState.active:
  //           child = Container();
  //           break;
  //         case ConnectionState.done:
  //           if (snapshot.hasData) {
  //             child = AdWidget(ad: _nativeAd);
  //           } else {
  //             child = const Text('Error loading ad');
  //           }
  //       }
  //       return child;
  //     },
  //   );
  Widget build(BuildContext context) {
    return AdWidget(ad: _nativeAd);
  }
}

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
  var box = await Hive.openBox('setting');

  var initLanguage = await box.get('language') ?? 'VN';
  if (initLanguage == 'VN'){
    initLanguageIndex = 0;
  }else{
    initLanguageIndex = 1;
  }

  c.notifyDaily = RxBool(await box.get('notifyDaily') ?? false);
  c.selectedTime = RxString(await box.get('timeDaily') ?? '20:00');
  c.notifyWord = RxBool(await box.get('notifyWord') ?? false);
  if (c.notifyWord.value){
    for (var i=1;i<18;i++){
      await AwesomeNotifications().dismiss(i);
      await AwesomeNotifications().cancelSchedule(i);
    }
    showNotificationWord();
  }
  c.listWordsToday = jsonDecode(await box.get("listWordsToday")?? '[]').cast<String>();
  c.category = RxString(listCategoryEN[await box.get('category') ?? 0]);
  c.type = RxString(listTypeEN[await box.get('type') ?? 0]);
  c.level = RxString(listLevelEN[await box.get('level') ?? 0]);
  c.word = RxString(await box.get('word') ?? c.word.string);
  c.speakSpeed = RxDouble(await box.get('speakSpeed') ?? 0.3);
  c.target = RxInt(await box.get('target') ?? 10);
  c.language = RxString(await box.get('language') ?? c.language.string);
  c.categoryIndex = RxInt(await box.get('category') ?? 0);
  c.typeIndex = RxInt(await box.get('type') ?? 0);
  c.levelIndex = RxInt(await box.get('level') ?? 0);
  if (c.language.string == 'VN'){
    c.listCategory = listCategoryVN;
    c.listType = listTypeVN;
    c.listLevel = listLevelVN;
  }else{
    c.listCategory = listCategoryEN;
    c.listType = listTypeEN;
    c.listLevel = listLevelEN;
  }

  bool isIntroduce = await box.get('isIntroduce') ?? true;
  await box.close();
  runApp(
    GetMaterialApp(
      title: "BeDict",
      home: isIntroduce? const WelcomePage(): Home(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class Controller extends GetxController{
  @override
  void onClose() {
    pool.dispose();
    super.onClose();
  }
  var imageShow = 1.obs;
  List<String> listRandom = <String>[].obs;
  List<String> listArrange = <String>[].obs;
  List<String> listRandomPronun = <String>[].obs;
  List<String> listArrangePronun = <String>[].obs;
  var enableSound = true.obs;
  var speechEnabled = false.obs;
  var initSpeak = true.obs;
  var imageWidth = 150.0.obs;
  var initState = true.obs;
  var language = 'VN'.obs;
  var locale = 'en-US'.obs;
  var listenString = ''.obs;
  var nowIndex = 0.obs;
  List mean = [].obs;
  List meanVN = [].obs;
  List meanEN = [].obs;
  List imageURL = [].obs;
  var firstMean = 0.obs;
  List<bool> listCheckMean = <bool>[].obs;
  List<List> listImage = <List>[].obs;
  List<int> listIndex = <int>[].obs;
  var word = 'hello'.obs;
  var typeState = 0.obs;
  var pronun = ''.obs;

  var category = 'category'.obs;
  var categoryIndex = 0.obs;
  List<String> listCategory = listCategoryVN.obs;

  var type = 'type'.obs;
  var typeIndex = 0.obs;
  List<String> listType = listTypeVN.obs;

  var level = 'tất cả từ'.obs;
  var levelIndex = 0.obs;
  List<String> listLevel = listLevelVN.obs;

  var focusedIndex = 0.obs;
  List<String> wordArray = <String>[].obs;
  List<String> wordsPrevious = <String>[].obs;
  List<String> wordsNext = <String>[].obs;
  var currentTab = 0.obs;

  var wordScore = 0.obs;
  var pronunScore = 0.obs;
  var speakScore = 0.obs;
  var meanScore = 0.obs;

  var duration = 86400000;
  List<History> listHistory = <History> [].obs;
  List<Score> listLearned = <Score> [].obs;
  List<Score> listLearnedToday = <Score> [].obs;
  List<String> listWordsToday = <String> [].obs;

  var notifyDaily = false.obs;
  var notifyWord = false.obs;
  var selectedTime = '20:00'.obs;
  var target = 10.obs;
  var adIndex = 0.obs;

  var speakSpeed = 0.3.obs;

  onItemFocus (int index){
    focusedIndex = RxInt(index);
  }

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
  var learnRightTitle = 'Chúc mừng!'.obs;
  var learnRightBody = 'Bạn đã nhập đúng'.obs;
  var learnRightBodySpeak = 'Bạn đã phát âm đúng'.obs;
  var learnWrongTitle = 'Rất tiếc!'.obs;
  var learnWrongBody = 'Bạn đã nhập sai'.obs;
  var learnWrongBodySpeak = 'Bạn chưa phát âm đúng'.obs;
  var learnWrongBodyMean = 'Bạn chưa chọn đúng'.obs;
  var learnReset = 'đặt lại'.obs;
  var learnPrevious = 'trước'.obs;
  var learnMeanGuide = 'gõ vào ảnh tương ứng với nghĩa'.obs;
  var learnNext = 'tiếp'.obs;
  var learnRightBodyMean = 'Bạn đã chọn đúng'.obs;
  var learnRightBodyAllMean = 'Bạn đã chọn đúng tất cả các nghĩa'.obs;
  var learnRightBodyAllMeanDone = 'Bạn đã hoàn toàn nắm rõ nghĩa'.obs;
  var learnRightBodyAllWord = 'Bạn đã hoàn toàn thuộc từ'.obs;
  var learnRightBodyAllPronun = 'Bạn đã hoàn toàn thuộc phát âm'.obs;
  var learnRightBodyAllSpeak = 'Bạn đã hoàn toàn phát âm chuẩn'.obs;
  var day = 'Ngày'.obs;
  var week = 'Tuần'.obs;
  var month = 'Tháng'.obs;
  var year = 'Năm'.obs;
  var all = 'Tất cả'.obs;
  var relearnButton = 'ôn tập'.obs;
  var scoreId = 'Từ'.obs;
  var scoreWord = 'Viết'.obs;
  var scorePronun = 'Âm'.obs;
  var scoreSpeak = 'Nói'.obs;
  var scoreMean = 'Nghĩa'.obs;
  var scoreTotal = 'Tổng'.obs;
  var hint = 'tìm kiếm...'.obs;
  var notFound = 'không tìm thấy'.obs;
  var snackbarFindTitle = 'Chưa được!'.obs;
  var snackbarFindBody = 'Bạn cần chọn từ để học trước'.obs;
  var snackbarRelearn = 'Không có từ để ôn tập'.obs;
  var learnedWordsTodayTitle = 'mục tiêu:'.obs;
  var newRandomWordTitle = 'từ khác'.obs;
  var adTitle = 'QUẢNG CÁO'.obs;
  var adBody = 'Quảng cáo giúp ứng dụng miễn phí'.obs;
  var loadingBody = 'Đang tải từ điển, vui lòng đợi trong giây lát'.obs;
  var loadingFailTitle = 'Tải lỗi'.obs;
  var loadingFailBody = 'Đảm bảo có kết nối Internet, vui lòng tải lại sau'.obs;
  var welcomeBody = 'Chào mừng bạn đến với BeDict - từ điển thú vị nhất trên thế giới'.obs;
  var introduce0Title = 'Giao diện chính'.obs;
  var introduce0Body = 'Dễ dàng hiểu nghĩa với hình ảnh minh họa sinh động'.obs;
  var introduce1Title = 'Phân loại'.obs;
  var introduce1Body = 'Lựa chọn từ theo cách bạn muốn, '
      'chúng tôi phân loại từ theo chủ đề, loại từ, các gói 3000, 5000, 8000 từ phổ biến nhất'.obs;
  var introduce2Title = 'Học nghe, nói, đọc, viết'.obs;
  var introduce2Body = 'Học mà chơi, chơi mà học, thư giãn với BeDict lúc bạn rảnh rỗi,'
      ' những trò chơi được thiết kế đơn giản nhưng giúp bạn nắm vững 04 kỹ năng nghe, nói, đọc, viết'.obs;
  var introduce3Title = 'Học qua thông báo'.obs;
  var introduce3Body = 'Bạn không cần phải vào ứng dụng, thông báo với hình ảnh đầy đủ sẽ giúp bạn'.obs;

  changeLanguage(String newLanguage) async {
    var box = await Hive.openBox('setting');
    language = RxString(newLanguage);
    if (language.string == 'VN'){
      initLanguageIndex = 0;
      await box.put('language','VN');
      listCategory = listCategoryVN.obs;
      listType = listTypeVN.obs;
      listLevel = listLevelVN.obs;
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
      learnRightTitle = 'Chúc mừng!'.obs;
      learnRightBody = 'Bạn đã nhập đúng'.obs;
      learnRightBodySpeak = 'Bạn đã phát âm đúng'.obs;
      learnWrongTitle = 'Rất tiếc!'.obs;
      learnWrongBody = 'Bạn đã nhập sai'.obs;
      learnWrongBodySpeak = 'Bạn chưa phát âm đúng'.obs;
      learnWrongBodyMean = 'Bạn chưa chọn đúng'.obs;
      learnReset = 'đặt lại'.obs;
      learnPrevious = 'trước'.obs;
      learnMeanGuide = 'gõ vào ảnh tương ứng với nghĩa'.obs;
      learnNext = 'tiếp'.obs;
      learnRightBodyMean = 'Bạn đã chọn đúng'.obs;
      learnRightBodyAllMean = 'Bạn đã chọn đúng tất cả các nghĩa'.obs;
      learnRightBodyAllMeanDone = 'Bạn đã hoàn toàn nắm rõ nghĩa'.obs;
      learnRightBodyAllWord = 'Bạn đã hoàn toàn thuộc từ'.obs;
      learnRightBodyAllPronun = 'Bạn đã hoàn toàn thuộc phát âm'.obs;
      learnRightBodyAllSpeak = 'Bạn đã hoàn toàn phát âm chuẩn'.obs;
      learnedWordsTodayTitle = 'mục tiêu:'.obs;
      newRandomWordTitle = 'từ khác'.obs;
      day = 'Ngày'.obs;
      week = 'Tuần'.obs;
      month = 'Tháng'.obs;
      year = 'Năm'.obs;
      all = 'Tất cả'.obs;
      relearnButton = 'ôn tập'.obs;
      scoreId = 'Từ'.obs;
      scoreWord = 'Viết'.obs;
      scorePronun = 'Âm'.obs;
      scoreSpeak = 'Nói'.obs;
      scoreMean = 'Nghĩa'.obs;
      scoreTotal = 'Tổng'.obs;
      hint = 'tìm kiếm...'.obs;
      notFound = 'không tìm thấy'.obs;
      snackbarFindTitle = 'Chưa được!'.obs;
      snackbarFindBody = 'Bạn cần chọn từ để học trước'.obs;
      snackbarRelearn = 'Không có từ để ôn tập'.obs;
      adTitle = 'QUẢNG CÁO'.obs;
      adBody = 'Quảng cáo giúp ứng dụng miễn phí'.obs;
      loadingBody = 'Đang tải từ điển, vui lòng đợi trong giây lát'.obs;
      loadingFailTitle = 'Tải lỗi'.obs;
      loadingFailBody = 'Đảm bảo có kết nối Internet, vui lòng tải lại sau'.obs;
      welcomeBody = 'Chào mừng bạn đến với BeDict - từ điển thú vị nhất trên thế giới'.obs;
      introduce0Title = 'Giao diện chính'.obs;
      introduce0Body = 'Dễ dàng hiểu nghĩa với hình ảnh minh họa sinh động'.obs;
      introduce1Title = 'Phân loại'.obs;
      introduce1Body = 'Lựa chọn từ theo cách bạn muốn, '
          'chúng tôi phân loại từ theo chủ đề, loại từ, các gói 3000, 5000, 8000 từ phổ biến nhất'.obs;
      introduce2Title = 'Học nghe, nói, đọc, viết'.obs;
      introduce2Body = 'Học mà chơi, chơi mà học, thư giãn với BeDict lúc bạn rảnh rỗi,'
          ' những trò chơi được thiết kế đơn giản nhưng giúp bạn nắm vững 04 kỹ năng nghe, nói, đọc, viết'.obs;
      introduce3Title = 'Học qua thông báo'.obs;
      introduce3Body = 'Bạn không cần phải vào ứng dụng, thông báo với hình ảnh đầy đủ sẽ giúp bạn'.obs;
    }else{
      initLanguageIndex = 1;
      await box.put('language','EN');
      listCategory = listCategoryEN.obs;
      listType = listTypeEN.obs;
      listLevel = listLevelEN.obs;
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
      learnRightTitle = 'Congratulation!'.obs;
      learnRightBody = 'You arranged right'.obs;
      learnRightBodySpeak = 'You spoke right'.obs;
      learnWrongBodyMean = 'You are not pick right'.obs;
      learnWrongTitle = 'Sorry!'.obs;
      learnWrongBody = 'You arranged wrong'.obs;
      learnWrongBodySpeak = 'You did not speak right'.obs;
      learnReset = 'reset'.obs;
      learnPrevious = 'previous'.obs;
      learnMeanGuide = 'tap the image fit following mean'.obs;
      learnNext = 'next'.obs;
      learnRightBodyMean = 'You picked the right one'.obs;
      learnRightBodyAllMean = 'You learned all meanings'.obs;
      learnRightBodyAllMeanDone = 'You all done learn meanings'.obs;
      learnRightBodyAllWord = 'You all done learn word'.obs;
      learnRightBodyAllPronun = 'You all done learn pronun'.obs;
      learnRightBodyAllSpeak = 'You all done learn speak'.obs;
      learnedWordsTodayTitle = 'target:'.obs;
      newRandomWordTitle = 'other word'.obs;
      day = 'Day'.obs;
      week = 'Week'.obs;
      month = 'Month'.obs;
      year = 'Year'.obs;
      all = 'All'.obs;
      relearnButton = 'relearn'.obs;
      scoreId = 'Word'.obs;
      scoreWord = 'Write'.obs;
      scorePronun = 'Pronun'.obs;
      scoreSpeak = 'Speak'.obs;
      scoreMean = 'Mean'.obs;
      scoreTotal = 'Total'.obs;
      hint = 'search...'.obs;
      notFound = 'not found'.obs;
      snackbarFindTitle = 'Not yet!'.obs;
      snackbarFindBody = 'Pick a word to learn first'.obs;
      snackbarRelearn = 'There are none words to relearn'.obs;
      adTitle = 'ADVERTISEMENT'.obs;
      adBody = 'Advertisement helps remaining this free app'.obs;
      loadingBody = 'Loading dictionary data, please wait a moment'.obs;
      loadingFailTitle = 'Fail'.obs;
      loadingFailBody = 'Make sure you have Internet connect, please try again later'.obs;
      welcomeBody = 'Welcome you to BeDict - most interesting dictionary in the world'.obs;
      introduce0Title = 'Main Screen'.obs;
      introduce0Body = 'Easy to learn meaning with our lively images'.obs;
      introduce1Title = 'Sort words'.obs;
      introduce1Body = 'Choose word as you want, '
          'we sort words by category, type, 3000, 5000, 8000 common bundles words'.obs;
      introduce2Title = 'Leaning listen, speak, read, write'.obs;
      introduce2Body = 'Leaning as playing, relaxing with BeDict,'
          ' the plays with simple design help you easy to learn listen, speak, read, write'.obs;
      introduce3Title = 'Learning through notification'.obs;
      introduce3Body = 'You don\'t need to go into app, notification with image will help you'.obs;
    }
    await box.close();
    update();
  }
  changeLevel(int index) async{
    bool check = await getListWords(listLevel[index],category.string,type.string);
    if (!check){
      Get.snackbar(learnWrongTitle.string,notFound.string);
    }else{
      var box = await Hive.openBox('setting');
      levelIndex = RxInt(index);
      level = RxString(listLevel[index]);
      await box.put('level',index);
      await box.close();
      word = ''.obs;
      await layWord(word.string);
    }
  }
  changeCategory(int index) async {
    var box = await Hive.openBox('setting');
    typeIndex = 0.obs;
    type = 'type'.obs;
    await box.put('type',0);
    bool check = await getListWords(level.string,listCategoryEN[index],type.string);
    if (!check){
      Get.snackbar(learnWrongTitle.string,notFound.string);
      update();
    }else{
      categoryIndex = RxInt(index);
      category = RxString(listCategoryEN[index]);
      await box.put('category',index);
      word = ''.obs;
      await layWord(word.string);
    }
    await box.close();
  }
  changeType(int index) async {
    var box = await Hive.openBox('setting');
    categoryIndex = 0.obs;
    category = 'category'.obs;
    await box.put('category',0);
    bool check = await getListWords(level.string,category.string,listTypeEN[index]);
    if (!check){
      Get.snackbar(learnWrongTitle.string,notFound.string);
      update();
    }else{
      typeIndex = RxInt(index);
      type = RxString(listTypeEN[index]);
      await box.put('type',index);
      word = ''.obs;
      await layWord(word.string);
    }
    await box.close();
  }
  Future layWord(String newWord) async {
    focusedIndex = 0.obs;
    var kt = false;
    for(var h = 0; h < wordArray.length; h++){
      if (wordArray[h].startsWith(newWord)){
        kt = true;
        word = RxString(wordArray[h]);
        var box = await Hive.openBox('setting');
        await box.put('word',word.string);
        await box.close();
        searchField.text = word.string;
        if (await checkScore(word.string)){
          Score currentScore = await getScore(word.string);
          wordScore = RxInt(currentScore.word);
          pronunScore = RxInt(currentScore.pronun);
          speakScore = RxInt(currentScore.speak);
          meanScore = RxInt(currentScore.mean);
        }else{
          wordScore = RxInt(0);
          pronunScore = RxInt(0);
          speakScore = RxInt(0);
          meanScore = RxInt(0);
        }
        await insertHistory(word.string);
        wordsNext.clear();
        for (var j=1;j<11;j++){
          if (h+j>=wordArray.length){
            break;
          }else{
            wordsNext.add(wordArray[h+j]);
          }
        }
        wordsPrevious.clear();
        for (var j=1;j<11;j++){
          if (h-j<0){
            break;
          }else{
            wordsPrevious.add(wordArray[h-j]);
          }
        }
        var dataRaw = await getWord(word.string);
        word = RxString(dataRaw['word']);
        adIndex = 0.obs;
        if (dataRaw['pronun'] != ''){
          pronun = RxString(dataRaw['pronun'].split('/')[1]);
        }else{
          pronun = ''.obs;
        }
        meanEN.clear();
        meanVN.clear();
        imageURL.clear();
        listCheckMean.clear();
        List listMean = jsonDecode(dataRaw['mean']).toList();
        for(var i = 0; i<listMean.length; i++) {
          listCheckMean.add(checkSubMean(listMean[i].cast<String>()));
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
          listImage.add([]);
          if (i>=jsonDecode(dataRaw['imageURL']).length){
            imageURL.add('bedict.png');
          }else{
            imageURL.add(jsonDecode(dataRaw['imageURL'])[i]);
          }
        }
        for (var i=0;i<listCheckMean.length;i++){
          if (listCheckMean[i]){
            firstMean = i.obs;
            break;
          }
        }
        await changeLanguage(language.string);
        adIndex = RxInt(Random().nextInt(mean.length)+1);
        if (firstMean.value >= adIndex.value){
          firstMean = RxInt(firstMean.value+1);
        }
        scrollController.animateTo(firstMean.value*imageWidth.value, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        break;
      }
    }
    if (!kt){
      searchField.text = word.string;
      Get.snackbar(learnWrongTitle.string, notFound.string);
    }else{
      if (initSpeak.value) await _speak(word.string);
    }
  }

  List<ProductDetails> products = <ProductDetails>[].obs;
  List<PurchaseDetails> purchases = <PurchaseDetails>[].obs;
}

class Introduce extends StatelessWidget {
  Introduce({Key? key}) : super(key: key);
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    Get.to(()=>const LoadingPage());
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
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

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: c.introduce0Title.string,
          body: c.introduce0Body.string,
          image: _buildImage('img0.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: c.introduce1Title.string,
          body: c.introduce1Body.string,
          image: _buildImage('img1.jpg',300),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: c.introduce2Title.string,
          body: c.introduce2Body.string,
          image: _buildImage('img2.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: c.introduce3Title.string,
          body: c.introduce3Body.string,
          image: _buildImage('img3.jpg',300),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip',style: TextStyle(color:backgroundColor)),
      next: const Icon(Icons.arrow_forward,color:backgroundColor),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600,color:backgroundColor)),
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
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<ScrollSnapListState> sslKey = GlobalKey<ScrollSnapListState>();
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(context) {
    final Controller c = Get.put(Controller());

    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Color(0xff879c03), Color(0xff353d01)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    Widget buildListItem(BuildContext context, int index) {
      return KeyboardDismisser(
        child: Opacity(
          opacity: index<c.adIndex.value? c.listCheckMean[index]? 1:0.3
            : index>c.adIndex.value? c.listCheckMean[index-1]? 1:0.3
            : 1,
          child: Container(
            width: c.imageWidth.value,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
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
                    width: c.imageWidth.value - 10,
                    child: index<c.adIndex.value?
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: NetworkImage('https://bedict.com/' + c.imageURL[index].replaceAll('\\','')),
                          fit: BoxFit.fill,
                          width: c.imageWidth.value - 10,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ): index>c.adIndex.value?
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: NetworkImage('https://bedict.com/' + c.imageURL[index-1].replaceAll('\\','')),
                          fit: BoxFit.fill,
                          width: c.imageWidth.value - 10,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ):
                      Container(
                        alignment: Alignment.center,
                        child: const NativeAdWidget(),
                        width: c.imageWidth.value - 10,
                        height: c.imageWidth.value - 10,
                      ),
                  ),
                  const SizedBox(height:5),
                  Container(
                    width: c.imageWidth.value - 10,
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: index<c.adIndex.value?
                      Column(
                        children: c.mean[index].map<Widget>((subMean) =>
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(245, 245, 245, 1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(6)
                              ),
                            ),
                            width: c.imageWidth.value - 10,
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
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  subMean.substring(0,subMean.length-1),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: textColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ).toList(),
                      ): index>c.adIndex.value?
                      Column(
                        children: c.mean[index-1].map<Widget>((subMean) =>
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(245, 245, 245, 1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(6)
                              ),
                            ),
                            width: c.imageWidth.value - 10,
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
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  subMean.substring(0,subMean.length-1),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: textColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ).toList(),
                      ):
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(245, 245, 245, 1),
                          borderRadius: BorderRadius.all(
                              Radius.circular(6)
                          ),
                        ),
                        width: c.imageWidth.value - 10,
                        child: Column(
                          children: [
                            const SizedBox(height: 3,),
                            Opacity(
                              opacity: 0.3,
                              child: Text(
                                c.adTitle.string,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              c.adBody.string,
                              style: const TextStyle(
                                fontSize: 18,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                          ],
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

    Future<void> showTime() async {
      final TimeOfDay? result =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (result != null) {
        c.selectedTime = RxString(result.format(context));
        c.update();
        showNotification();
        var box = await Hive.openBox('setting');
        await box.put('timeDaily',c.selectedTime.string);
        await box.close();
      }
    }

    Future.delayed(Duration.zero, () async {
      if (MediaQuery.of(context).size.width<400) {
        c.imageWidth = RxDouble(MediaQuery.of(context).size.width*0.6);
      }else{
        c.imageWidth = 240.0.obs;
      }
      c.update();
      if (c.initState.value){
        soundId = await rootBundle.load("assets/tap.mp3").then((ByteData soundData) {
          return pool.load(soundData);
        });
        statusBarHeight = MediaQuery.of(context).padding.top;
        c.initState = false.obs;
        bool check = await getListWords(c.level.string,c.category.string,c.type.string);
        if (!check){
          Get.snackbar(c.learnWrongTitle.string,c.notFound.string);
        }else{
          await c.layWord(c.word.string);
        }
        await updateToday();
        if (c.listLearnedToday.isEmpty){
          c.listWordsToday.clear();
          var box = await Hive.openBox('setting');
          await box.put('listWordsToday','[]');
          await box.close();
        }
      }
    });

    return KeyboardDismisser(
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        endDrawer: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width*0.7,
          child: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'BeDict',
                          style: TextStyle(
                              fontSize: 50,
                              foreground: Paint()..shader = linearGradient
                          ),
                        ),
                        Text(
                          'Pictorial Dictionary',
                          style: TextStyle(
                            fontSize: 16.7,
                            foreground: Paint()..shader = linearGradient
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                    Get.back();
                    Get.to(()=>const HistoryPage());
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
                    Get.back();
                    Get.to(()=>const ScorePage());
                  },
                ),
                const Divider(height:1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<Controller>(
                      builder: (_) => Text(
                      c.drawerDaily.string,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),),
                    GetBuilder<Controller>(
                      builder: (_) => Switch(
                        value: c.notifyDaily.value,
                        onChanged: (value) async {
                          c.notifyDaily = RxBool(value);
                          c.update();
                          var box = await Hive.openBox('setting');
                          await box.put('notifyDaily',value);
                          await box.close();
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
                                    fontWeight: FontWeight.w600,
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
                            const SizedBox(height: 10,),
                            GetBuilder<Controller>(
                              builder: (_) => Text(
                                c.drawerTarget.string,
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),),
                            GetBuilder<Controller>(
                              builder: (_) => Slider(
                                value: c.target.value.toDouble(),
                                min: 5,
                                max: 50,
                                divisions: 9,
                                activeColor: backgroundColor,
                                inactiveColor: themeColor,
                                thumbColor: backgroundColor,
                                label: c.target.value.toString(),
                                onChanged: (double value) async {
                                  c.target = RxInt(value.toInt());
                                  var box = await Hive.openBox('setting');
                                  await box.put('target',value.toInt());
                                  await box.close();
                                  c.update();
                                },
                              ),
                            ),
                          ]
                      )
                  ),
                ),
                const Divider(height:1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<Controller>(
                      builder: (_) => Text(
                      c.drawerWord.string,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),),
                    GetBuilder<Controller>(
                      builder: (_) => Switch(
                        value: c.notifyWord.value,
                        onChanged: (value) async {
                          c.notifyWord = RxBool(value);
                          c.update();
                          var box = await Hive.openBox('setting');
                          await box.put('notifyWord',value);
                          await box.close();
                          if (value) {
                            showNotificationWord();
                          }else{
                            for (var i=1;i<18;i++){
                              await AwesomeNotifications().dismiss(i);
                              await AwesomeNotifications().cancelSchedule(i);
                            }
                          }
                        },
                        activeTrackColor: themeColor,
                        activeColor: backgroundColor,
                      ),
                    ),
                  ],
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
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                          var box = await Hive.openBox('setting');
                          await box.put('speakSpeed',value);
                          await box.close();
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),),
                    const SizedBox(width:10),
                    GetBuilder<Controller>(
                      builder: (_) => Switch(
                        activeColor: backgroundColor,
                        activeTrackColor: themeColor,
                        value: c.initSpeak.value,
                        onChanged: (value) {
                          c.initSpeak = value.obs;
                          c.update();
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),),
                    const SizedBox(width:10),
                    GetBuilder<Controller>(
                      builder: (_) => Switch(
                        activeColor: backgroundColor,
                        activeTrackColor: themeColor,
                        value: c.enableSound.value,
                        onChanged: (value) {
                          c.enableSound = value.obs;
                          c.update();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:5),
                const Divider(height:1,),
                const SizedBox(height:12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<Controller>(
                      builder: (_) =>  Text(
                      c.drawerLanguage.string,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                const SizedBox(height:12),
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
                    Get.back();
                  },
                ),
                const Divider(height:1),
                ListTile(
                  title: GetBuilder<Controller>(
                    builder: (_) =>  Text(
                      c.drawerUpgrade.string,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),),
                  onTap: () {
                    Get.back();
                    Get.to(()=>const MyUpgradePage());
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
                    Get.back();
                    Get.to(()=>const ContactPage());
                  },
                ),
                const Divider(height:1),
              ],
            ),
          ),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, //i like transaparent :-)
            systemNavigationBarColor: backgroundColor, // navigation bar color
            statusBarIconBrightness: Brightness.light, // status bar icons' color
            systemNavigationBarIconBrightness: Brightness.light, //navigation bar icons' color
          ),
          child: Stack(
            children: [
              CustomPaint(
                painter: ShapePainter(),
                child: Container(),
              ),
              Column (
                mainAxisAlignment: MainAxisAlignment.start,
                children:<Widget> [
                  SizedBox(height: MediaQuery.of(context).padding.top,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await setDefault();
                          bool check = await getListWords(c.level.string,c.category.string,c.type.string);
                          if (!check){
                            Get.snackbar(c.learnWrongTitle.string,c.notFound.string);
                          }else{
                            await c.layWord('hello');
                          }
                        },
                        child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'BeDict',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    'Pictorial Dictionary',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ]
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0.0),
                        icon: const Icon(Icons.more_vert, size: 25,),
                        tooltip: 'Open Menu',
                        onPressed: () {
                          _key.currentState!.openEndDrawer();
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 0,),
                      const SizedBox(
                        height: 30,
                        child: VerticalDivider(
                          width: 10,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black26,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: GetBuilder<Controller>(
                            builder: (_) => DropdownButton<String>(
                              value: c.listCategory[c.categoryIndex.value],
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 15,
                              isDense: true,
                              isExpanded: true,
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 13,
                                overflow: TextOverflow.ellipsis,
                              ),
                              underline: const SizedBox(),
                              onChanged: (String? newValue) async {
                                if (c.language.string == 'VN'){
                                  await c.changeCategory(listCategoryVN.indexOf(newValue!));
                                }else{
                                  await c.changeCategory(listCategoryEN.indexOf(newValue!));
                                }
                              },
                              items: c.listCategory.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                        child: VerticalDivider(
                          width: 10,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black26,
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: GetBuilder<Controller>(
                            builder: (_) => DropdownButton<String>(
                              value: c.listType[c.typeIndex.value],
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 15,
                              isDense: true,
                              isExpanded: true,
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 13,
                                overflow: TextOverflow.ellipsis,
                              ),
                              underline: const SizedBox(),
                              onChanged: (String? newValue) async {
                                if (c.language.string == 'VN'){
                                  await c.changeType(listTypeVN.indexOf(newValue!));
                                }else{
                                  await c.changeType(listTypeEN.indexOf(newValue!));
                                }
                              },
                              items: c.listType.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                        child: VerticalDivider(
                          width: 10,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black26,
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: GetBuilder<Controller>(
                            builder: (_) => DropdownButton<String>(
                              value: c.listLevel[c.levelIndex.value],
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 15,
                              isDense: true,
                              isExpanded: true,
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 13,
                                overflow: TextOverflow.ellipsis,
                              ),
                              underline: const SizedBox(),
                              onChanged: (String? newValue) async {
                                if (c.language.string == 'VN'){
                                  await c.changeLevel(listLevelVN.indexOf(newValue!));
                                }else{
                                  await c.changeLevel(listLevelEN.indexOf(newValue!));
                                }
                              },
                              items: c.listLevel.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                        child: VerticalDivider(
                          width: 10,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black26,
                        ),
                      ),
                      const SizedBox(width: 0,),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Container(
                          // height: 36,
                          alignment: Alignment.centerLeft,
                          child: GetBuilder<Controller>(
                            builder: (_) => TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: searchField,
                                autofocus: false,
                                autocorrect: false,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: textColor,
                                ),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width:0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30)
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30)
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30)
                                    ),
                                  ),
                                  // prefixIcon: Icon(Icons.search_outlined,size:15),
                                  hintText: c.hint.string,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(12),
                                  prefixIcon: const Icon(Icons.search),
                                  // icon: Icon(Icons.search),
                                  // isCollapsed: true,
                                ),
                                onSubmitted: (value) async {
                                  await c.layWord(value);
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
                              suggestionsCallback: (pattern){
                                var suggestArray = [];
                                for (var i = 0; i < c.wordArray.length; i++){
                                  if (c.wordArray[i].toString().toLowerCase().startsWith(pattern.toLowerCase())){
                                    suggestArray.add(c.wordArray[i].toString());
                                  }
                                  if (suggestArray.length > 5){
                                    break;
                                  }
                                }
                                return suggestArray;
                              },
                              suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(
                                    suggestion.toString(),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: textColor,
                                    ),
                                  ),
                                );
                              },
                              onSuggestionSelected: (suggestion) async {
                                searchField.text = suggestion.toString();
                                await c.layWord(suggestion.toString());
                              },
                              animationDuration: Duration.zero,
                              debounceDuration: Duration.zero,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(245, 245, 245, 1),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(30)
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 0,
                                blurRadius: 3,
                                offset: const Offset(4, 4), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Opacity(
                    opacity: 0.6,
                    child: Row(
                      children: [
                        const SizedBox(width: 2),
                        Expanded(
                          flex: 6,
                          child: TextButton(
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
                                const Icon(
                                  Icons.volume_up_outlined,
                                  size: 25,
                                  color: textColor,
                                ),
                                Expanded(
                                  child: GetBuilder<Controller>(
                                    builder: (_) => Text(
                                      c.pronun.string,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              _speak(c.word.string);
                            },
                          ),
                        ),
                        const SizedBox(width:3),
                        GetBuilder<Controller>(
                          builder: (_) => Expanded(
                            flex: 4,
                            child: Visibility(
                              visible: c.notifyDaily.value,
                              child: PopupMenuButton<Score>(
                                onSelected: (Score score) async {
                                  await setDefault();
                                  c.wordArray.clear();
                                  for (var i=0;i<c.listLearnedToday.length;i++){
                                    if (!c.wordArray.contains(c.listLearnedToday[i].wordId)){
                                      c.wordArray.add(c.listLearnedToday[i].wordId);
                                    }
                                  }
                                  await c.layWord(score.wordId);
                                },
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<Score>>[
                                  for (int i=0; i<c.listLearnedToday.length; i++)
                                    PopupMenuItem<Score>(
                                      value: c.listLearnedToday[i],
                                      padding: const EdgeInsets.fromLTRB(8,0,8,0),
                                      // padding: const EdgeInsets.all(0),
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(0,4,0,4),
                                        // width: 180,
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(245, 245, 245, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)
                                          ),
                                        ),
                                        child: Column(
                                            children: [
                                              const SizedBox(height:7),
                                              Text(
                                                c.listLearnedToday[i].wordId,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: textColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height:7),
                                              Row(
                                                children: [
                                                  const SizedBox(width:5),
                                                  Expanded(
                                                    child: CircularPercentIndicator(
                                                      radius: 40,
                                                      lineWidth: 1.0,
                                                      animation: true,
                                                      percent: c.listLearnedToday[i].word/25,
                                                      backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
                                                      progressColor: textColor,
                                                      center: Text(
                                                        c.scoreWord.string,
                                                        style: const TextStyle(
                                                          fontSize: 9,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: CircularPercentIndicator(
                                                      radius: 40,
                                                      lineWidth: 1.0,
                                                      animation: true,
                                                      percent: c.listLearnedToday[i].pronun/25,
                                                      backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
                                                      progressColor: textColor,
                                                      center: Text(
                                                        c.scorePronun.string,
                                                        style: const TextStyle(
                                                          fontSize: 9,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: CircularPercentIndicator(
                                                      radius: 40,
                                                      lineWidth: 1.0,
                                                      animation: true,
                                                      percent: c.listLearnedToday[i].speak/25,
                                                      backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
                                                      progressColor: textColor,
                                                      center: Text(
                                                        c.scoreSpeak.string,
                                                        style: const TextStyle(
                                                          fontSize: 9,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: CircularPercentIndicator(
                                                      radius: 40,
                                                      lineWidth: 1.0,
                                                      animation: true,
                                                      percent: c.listLearnedToday[i].mean/25,
                                                      backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
                                                      progressColor: textColor,
                                                      center: Text(
                                                        c.scoreMean.string,
                                                        style: const TextStyle(
                                                          fontSize: 9,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                    ),
                                                  ),
                                                  const SizedBox(width:5),
                                                ],
                                              ),
                                              const SizedBox(height:7),
                                            ]
                                        ),
                                      ),
                                    ),
                                ],
                                // color: themeColor,
                                child: Container(
                                  height: 40,
                                  margin: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: themeColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30)
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    c.learnedWordsTodayTitle.string
                                        + ' ' + c.listLearnedToday.length.toString()
                                        + '/' + c.target.value.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                              ),
                            ),
                          ),
                        ),
                        GetBuilder<Controller>(
                          builder: (_) => Visibility(
                            visible: c.notifyDaily.value,
                            child: const SizedBox(width:3),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(170, 230, 180, 1)
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
                              if (c.word.string != ''){
                                arrangeLearnMean();
                                if (!await checkScore(c.word.string)){
                                  c.listWordsToday.add(c.word.string);
                                  var box = await Hive.openBox('setting');
                                  await box.put('listWordsToday',jsonEncode(c.listWordsToday));
                                  await box.close();
                                  await insertScore(c.word.string);
                                }
                                Get.to(()=>const LearnWord());
                              }else{
                                Get.snackbar(c.snackbarFindTitle.string,c.snackbarFindBody.string);
                              }
                            },
                            child: GetBuilder<Controller>(
                              builder: (_) => Text(
                                  c.learnTitle.string.toLowerCase(),
                                  style: const TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w400,
                                  )
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width:5),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children:[
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GetBuilder<Controller>(
                                  builder: (_) => Flexible(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 500),
                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                        return ScaleTransition(child: child, scale: animation);
                                      },
                                      child: Text(
                                        c.word.toString(),
                                        key: ValueKey<String>(c.word.string),
                                        style: const TextStyle(
                                          fontSize: 50,
                                          color: textColor,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 5,
                                              color: Colors.grey,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Opacity(
                              opacity: 0.6,
                              child: Row(
                                children:[
                                  const SizedBox(width: 5),
                                  Expanded(
                                    flex: 2,
                                    child: TextButton(
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
                                              borderRadius: BorderRadius.circular(20.0),
                                            )
                                        ),
                                        fixedSize: MaterialStateProperty.all<Size>(
                                            const Size.fromHeight(30)
                                        ),
                                      ),
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
                                      child: const Icon(
                                        FontAwesomeIcons.share,
                                        size: 15,
                                        color: Color.fromRGBO(150, 200, 160, 1),
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    flex:12,
                                    child: SizedBox(),
                                  ),
                                ]
                              ),
                            ),
                            GetBuilder<Controller>(
                              builder: (_) => LinearPercentIndicator(
                                alignment: MainAxisAlignment.center,
                                width: MediaQuery.of(context).size.width-20,
                                lineHeight: 1.0,
                                percent: (c.wordScore.value+c.pronunScore.value+c.speakScore.value+c.meanScore.value)/100,
                                backgroundColor: themeColor,
                                progressColor: backgroundColor,
                                padding: const EdgeInsets.all(0),
                                animation: true,
                              ),
                            ),
                            GetBuilder<Controller>(
                              builder: (_) => Expanded(
                                child: ScrollSnapList(
                                  shrinkWrap: true,
                                  curve: Curves.ease,
                                  onItemFocus: c.onItemFocus,
                                  listController: scrollController,
                                  itemSize: c.imageWidth.value,
                                  itemBuilder: buildListItem,
                                  itemCount: c.mean.length + 1,
                                  // key: ListGlobalKeys.scrollKey,
                                  key: sslKey,
                                  duration: 10,
                                  dynamicItemSize: true,
                                  allowAnotherDirection: false,
                                  clipBehavior: Clip.none,
                                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                ),
                              ),
                            ),
                          ]
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height:5),
                  Row(
                    children:[
                      const SizedBox(width:3),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton<String>(
                          onSelected: (String word) async {
                            await c.layWord(word);
                          },
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            for (int i=0; i<c.wordsPrevious.length; i++)
                              PopupMenuItem<String>(
                                  value: c.wordsPrevious[i],
                                  padding: const EdgeInsets.fromLTRB(6,0,6,0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          c.wordsPrevious[i],
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
                          child: Container(
                            // width: 150,
                            height: 48,
                            margin: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(30)
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                                FontAwesomeIcons.angleDoubleLeft,
                                size: 15,
                                color: Color.fromRGBO(150, 180, 160, 1)
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                        ),
                      ),
                      const SizedBox(width:3),
                      Expanded(
                        child: TextButton(
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
                                  borderRadius: BorderRadius.circular(30.0),
                                )
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(
                                const Size.fromHeight(48)
                            ),
                          ),
                          onPressed: () async {
                            if (c.wordsPrevious.isNotEmpty){
                              await c.layWord(c.wordsPrevious[0]);
                            }
                          },
                          child: const Icon(
                            FontAwesomeIcons.angleLeft,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width:3),
                      Expanded(
                        flex: 2,
                        child: TextButton(
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
                                  borderRadius: BorderRadius.circular(30.0),
                                )
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(
                                const Size.fromHeight(48)
                            ),
                          ),
                          onPressed: () async {
                            var newRandomWord = '';
                            var check = true;
                            List<String> listRandom = <String>[];
                            while (check && listRandom.length < c.wordArray.length){
                              newRandomWord = c.wordArray[Random().nextInt(c.wordArray.length)];
                              check = await checkScore(newRandomWord);
                              if (!listRandom.contains(newRandomWord)){
                                listRandom.add(newRandomWord);
                              }
                            }
                            if (check && listRandom.length == c.wordArray.length){
                              Get.snackbar(c.learnRightTitle.string,c.all.string);
                            }else{
                              c.word = RxString(newRandomWord);
                              await c.layWord(c.word.string);
                              // sslKey.currentState!.focusToItem(c.firstMean.value);
                            }
                          },
                          child: GetBuilder<Controller>(
                            builder: (_) => Text(
                                c.newRandomWordTitle.string,
                                style: const TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width:3),
                      Expanded(
                        child: TextButton(
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
                                  borderRadius: BorderRadius.circular(30.0),
                                )
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(
                                const Size.fromHeight(48)
                            ),
                          ),
                          onPressed: () async {
                            if (c.wordsNext.isNotEmpty){
                              await c.layWord(c.wordsNext[0]);
                            }
                          },
                          child: const Icon(
                            FontAwesomeIcons.angleRight,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width:3),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton<String>(
                          onSelected: (String word) async {
                            await c.layWord(word);
                          },
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            for (int i=0; i<c.wordsNext.length; i++)
                              PopupMenuItem<String>(
                                  value: c.wordsNext[i],
                                  padding: const EdgeInsets.fromLTRB(6,0,6,0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          c.wordsNext[i],
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
                          child: Container(
                            // width: 150,
                            height: 48,
                            margin: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(30)
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                                FontAwesomeIcons.angleDoubleRight,
                                size: 15,
                                color: Color.fromRGBO(150, 180, 160, 1)
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                        ),
                      ),
                      const SizedBox(width:3),
                    ]
                  ),
                  const SizedBox(height:5),
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromRGBO(147, 219, 172, 1)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path = Path();
    path.lineTo(0, 105 + statusBarHeight);
    path.quadraticBezierTo(size.width / 2, 133 + statusBarHeight, size.width, 105 + statusBarHeight);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class WriteWidget extends StatelessWidget {
  const WriteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    void reset() {
      c.listArrange = [for (int i=0; i<c.word.string.split('').length; i++)''];
      c.listRandom = c.word.string.split('').obs;
      c.listRandom.shuffle();
      c.update();
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      reset();
    });

    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height:10),
          GetBuilder<Controller>(
            builder: (_) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                      height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                      child: Stack(
                          children:[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Image(
                                    image: NetworkImage('https://bedict.com/' + c.imageURL[0].replaceAll('\\','')),
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                    height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                image: NetworkImage('https://bedict.com/' + c.imageURL[0].replaceAll('\\','')),
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ]
                      )
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
                            blurRadius: 5,
                            offset: const Offset(5, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      // alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                      height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                      child: const NativeAdWidget()
                  ),
                  for (int index=1; index<c.mean.length; index++)
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
                      height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                    height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
          const SizedBox(height:10),
          GetBuilder<Controller>(
            builder: (_) => LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              width: MediaQuery.of(context).size.width - 40,
              lineHeight: 1,
              percent: c.wordScore.value/25,
              backgroundColor: themeColor,
              progressColor: backgroundColor,
              padding: const EdgeInsets.all(0),
              animation: true,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i=0; i<c.word.string.split('').length; i++)
                        GestureDetector(
                          onTap: () async {
                            c.listRandom[c.listRandom.indexOf('')] = c.listArrange[i];
                            c.listArrange[i] = '';
                            c.update();
                            if (c.enableSound.value){
                              await pool.play(soundId);
                            }
                          },
                          child: GetBuilder<Controller>(
                              builder: (_) => Neumorphic(
                                style: c.listArrange[i] == ''?
                                NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                  depth: -5,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white,
                                  intensity: 1,
                                  border: const NeumorphicBorder (
                                    color: Color.fromRGBO(250, 250, 250, 1),
                                    width: 0.05,
                                  ),
                                ):
                                NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                  depth: 3,
                                  lightSource: LightSource.topLeft,
                                  color: const Color.fromRGBO(50, 90, 60, 1),
                                  intensity: 1,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 45,
                                  width: 45,
                                  child: Text(
                                    c.listArrange[i],
                                    style: const TextStyle(
                                      fontSize: 27,
                                      color: Color.fromRGBO(255, 255, 255, 1), //customize color here
                                    ),
                                  ),
                                ),
                              )
                          ),
                        )
                    ]
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i=0; i<c.word.string.split('').length; i++)
                        GestureDetector(
                          onTap: () async {
                            c.listArrange[c.listArrange.indexOf('')] = c.listRandom[i];
                            c.listRandom[i] = '';
                            c.update();
                            if (!c.listArrange.contains('')){
                              if (listEquals(c.listArrange,c.word.string.split(''))){
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
                                  if (c.wordScore.value==25){
                                    Get.defaultDialog(
                                        title: c.learnRightTitle.string,
                                        middleText: c.learnRightBodyAllWord.string,
                                        backgroundColor: themeColor,
                                        titleStyle: const TextStyle(color: textColor,),
                                        middleTextStyle: const TextStyle(color: textColor,),
                                        textConfirm: c.learnNext.string,
                                        confirmTextColor: textColor,
                                        buttonColor: Colors.white,
                                        textCancel: "ok",
                                        cancelTextColor: textColor,
                                        barrierDismissible: false,
                                        radius: 8,
                                        onConfirm: () async {
                                          reset();
                                          await updateToday();
                                          Get.back();
                                          c.currentTab = RxInt(1);
                                        },
                                        onCancel: () async {
                                          await updateToday();
                                        }
                                    );
                                  }else{
                                    Get.defaultDialog(
                                        title: c.learnRightTitle.string,
                                        middleText: c.learnRightBody.string,
                                        backgroundColor: themeColor,
                                        titleStyle: const TextStyle(color: textColor,),
                                        middleTextStyle: const TextStyle(color: textColor,),
                                        textConfirm: c.learnNext.string,
                                        confirmTextColor: textColor,
                                        buttonColor: Colors.white,
                                        textCancel: "ok",
                                        cancelTextColor: textColor,
                                        barrierDismissible: false,
                                        radius: 8,
                                        onConfirm: () async{
                                          reset();
                                          await updateToday();
                                          Get.back();
                                          c.currentTab = RxInt(1);
                                          c.update();
                                        },
                                        onCancel: () async {
                                          await updateToday();
                                        }
                                    );
                                  }
                                }
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
                                Get.defaultDialog(
                                    title: c.learnWrongTitle.string,
                                    middleText: c.learnWrongBody.string,
                                    backgroundColor: themeColor,
                                    titleStyle: const TextStyle(color: textColor,),
                                    middleTextStyle: const TextStyle(color: textColor,),
                                    textConfirm: c.learnReset.string,
                                    confirmTextColor: textColor,
                                    buttonColor: Colors.white,
                                    textCancel: "ok",
                                    cancelTextColor: textColor,
                                    barrierDismissible: false,
                                    radius: 8,
                                    onConfirm: () async {
                                      reset();
                                      await updateToday();
                                      Get.back();
                                    },
                                    onCancel: () async {
                                      await updateToday();
                                    }
                                );
                              }
                            }
                            if (c.enableSound.value){
                              await pool.play(soundId);
                            }
                          },
                          child: GetBuilder<Controller>(
                              builder: (_) => Neumorphic(
                                style: c.listRandom[i] == ''?
                                NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                  depth: -5,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white,
                                  intensity: 1,
                                  border: const NeumorphicBorder (
                                    color: Color.fromRGBO(250, 250, 250, 1),
                                    width: 0.05,
                                  ),
                                ):
                                NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                  depth: 3,
                                  lightSource: LightSource.topLeft,
                                  color: const Color.fromRGBO(50, 90, 60, 1),
                                  intensity: 1,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 45,
                                  width: 45,
                                  child: Text(
                                    c.listRandom[i],
                                    style: const TextStyle(
                                      fontSize: 27,
                                      color: Color.fromRGBO(255, 255, 255, 1), //customize color here
                                    ),
                                  ),
                                ),
                              )
                          ),
                        )
                    ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PronunWidget extends StatelessWidget {
  const PronunWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    void reset() {
      c.listArrangePronun = [for (int i=0; i<c.pronun.string.split('').length; i++)''];
      c.listRandomPronun = c.pronun.string.split('').obs;
      c.listRandomPronun.shuffle();
      c.update();
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      reset();
    });

    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height:10),
          GetBuilder<Controller>(
            builder: (_) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                        height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                        child: Stack(
                            children:[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Image(
                                      image: NetworkImage('https://bedict.com/' + c.imageURL[0].replaceAll('\\','')),
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                      height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                  image: NetworkImage('https://bedict.com/' + c.imageURL[0].replaceAll('\\','')),
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                  height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ]
                        )
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
                              blurRadius: 5,
                              offset: const Offset(5, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        // alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                        height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                        child: const NativeAdWidget()
                    ),
                    for (int index=1; index<c.mean.length; index++)
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
                          height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                        fit: BoxFit.fill,
                                        width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                        height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                    height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
          const SizedBox(height:10),
          GetBuilder<Controller>(
            builder: (_) => LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              width: MediaQuery.of(context).size.width - 40,
              lineHeight: 1,
              percent: c.pronunScore.value/25,
              backgroundColor: themeColor,
              progressColor: backgroundColor,
              padding: const EdgeInsets.all(0),
              animation: true,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i=0; i<c.pronun.string.split('').length; i++)
                        GestureDetector(
                          onTap: () async {
                            c.listRandomPronun[c.listRandomPronun.indexOf('')] = c.listArrangePronun[i];
                            c.listArrangePronun[i] = '';
                            c.update();
                            if (c.enableSound.value){
                              await pool.play(soundId);
                            }
                          },
                          child: GetBuilder<Controller>(
                              builder: (_) => Neumorphic(
                                style: c.listArrangePronun[i] == ''?
                                NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                  depth: -5,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white,
                                  intensity: 1,
                                  border: const NeumorphicBorder (
                                    color: Color.fromRGBO(250, 250, 250, 1),
                                    width: 0.05,
                                  ),
                                ):
                                NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                  depth: 3,
                                  lightSource: LightSource.topLeft,
                                  color: const Color.fromRGBO(50, 90, 60, 1),
                                  intensity: 1,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 45,
                                  width: 45,
                                  child: Text(
                                    c.listArrangePronun[i],
                                    style: const TextStyle(
                                      fontSize: 27,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                ),
                              )
                          ),
                        )
                    ]
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i=0; i<c.pronun.string.split('').length; i++)
                        GestureDetector(
                          onTap: () async {
                            c.listArrangePronun[c.listArrangePronun.indexOf('')] = c.listRandomPronun[i];
                            c.listRandomPronun[i] = '';
                            c.update();
                            if (!c.listArrangePronun.contains('')){
                              if (listEquals(c.listArrangePronun,c.pronun.string.split(''))){
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
                                  if (c.pronunScore.value==25){
                                    Get.defaultDialog(
                                        title: c.learnRightTitle.string,
                                        middleText: c.learnRightBodyAllPronun.string,
                                        backgroundColor: const Color.fromRGBO(202, 237, 214, 1),
                                        titleStyle: const TextStyle(color: textColor,),
                                        middleTextStyle: const TextStyle(color: textColor,),
                                        textConfirm: c.learnNext.string,
                                        confirmTextColor: textColor,
                                        buttonColor: Colors.white,
                                        textCancel: "ok",
                                        cancelTextColor: textColor,
                                        barrierDismissible: false,
                                        radius: 8,
                                        onConfirm: () async {
                                          reset();
                                          await updateToday();
                                          Get.back();
                                          c.currentTab = RxInt(2);
                                          c.update();
                                        },
                                        onCancel: () async {
                                          await updateToday();
                                        }
                                    );
                                  }else{
                                    Get.defaultDialog(
                                        title: c.learnRightTitle.string,
                                        middleText: c.learnRightBody.string,
                                        backgroundColor: const Color.fromRGBO(202, 237, 214, 1),
                                        titleStyle: const TextStyle(color: textColor,),
                                        middleTextStyle: const TextStyle(color: textColor,),
                                        textConfirm: c.learnNext.string,
                                        confirmTextColor: textColor,
                                        buttonColor: Colors.white,
                                        textCancel: "ok",
                                        cancelTextColor: textColor,
                                        barrierDismissible: false,
                                        radius: 8,
                                        onConfirm: () async {
                                          reset();
                                          await updateToday();
                                          Get.back();
                                          c.currentTab = RxInt(2);
                                          c.update();
                                        },
                                        onCancel: () async {
                                          await updateToday();
                                        }
                                    );
                                  }
                                }
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
                                Get.defaultDialog(
                                    title: c.learnWrongTitle.string,
                                    middleText: c.learnWrongBody.string,
                                    backgroundColor: const Color.fromRGBO(202, 237, 214, 1),
                                    titleStyle: const TextStyle(color: textColor,),
                                    middleTextStyle: const TextStyle(color: textColor,),
                                    textConfirm: c.learnReset.string,
                                    confirmTextColor: textColor,
                                    buttonColor: Colors.white,
                                    textCancel: "ok",
                                    cancelTextColor: textColor,
                                    barrierDismissible: false,
                                    radius: 8,
                                    onConfirm: () async {
                                      reset();
                                      await updateToday();
                                      Get.back();
                                    },
                                    onCancel: () async {
                                      await updateToday();
                                    }
                                );
                              }
                            }
                            if (c.enableSound.value){
                              await pool.play(soundId);
                            }
                          },
                          child: GetBuilder<Controller>(
                              builder: (_) => Neumorphic(
                                style: c.listRandomPronun[i] == ''?
                                NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                  depth: -5,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white,
                                  intensity: 1,
                                  border: const NeumorphicBorder (
                                    color: Color.fromRGBO(250, 250, 250, 1),
                                    width: 0.05,
                                  ),
                                ):
                                NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                                  depth: 3,
                                  lightSource: LightSource.topLeft,
                                  color: const Color.fromRGBO(50, 90, 60, 1),
                                  intensity: 1,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 45,
                                  width: 45,
                                  child: Text(
                                    c.listRandomPronun[i],
                                    style: const TextStyle(
                                      fontSize: 27,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                ),
                              )
                          ),
                        )
                    ]
                ),
              ),
            ),
          ),
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
    SpeechToText stt = SpeechToText();

    Future initSpeech() async {
      c.speechEnabled = RxBool(await stt.initialize());
      c.update();
    }
    void onSpeechResult(SpeechRecognitionResult result) async {
      c.listenString = RxString(result.recognizedWords);
      c.update();
      if (stt.isNotListening) {
        bool kt = false;
        if (c.word.string.contains(' ')){
          if (c.listenString.string.toLowerCase().contains(c.word.string.toLowerCase())){
            kt = true;
          }
        }else{
          if (c.listenString.string.toLowerCase().split(' ').contains(c.word.string.toLowerCase())){
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
            if (c.speakScore.value==25){
              Get.defaultDialog(
                  title: c.learnRightTitle.string,
                  middleText: c.learnRightBodyAllSpeak.string,
                  backgroundColor: const Color.fromRGBO(202, 237, 214, 1),
                  titleStyle: const TextStyle(color: textColor,),
                  middleTextStyle: const TextStyle(color: textColor,),
                  textConfirm: c.learnNext.string,
                  confirmTextColor: textColor,
                  buttonColor: Colors.white,
                  textCancel: "ok",
                  cancelTextColor: textColor,
                  barrierDismissible: false,
                  radius: 8,
                  onConfirm: () async{
                    c.listenString = ''.obs;
                    await updateToday();
                    Get.back();
                    c.nowIndex = 0.obs;
                    c.currentTab = RxInt(3);
                    c.update();
                  },
                  onCancel: () async {
                    await updateToday();
                  }
              );
            }else{
              Get.defaultDialog(
                  title: c.learnRightTitle.string,
                  middleText: c.learnRightBodySpeak.string,
                  backgroundColor: themeColor,
                  titleStyle: const TextStyle(color: textColor,),
                  middleTextStyle: const TextStyle(color: textColor,),
                  textConfirm: c.learnNext.string,
                  confirmTextColor: textColor,
                  buttonColor: Colors.white,
                  textCancel: "ok",
                  cancelTextColor: textColor,
                  barrierDismissible: false,
                  radius: 8,
                  onConfirm: () async {
                    c.listenString = ''.obs;
                    await updateToday();
                    Get.back();
                    c.nowIndex = 0.obs;
                    c.currentTab = RxInt(3);
                    c.update();
                  },
                  onCancel: () async {
                    await updateToday();
                  }
              );
            }
          }
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
          Get.defaultDialog(
              title: c.learnWrongTitle.string,
              middleText: c.learnWrongBodySpeak.string,
              backgroundColor: themeColor,
              titleStyle: const TextStyle(color: textColor,),
              middleTextStyle: const TextStyle(color: textColor,),
              textConfirm: c.learnReset.string,
              confirmTextColor: textColor,
              buttonColor: Colors.white,
              textCancel: "ok",
              cancelTextColor: textColor,
              barrierDismissible: false,
              radius: 8,
              onConfirm: () async {
                c.listenString = ''.obs;
                await updateToday();
                Get.back();
              },
              onCancel: () async {
                await updateToday();
              }
          );
        }
      }
    }
    Future startListening() async {
      await stt.listen(
          onResult: onSpeechResult,
          localeId: c.locale.string
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
                  activeColor: backgroundColor,
                  inactiveColor: const Color.fromRGBO(240, 240, 240, 1),
                  thumbColor: backgroundColor,
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
              Colors.white
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
            const Icon(
              Icons.volume_up_outlined,
              size: 30,
              color: backgroundColor,
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
        onPressed: () async {
          await _speak(c.word.string);
        },
      );
    }

    Future.delayed(Duration.zero, () async {
      await initSpeech();
    });

    return Container(
      color: Colors.white,
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
                        height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                        child: Stack(
                            children:[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Image(
                                      image: NetworkImage('https://bedict.com/' + c.imageURL[0].replaceAll('\\','')),
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                      height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                  image: NetworkImage('https://bedict.com/' + c.imageURL[0].replaceAll('\\','')),
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                  height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ]
                        )
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
                              blurRadius: 5,
                              offset: const Offset(5, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        // alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                        height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                        child: const NativeAdWidget()
                    ),
                    for (int index=1; index<c.mean.length; index++)
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
                          height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                        fit: BoxFit.fill,
                                        width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                        height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                    height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                  const SizedBox(width:5),
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
          ),
          GetBuilder<Controller>(
            builder: (_) => LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              width: MediaQuery.of(context).size.width - 40,
              lineHeight: 1,
              percent: c.speakScore.value/25,
              backgroundColor: themeColor,
              progressColor: backgroundColor,
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
                    c.speechEnabled.value ? Icons.mic : Icons.mic_off,
                    size:150,
                    color: backgroundColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MeanWidget extends StatelessWidget {
  const MeanWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    List<bool> ktMean = <bool>[for (int i=0; i<c.mean.length; i++)false];
    List<int> randomPosition = <int>[for (int i=0; i<c.mean.length; i++)Random().nextInt((c.mean.length+1<4)?c.mean.length+1:4)];

    Future.delayed(Duration.zero, () async {
      c.nowIndex = 0.obs;
      ktMean.clear();
      for (var i=0;i<c.mean.length;i++){
        ktMean.add(false);
      }
      c.update();
    });

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 5),
                OutlinedButton(
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
                          borderRadius: BorderRadius.circular(30.0),
                        )
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(40)
                    ),
                  ),
                  onPressed: () async {
                    if (c.nowIndex.value > 0){
                      c.nowIndex = RxInt(c.nowIndex.value - 1);
                      c.update();
                    }else{
                      c.nowIndex = RxInt(c.mean.length - 1);
                      c.update();
                    }
                  },
                  child: const Icon(Icons.arrow_left_sharp, size: 20),
                ),
                const SizedBox(width: 5),
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              c.word.string,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 40,
                                color: textColor,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5,
                                    color: Colors.grey,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                    )
                ),
                const SizedBox(width: 5),
                OutlinedButton(
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
                          borderRadius: BorderRadius.circular(30.0),
                        )
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(40)
                    ),
                  ),
                  onPressed: () async {
                    if (c.nowIndex.value < c.mean.length - 1){
                      c.nowIndex = RxInt(c.nowIndex.value + 1);
                      c.update();
                    }else{
                      c.nowIndex = RxInt(0);
                      c.update();
                    }
                  },
                  child: const Icon(Icons.arrow_right_sharp, size: 20),
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
                children: c.mean[c.listIndex[c.nowIndex.value]].map<Widget>((subMean) =>
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
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
          GetBuilder<Controller>(
            builder: (_) => LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              width: MediaQuery.of(context).size.width - 40,
              lineHeight: 1,
              percent: c.meanScore.value/25,
              backgroundColor: themeColor,
              progressColor: backgroundColor,
              padding: const EdgeInsets.all(0),
              animation: true,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: GetBuilder<Controller>(
                  builder: (_) => Wrap(
                    spacing: 0,
                    runSpacing: 0,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: [
                      for (int index=0; index<((c.mean.length+1<4)?c.mean.length+1:4); index++)
                        index<randomPosition[c.nowIndex.value]?
                        GestureDetector(
                          onTap: () async {
                            if (c.listImage[c.nowIndex.value][index] == c.imageURL[c.listIndex[c.nowIndex.value]]){
                              ktMean[c.nowIndex.value] = true;
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
                                  if (c.meanScore.value==25){
                                    Get.defaultDialog(
                                      title: c.learnRightTitle.string,
                                      middleText: c.learnRightBodyAllMeanDone.string,
                                      backgroundColor: themeColor,
                                      titleStyle: const TextStyle(color: textColor,),
                                      middleTextStyle: const TextStyle(color: textColor,),
                                      textConfirm: c.learnNext.string,
                                      confirmTextColor: textColor,
                                      buttonColor: Colors.white,
                                      textCancel: "ok",
                                      cancelTextColor: textColor,
                                      barrierDismissible: false,
                                      radius: 8,
                                      onConfirm: () async {
                                        c.nowIndex = 0.obs;
                                        await updateToday();
                                        Get.back();
                                        c.currentTab = RxInt(0);
                                        c.update();
                                      },
                                      onCancel: () async {
                                        c.nowIndex = 0.obs;
                                        await updateToday();
                                      },
                                    );
                                  }else{
                                    Get.defaultDialog(
                                        title: c.learnRightTitle.string,
                                        middleText: c.learnRightBodyAllMean.string,
                                        backgroundColor: themeColor,
                                        titleStyle: const TextStyle(color: textColor,),
                                        middleTextStyle: const TextStyle(color: textColor,),
                                        textConfirm: c.learnNext.string,
                                        confirmTextColor: textColor,
                                        buttonColor: Colors.white,
                                        textCancel: "ok",
                                        cancelTextColor: textColor,
                                        barrierDismissible: false,
                                        radius: 8,
                                        onConfirm: () async {
                                          c.nowIndex = 0.obs;
                                          await updateToday();
                                          Get.back();
                                          c.currentTab = RxInt(0);
                                          c.update();
                                        },
                                        onCancel: () async {
                                          c.nowIndex = 0.obs;
                                          await updateToday();
                                        }
                                    );
                                  }
                                }
                                ktMean.clear();
                                for (var i=0;i<c.mean.length;i++){
                                  ktMean.add(false);
                                }
                              }else{
                                Get.defaultDialog(
                                    title: c.learnRightTitle.string,
                                    middleText: c.learnRightBodyMean.string,
                                    backgroundColor: themeColor,
                                    titleStyle: const TextStyle(color: textColor,),
                                    middleTextStyle: const TextStyle(color: textColor,),
                                    textConfirm: c.learnNext.string,
                                    confirmTextColor: textColor,
                                    buttonColor: Colors.white,
                                    textCancel: "ok",
                                    cancelTextColor: textColor,
                                    barrierDismissible: false,
                                    radius: 8,
                                    onConfirm: () async {
                                      if (c.nowIndex.value < c.mean.length - 1){
                                        c.nowIndex = RxInt(c.nowIndex.value + 1);
                                        Get.back();
                                      }else{
                                        c.nowIndex = 0.obs;
                                        Get.back();
                                      }
                                      c.update();
                                    },
                                    onCancel: () async {
                                    }
                                );
                              }
                            }else{
                              ktMean[c.nowIndex.value] = false;
                              Get.snackbar(c.learnWrongTitle.string,c.learnWrongBodyMean.string);
                            }
                            if (c.enableSound.value){
                              await pool.play(soundId);
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
                              width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                              height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                              child: Stack(
                                  children:[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: ImageFiltered(
                                        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                        child: Opacity(
                                          opacity: 0.8,
                                          child: Image(
                                            image: NetworkImage('https://bedict.com/' + c.listImage[c.nowIndex.value][index].replaceAll('\\','')),
                                            fit: BoxFit.fill,
                                            width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                            height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                        image: NetworkImage('https://bedict.com/' + c.listImage[c.nowIndex.value][index].replaceAll('\\','')),
                                        fit: BoxFit.contain,
                                        width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                        height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ):index>randomPosition[c.nowIndex.value]?
                        GestureDetector(
                          onTap: () async {
                            if (c.listImage[c.nowIndex.value][index-1] == c.imageURL[c.listIndex[c.nowIndex.value]]){
                              ktMean[c.nowIndex.value] = true;
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
                                  if (c.meanScore.value==25){
                                    Get.defaultDialog(
                                      title: c.learnRightTitle.string,
                                      middleText: c.learnRightBodyAllMeanDone.string,
                                      backgroundColor: themeColor,
                                      titleStyle: const TextStyle(color: textColor,),
                                      middleTextStyle: const TextStyle(color: textColor,),
                                      textConfirm: c.learnNext.string,
                                      confirmTextColor: textColor,
                                      buttonColor: Colors.white,
                                      textCancel: "ok",
                                      cancelTextColor: textColor,
                                      barrierDismissible: false,
                                      radius: 8,
                                      onConfirm: () async {
                                        c.nowIndex = 0.obs;
                                        await updateToday();
                                        Get.back();
                                        c.currentTab = RxInt(0);
                                        c.update();
                                      },
                                      onCancel: () async {
                                        c.nowIndex = 0.obs;
                                        await updateToday();
                                      },
                                    );
                                  }else{
                                    Get.defaultDialog(
                                        title: c.learnRightTitle.string,
                                        middleText: c.learnRightBodyAllMean.string,
                                        backgroundColor: themeColor,
                                        titleStyle: const TextStyle(color: textColor,),
                                        middleTextStyle: const TextStyle(color: textColor,),
                                        textConfirm: c.learnNext.string,
                                        confirmTextColor: textColor,
                                        buttonColor: Colors.white,
                                        textCancel: "ok",
                                        cancelTextColor: textColor,
                                        barrierDismissible: false,
                                        radius: 8,
                                        onConfirm: () async {
                                          c.nowIndex = 0.obs;
                                          await updateToday();
                                          Get.back();
                                          c.currentTab = RxInt(0);
                                          c.update();
                                        },
                                        onCancel: () async {
                                          c.nowIndex = 0.obs;
                                          await updateToday();
                                        }
                                    );
                                  }
                                }
                                ktMean.clear();
                                for (var i=0;i<c.mean.length;i++){
                                  ktMean.add(false);
                                }
                              }else{
                                Get.defaultDialog(
                                    title: c.learnRightTitle.string,
                                    middleText: c.learnRightBodyMean.string,
                                    backgroundColor: themeColor,
                                    titleStyle: const TextStyle(color: textColor,),
                                    middleTextStyle: const TextStyle(color: textColor,),
                                    textConfirm: c.learnNext.string,
                                    confirmTextColor: textColor,
                                    buttonColor: Colors.white,
                                    textCancel: "ok",
                                    cancelTextColor: textColor,
                                    barrierDismissible: false,
                                    radius: 8,
                                    onConfirm: () async {
                                      if (c.nowIndex.value < c.mean.length - 1){
                                        c.nowIndex = RxInt(c.nowIndex.value + 1);
                                        Get.back();
                                      }else{
                                        c.nowIndex = 0.obs;
                                        Get.back();
                                      }
                                      c.update();
                                    },
                                    onCancel: () async {
                                    }
                                );
                              }
                            }else{
                              ktMean[c.nowIndex.value] = false;
                              Get.snackbar(c.learnWrongTitle.string,c.learnWrongBodyMean.string);
                            }
                            if (c.enableSound.value){
                              await pool.play(soundId);
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
                              width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                              height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                              child: Stack(
                                  children:[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: ImageFiltered(
                                        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                        child: Opacity(
                                          opacity: 0.8,
                                          child: Image(
                                            image: NetworkImage('https://bedict.com/' + c.listImage[c.nowIndex.value][index-1].replaceAll('\\','')),
                                            fit: BoxFit.fill,
                                            width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                            height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
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
                                        image: NetworkImage('https://bedict.com/' + c.listImage[c.nowIndex.value][index-1].replaceAll('\\','')),
                                        fit: BoxFit.contain,
                                        width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                                        height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ):
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
                          // alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width > 420? 180: (MediaQuery.of(context).size.width-60)/2,
                          height: MediaQuery.of(context).size.width > 420? 180*0.7: (MediaQuery.of(context).size.width-60)*0.7/2,
                          child: const NativeAdWidget()
                        )
                    ]
                  ),
                ),
              ),
            ),
          ),
          GetBuilder<Controller>(
            builder: (_) => DotsIndicator(
                dotsCount: c.mean.length,
                position: c.nowIndex.value.toDouble(),
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeColor: backgroundColor,
                  color: const Color.fromRGBO(230, 230, 230, 1),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  spacing: 19*c.mean.length>MediaQuery.of(context).size.width - 20 ?
                  EdgeInsets.fromLTRB(
                      ((MediaQuery.of(context).size.width-20)/c.mean.length-9)/2,
                      10,
                      ((MediaQuery.of(context).size.width-20)/c.mean.length-9)/2,
                      10
                  )
                      : const EdgeInsets.fromLTRB(5, 10, 5, 10),
                ),
                onTap: (index){
                  c.nowIndex = RxInt(index.toInt());
                  c.update();
                }
            ),
          ),
        ],
      ),
    );
  }
}

class LearnWord extends StatelessWidget {
  const LearnWord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    c.imageShow = (MediaQuery.of(context).size.width~/190).obs;
    List<Widget> widgetOptions = <Widget>[
      const WriteWidget(),
      const PronunWidget(),
      const SpeakWidget(),
      const MeanWidget(),
    ];

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      c.imageShow = (MediaQuery.of(context).size.width~/190).obs;
      c.update();
    });

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<Controller>(
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
        centerTitle: true,
        backgroundColor: backgroundColor,
        shadowColor: Colors.grey,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: themeColor, // Status bar
        ),
      ),
      body: Column(
          children: [
            // Container(
            //   color: backgroundColor,
            //   height: 50,
            //   child: Row(
            //     children: [
            //       const SizedBox(width: 10),
            //       SizedBox(
            //         width: 50,
            //         child: IconButton(
            //           icon: const Icon(
            //             Icons.arrow_back,
            //             size: 20,
            //             color: Colors.white,
            //           ),
            //           onPressed: () async {
            //             Get.back();
            //           },
            //         ),
            //       ),
            //       const SizedBox(width: 10),
            //       Expanded(
            //         child: GetBuilder<Controller>(
            //           builder: (_) => Text(
            //           c.currentTab.value == 0?
            //           c.learnWordGuide.string:
            //           c.currentTab.value == 1?
            //           c.learnPronunGuide.string:
            //           c.currentTab.value == 2?
            //           c.learnSpeakGuide.string + c.word.string:
            //           c.learnMeanGuide.string,
            //           textAlign: TextAlign.center,
            //           style: const TextStyle(
            //             fontSize: 14,
            //             color: textColor,
            //           ),
            //           overflow: TextOverflow.ellipsis,
            //         ),
            //         ),
            //       ),
            //       const SizedBox(width: 70),
            //     ]
            //   ),
            // ),
            Expanded(
              child: GetBuilder<Controller>(
                builder: (_) => Center(
                  child: widgetOptions.elementAt(c.currentTab.value),
                ),
              ),
            ),
          ]
      ),
      bottomNavigationBar: GetBuilder<Controller>(
        builder: (_) => BottomNavigationBar(
          currentIndex: c.currentTab.value,
          onTap: (int index) {
            c.currentTab = RxInt(index);
            c.update();
          },
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          unselectedItemColor: const Color.fromRGBO(170, 240, 195, 1),
          selectedItemColor: textColor,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.article),
              backgroundColor: backgroundColor,
              label: c.scoreWord.string.toLowerCase(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.volume_up_outlined),
              backgroundColor: backgroundColor,
              label: c.scorePronun.string.toLowerCase(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.record_voice_over),
              backgroundColor: backgroundColor,
              label: c.scoreSpeak.string.toLowerCase(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.art_track),
              backgroundColor: backgroundColor,
              label: c.scoreMean.string.toLowerCase(),
            ),
          ],
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
    int duration = 86400000;

    Future.delayed(Duration.zero, () async {
      c.listHistory = await getHistory(duration);
      c.update();
    });

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<Controller>(
          builder: (_) => Text(
          c.drawerHistory.string.toUpperCase(),
          style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children:[
          const SizedBox(
            height: 3,
          ),
          GroupButton(
            spacing: 5,
            selectedButton: 0,
            buttonWidth: (MediaQuery.of(context).size.width-20)/5,
            isRadio: true,
            direction: Axis.horizontal,
            onSelected: (index, isSelected) async {
              switch (index){
                case 0:
                  duration = 86400000;
                  break;
                case 1:
                  duration = 604800000;
                  break;
                case 2:
                  duration = 2629800000;
                  break;
                case 3:
                  duration = 31557600000;
                  break;
                case 4:
                  duration = DateTime.now().millisecondsSinceEpoch;
                  break;
              }
              c.listHistory = await getHistory(duration);
              c.update();
            },
            buttons: [c.day.string,c.week.string,c.month.string,c.year.string,c.all.string],
            // selectedButtons: [0, 1], /// [List<int>] after 2.2.1 version
            selectedTextStyle: const TextStyle(
              fontSize: 14,
              color: textColor,
            ),
            unselectedTextStyle: const TextStyle(
              fontSize: 14,
              color: textColor,
            ),
            selectedColor: backgroundColor,
            unselectedColor: themeColor,
            selectedBorderColor: backgroundColor,
            unselectedBorderColor: themeColor,
            borderRadius: BorderRadius.circular(3.0),
            selectedShadow: const <BoxShadow>[BoxShadow(color: Colors.transparent)],
            unselectedShadow: const <BoxShadow>[BoxShadow(color: Colors.transparent)],
          ),
          Expanded(
            child: GetBuilder<Controller>(
              builder: (_) =>  ListView.builder(
                padding: const EdgeInsets.all(4),
                itemCount: c.listHistory.length,
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
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.all(4),
                            color: const Color.fromRGBO(230, 240, 230, 1),
                            child: Text(
                              DateFormat('dd-MM-yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(c.listHistory[index].time)),
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
                            onTap: () async {
                              await setDefault();
                              c.wordArray.clear();
                              for (var i=0;i<c.listHistory.length;i++){
                                if (!c.wordArray.contains(c.listHistory[i].word)){
                                  c.wordArray.add(c.listHistory[i].word);
                                }
                              }
                              await c.layWord(c.listHistory[index].word);
                              Get.to(()=>Home());
                            },
                            child: Container(
                              height: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.all(4),
                              color: const Color.fromRGBO(230, 240, 230, 1),
                              child: Text(
                                c.listHistory[index].word,
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: backgroundColor,
          child: GetBuilder<Controller>(
            builder: (_) => Text(
              c.relearnButton.string,
              style: const TextStyle(
                color: textColor,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: () async {
            if (c.listHistory.isNotEmpty){
              await setDefault();
              c.wordArray.clear();
              for (var i=0;i<c.listHistory.length;i++){
                if (!c.wordArray.contains(c.listHistory[i].word)){
                  c.wordArray.add(c.listHistory[i].word);
                }
              }
              await c.layWord('');
              Get.to(()=>Home());
            }else{
              Get.to(()=>Home());
              Get.snackbar(c.learnWrongTitle.string,c.snackbarRelearn.string);
            }
          }
      ),
    );
  }
}

class ScorePage extends StatelessWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    int duration = 86400000;

    Future.delayed(Duration.zero, () async {
      c.listLearned = await getListScore(duration);
      c.update();
    });

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<Controller>(
          builder: (_) => Text(
          c.drawerScore.string.toUpperCase(),
          style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children:[
          const SizedBox(height: 3,),
          GroupButton(
            spacing: 5,
            selectedButton: 0,
            buttonWidth: (MediaQuery.of(context).size.width-20)/5,
            isRadio: true,
            direction: Axis.horizontal,
            onSelected: (index, isSelected) async {
              switch (index){
                case 0:
                  duration = 86400000;
                  break;
                case 1:
                  duration = 604800000;
                  break;
                case 2:
                  duration = 2629800000;
                  break;
                case 3:
                  duration = 31557600000;
                  break;
                case 4:
                  duration = DateTime.now().millisecondsSinceEpoch;
                  break;
              }
              c.listLearned = await getListScore(duration);
              c.update();
            },
            buttons: [c.day.string,c.week.string,c.month.string,c.year.string,c.all.string],
            // selectedButtons: [0, 1], /// [List<int>] after 2.2.1 version
            selectedTextStyle: const TextStyle(
              fontSize: 14,
              color: textColor,
            ),
            unselectedTextStyle: const TextStyle(
              fontSize: 14,
              color: textColor,
            ),
            selectedColor: backgroundColor,
            unselectedColor: themeColor,
            selectedBorderColor: backgroundColor,
            unselectedBorderColor: themeColor,
            borderRadius: BorderRadius.circular(3.0),
            selectedShadow: const <BoxShadow>[BoxShadow(color: Colors.transparent)],
            unselectedShadow: const <BoxShadow>[BoxShadow(color: Colors.transparent)],
          ),
          const SizedBox(height: 5,),
          Expanded(
            child: GetBuilder<Controller>(
              builder: (_) => Wrap(
              spacing: 10,
              runSpacing: 10,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              children: c.listLearned.map((Score score) {
                return GestureDetector(
                  onTap: () async{
                    await setDefault();
                    c.wordArray.clear();
                    for (var i=0;i<c.listLearned.length;i++){
                      c.wordArray.add(c.listLearned[i].wordId);
                    }
                    await c.layWord(score.wordId);
                    Get.to(()=>Home());
                  },
                  child: Container(
                    // height: 105,
                    width: MediaQuery.of(context).size.width*0.5 - 15,
                    // padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8)
                      ),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.6),
                      //     spreadRadius: 0,
                      //     blurRadius: 5,
                      //     offset: const Offset(5, 5), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height:5),
                        Text(
                          score.wordId,
                          style: const TextStyle(
                            fontSize: 15,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height:5),
                        Row(
                          children: [
                            const SizedBox(width:3),
                            Expanded(
                              child: CircularPercentIndicator(
                                radius: (MediaQuery.of(context).size.width*0.5 - 30)/4,
                                lineWidth: 3.0,
                                animation: true,
                                percent: score.word/25,
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
                                radius: (MediaQuery.of(context).size.width*0.5 - 30)/4,
                                lineWidth: 3.0,
                                animation: true,
                                percent: score.pronun/25,
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
                                radius: (MediaQuery.of(context).size.width*0.5 - 30)/4,
                                lineWidth: 3.0,
                                animation: true,
                                percent: score.speak/25,
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
                                radius: (MediaQuery.of(context).size.width*0.5 - 30)/4,
                                lineWidth: 3.0,
                                animation: true,
                                percent: score.mean/25,
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
                            const SizedBox(width:3),
                          ],
                        ),
                        const SizedBox(height:5),
                        GetBuilder<Controller>(
                          builder: (_) => LinearPercentIndicator(
                            alignment: MainAxisAlignment.center,
                            // width: MediaQuery.of(context).size.width-20,
                            lineHeight: 10.0,
                            percent: score.total/100,
                            backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
                            progressColor: backgroundColor,
                            // padding: const EdgeInsets.all(5),
                            animation: true,
                            center: Text(
                                c.scoreTotal.string,
                                style: const TextStyle(
                                  fontSize: 8,
                                )
                            ),
                          ),
                        ),
                        const SizedBox(height:5),
                      ]
                    ),
                  ),
                );
              }).toList(),
            ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: backgroundColor,
          child: GetBuilder<Controller>(
            builder: (_) => Text(
              c.relearnButton.string,
              style: const TextStyle(
                color: textColor,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: () async {
            if (c.listLearned.isNotEmpty){
              await setDefault();
              c.wordArray.clear();
              for (var i=0;i<c.listLearned.length;i++){
                c.wordArray.add(c.listLearned[i].wordId);
              }
              await c.layWord('');
              Get.to(()=>Home());
            }else{
              Get.to(()=>Home());
              Get.snackbar(c.learnWrongTitle.string,c.snackbarRelearn.string);
            }
          }
      ),
    );
  }
}

class MyUpgradePage extends StatefulWidget {
  const MyUpgradePage({Key? key}) : super(key: key);

  @override
  UpgradePage createState() => UpgradePage();
}

class UpgradePage extends State<MyUpgradePage> {
  var _purchasePending = false;
  late StreamSubscription _subscription;
  final Controller c = Get.put(Controller());

  @override
  void initState() { // called immediately after the widget is allocated memory
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      c.purchases = purchaseDetailsList;
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      Get.snackbar('fail','miss');
    });
    initStore();
    super.initState();
  }

  Future<void> initStore() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      return;
    }
    const Set<String> _kIds = <String>{'month', 'year'};
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      Get.snackbar('fail','miss');
      return;
    }
    c.products = response.productDetails;
    Get.snackbar(c.products[0].id,c.products[1].id);
  }

  @override
  void dispose() { // called just before the Controller is deleted from memory
    _subscription.cancel();
    super.dispose();
  }
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
          Get.snackbar('congratulation','success');
        }
      }
    });
  }
  void showPendingUI() {
    _purchasePending = true;
  }
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    final response = await http.post(
      Uri.parse('https://bedict.com/checkPay.php'),
      body: <String, String>{
        'token': purchaseDetails.verificationData.serverVerificationData,
      },
    );
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) != 'error'){
        if (int.parse(jsonDecode(response.body)) > DateTime.now().millisecondsSinceEpoch){
          return true;
        }else{
          return false;
        }
      }else{
        return false;
      }
    } else {
      return false;
    }
    // return Future<bool>.value(true);
  }
  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == 'month') {
      _purchasePending = false;
      c.purchases.add(purchaseDetails);
      Get.snackbar('bought',purchaseDetails.productID);
    }
    if (purchaseDetails.productID == 'year') {
      _purchasePending = false;
      c.purchases.add(purchaseDetails);
    }
  }
  void handleError(IAPError error) {
    _purchasePending = false;
    Get.snackbar('error','miss');
  }
  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }


  @override
  Widget build(BuildContext context) {
    const textColor = Color.fromRGBO(3, 64, 24, 1);
    const backgroundColor = Color.fromRGBO(147, 219, 172, 1);
    const themeColor = Color.fromRGBO(230, 255, 240, 1);

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<Controller>(
          builder: (_) => Text(
            c.drawerScore.string.toUpperCase(),
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children:[
          Row(
            children:[
              Expanded(
                child: TextButton(
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
                      const Icon(
                        Icons.volume_up_outlined,
                        size: 25,
                        color: textColor,
                      ),
                      Expanded(
                        child: GetBuilder<Controller>(
                          builder: (_) => Text(
                            c.pronun.string,
                            style: const TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    final ProductDetails productDetails = c.products[0];
                    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
                    InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
                  },
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    Future.delayed(Duration.zero, () async {

    });

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<Controller>(
          builder: (_) => Text(
          c.drawerContact.string.toUpperCase(),
          style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: Container(
        alignment: Alignment.center,
        // color: Colors.red,
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
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    Future.delayed(Duration.zero, () async {
      var box = await Hive.openBox('data');
      final response = await http.get(Uri.parse('https://drive.google.com/uc?export=download&id=1vUu4qZjTS5tpndNEHTBHaE51rr6y0sP_'),headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        List data = json.decode(utf8.decode(response.bodyBytes));
        for (var i=0;i<data.length;i++){
          await box.put(data[i]['word'],data[i]);
        }
        await box.close();
        var boxSetting = await Hive.openBox('setting');
        await boxSetting.put('isIntroduce',false);
        await boxSetting.close();
        Get.to(()=>Home());
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
            Get.back();
          },
          onCancel: () async {
            Get.back();
          },
        );
      }

    });

    return Scaffold(
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

    return Scaffold(
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
          Get.to(()=>Introduce());
        }
      ),
    );
  }
}

Future<bool> getListWords(String levelString, String category, String type) async {
  final Controller c = Get.put(Controller());
  int getLevel(String level){
    int levelFind = 20;
    switch(level) {
      case '8.000 từ':
        levelFind = 8;
        break;
      case '8.000 words':
        levelFind = 8;
        break;
      case '5.000 từ':
        levelFind = 5;
        break;
      case '5.000 words':
        levelFind = 5;
        break;
      case '3.000 từ':
        levelFind = 3;
        break;
      case '3.000 words':
        levelFind = 3;
        break;
      default:
        levelFind = 20;
    }
    return levelFind;
  }
  int level = getLevel(levelString);
  List<String> findList = <String>[];
  var box = await Hive.openBox('data');
  for (var i=0;i<box.length;i++){
    var nowWord = await box.getAt(i);
    if (category != 'category'){
      if (nowWord['category'].contains(','+ category) && int.parse(nowWord['level']) <= level){
        findList.add(nowWord['word']);
      }
    }else{
      if (type != 'type'){
        if ((nowWord['type'].startsWith(type) || nowWord['type'].contains(' $type'))
            && int.parse(nowWord['level']) <= level){
          findList.add(nowWord['word']);
        }
      }else{
        if (int.parse(nowWord['level']) <= level){
          findList.add(nowWord['word']);
        }
      }
    }
  }
  box.close();
  if (findList.isEmpty){
    return false;
  }else{
    findList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    c.wordArray = findList;
    return true;
  }
}

Future getWord(String word) async {
  // final String response = await rootBundle.loadString('assets/data.json');
  // List data = json.decode(response);
  // return data.where((element) => element['word'] == word).toList()[0];
  var box = await Hive.openBox('data');
  dynamic data = await box.get(word);
  await box.close();
  return data;
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

void arrangeLearnMean() {
  final Controller c = Get.put(Controller());
  c.currentTab = 0.obs;
  c.listIndex = [];
  c.listImage = [];
  c.listArrange = [for (int i=0; i<c.word.string.split('').length; i++)''];
  c.listRandom = [for (int i=0; i<c.word.string.split('').length; i++)''];
  c.listArrangePronun = [for (int i=0; i<c.pronun.string.split('').length; i++)''];
  c.listRandomPronun = [for (int i=0; i<c.pronun.string.split('').length; i++)''];
  for (var i=0; i<c.mean.length; i++){
    c.listIndex.add(i);
  }
  c.listIndex.shuffle();
  for (var i=0; i<c.mean.length; i++){
    List<String> subListImage = <String>[];
    if (c.mean.length<3){
      subListImage = List<String>.from(c.imageURL.toList());
    }else{
      subListImage.add(c.imageURL[c.listIndex[i]]);
      for (var j=0;j<2;j++){
        int newRandomIndex = 0;
        while (subListImage.contains(c.imageURL[newRandomIndex])){
          newRandomIndex = Random().nextInt(c.mean.length);
        }
        subListImage.add(c.imageURL[newRandomIndex]);
      }
    }
    subListImage.shuffle();
    c.listImage.add(subListImage);
  }
}

Future _speak(String string) async{
  final Controller c = Get.put(Controller());
  final FlutterTts flutterTts = FlutterTts();
  await flutterTts.setLanguage("en-US");
  await flutterTts.setSpeechRate(c.speakSpeed.value);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.0);
  await flutterTts.awaitSpeakCompletion(true);
  await flutterTts.speak(string);
}

Future updateToday() async{
  final Controller c = Get.put(Controller());
  var yesterday = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      0, 0
  );
  c.listLearnedToday.clear();
  List<Score> listScore = await getListScore(DateTime.now().difference(yesterday).inMilliseconds);
  for (var i=0;i<listScore.length;i++){
    if (c.listWordsToday.contains(listScore[i].wordId)){
      c.listLearnedToday.add(listScore[i]);
    }
  }
  c.update();
}

Future setDefault() async {
  final Controller c = Get.put(Controller());
  var box = await Hive.openBox('setting');
  await box.put('category',0);
  await box.put('type',0);
  await box.put('level',0);
  await box.close();
  c.category = RxString('category');
  c.type = RxString('type');
  c.level = RxString('all words');
  c.categoryIndex = 0.obs;
  c.typeIndex = 0.obs;
  c.levelIndex = 0.obs;
}

bool checkSubMean(List<String> subMean){
  final Controller c = Get.put(Controller());
  bool ktCategory = false;
  bool ktType = false;
  for(var j = 0; j< subMean.length; j++) {
    if (c.category.string != 'category'){
      if (subMean[j].contains('#')){
        if(subMean[j].split('#')[0].split(',').contains(c.category.string)){
          ktCategory = true;
        }
      }
    }else{
      ktCategory = true;
    }
    if (c.type.string != 'type'){
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
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    final database = openDatabase(
      join(await getDatabasesPath(), 'data.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute(
          'CREATE TABLE scores(wordId TEXT PRIMARY KEY, word INTEGER, pronun INTEGER, speak INTEGER, mean INTEGER, total INTEGER, time INTEGER)',
        );
        db.execute(
          'CREATE TABLE history(time INTEGER PRIMARY KEY, word TEXT)',
        );
      },
      version: 1,
    );
    final db = await database;
    var newSearch = History(
      time: DateTime.now().millisecondsSinceEpoch,
      word: wordSearch,
    );
    await db.insert(
      'history',
      newSearch.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

Future<List<History>> getHistory(int duration) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'data.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute(
        'CREATE TABLE scores(wordId TEXT PRIMARY KEY, word INTEGER, pronun INTEGER, speak INTEGER, mean INTEGER, total INTEGER, time INTEGER)',
      );
      db.execute(
        'CREATE TABLE history(time INTEGER PRIMARY KEY, word TEXT)',
      );
    },
    version: 1,
  );
  final db = await database;
  List<Map> maps = await db.query ('history',
      columns: ['time','word'],
      orderBy: 'time DESC',
      where: 'time > ?',
      whereArgs: [DateTime.now().millisecondsSinceEpoch - duration]
  );
  return List.generate(maps.length, (i) {
    return History(
      time: maps[i]['time'],
      word: maps[i]['word'],
    );
  });
}

Future<Score> getScore(String wordScore) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'data.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE scores(wordId TEXT PRIMARY KEY, word INTEGER, pronun INTEGER, speak INTEGER, mean INTEGER, total INTEGER, time INTEGER)',
      );
      db.execute(
        'CREATE TABLE history(time INTEGER PRIMARY KEY, word TEXT)',
      );
    },
    version: 1,
  );
  final db = await database;
  List<Map> maps = await db.query(
      'scores',
      columns: ['wordId', 'word', 'pronun', 'speak', 'mean', 'total','time'],
      where: 'wordId = ?',
      whereArgs: [wordScore]
  );
  return Score(
    wordId: maps[0]['wordId'],
    word: maps[0]['word'],
    pronun: maps[0]['pronun'],
    speak: maps[0]['speak'],
    mean: maps[0]['mean'],
    total: maps[0]['total'],
    time: DateTime.now().millisecondsSinceEpoch,
  );
}

Future<List<Score>> getListScore(int duration) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'data.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute(
        'CREATE TABLE scores(wordId TEXT PRIMARY KEY, word INTEGER, pronun INTEGER, speak INTEGER, mean INTEGER, total INTEGER, time INTEGER)',
      );
      db.execute(
        'CREATE TABLE history(time INTEGER PRIMARY KEY, word TEXT)',
      );
    },
    version: 1,
  );
  final db = await database;
  List<Map> maps = await db.query (
      'scores',
      columns: ['wordId', 'word', 'pronun', 'speak', 'mean', 'total','time'],
      orderBy: 'time DESC',
      where: 'time > ?',
      whereArgs: [DateTime.now().millisecondsSinceEpoch - duration]
  );
  return List.generate(maps.length, (i) {
    return Score(
      wordId: maps[i]['wordId'],
      word: maps[i]['word'],
      pronun: maps[i]['pronun'],
      speak: maps[i]['speak'],
      mean: maps[i]['mean'],
      total: maps[i]['total'],
      time: DateTime.now().millisecondsSinceEpoch,
    );
  });
}

Future insertScore(String wordScore) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'data.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE scores(wordId TEXT PRIMARY KEY, word INTEGER, pronun INTEGER, speak INTEGER, mean INTEGER, total INTEGER, time INTEGER)',
      );
      db.execute(
        'CREATE TABLE history(time INTEGER PRIMARY KEY, word TEXT)',
      );
    },
    version: 1,
  );
  final db = await database;
  var newScore = Score(
    wordId: wordScore,
    word: 0,
    pronun: 0,
    speak: 0,
    mean: 0,
    total: 0,
    time: DateTime.now().millisecondsSinceEpoch,
  );
  await db.insert(
    'scores',
    newScore.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<bool> checkScore(String wordScore) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'data.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE scores(wordId TEXT PRIMARY KEY, word INTEGER, pronun INTEGER, speak INTEGER, mean INTEGER, total INTEGER, time INTEGER)',
      );
      db.execute(
        'CREATE TABLE history(time INTEGER PRIMARY KEY, word TEXT)',
      );
    },
    version: 1,
  );
  final db = await database;
  List<Map> maps = await db.query(
      'scores',
      columns: ['wordId'],
      where: 'wordId = ?',
      whereArgs: [wordScore]);
  if (maps.isNotEmpty) {
    return true;
  }else{
    return false;
  }
}

Future updateScore(Score dataScore) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'data.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE scores(wordId TEXT PRIMARY KEY, word INTEGER, pronun INTEGER, speak INTEGER, mean INTEGER, total INTEGER, time INTEGER)',
      );
      db.execute(
        'CREATE TABLE history(time INTEGER PRIMARY KEY, word TEXT)',
      );
    },
    version: 1,
  );
  final db = await database;
  await db.update(
      'scores',
      dataScore.toMap(),
      where: 'wordId = ?',
      whereArgs: [dataScore.wordId]
  );
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

Future<List<String>> getScoreScore() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'data.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute(
        'CREATE TABLE scores(wordId TEXT PRIMARY KEY, word INTEGER, pronun INTEGER, speak INTEGER, mean INTEGER, total INTEGER, time INTEGER)',
      );
      db.execute(
        'CREATE TABLE history(time INTEGER PRIMARY KEY, word TEXT)',
      );
    },
    version: 1,
  );
  final db = await database;
  List<Map> maps = await db.query (
    'scores',
    columns: ['wordId'],
    orderBy: 'total ASC',
    limit: 10,
  );
  return List.generate(maps.length, (i) {
    return maps[i]['wordId'];
  });
}
Future<List<String>> getScoreTime() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'data.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute(
        'CREATE TABLE scores(wordId TEXT PRIMARY KEY, word INTEGER, pronun INTEGER, speak INTEGER, mean INTEGER, total INTEGER, time INTEGER)',
      );
      db.execute(
        'CREATE TABLE history(time INTEGER PRIMARY KEY, word TEXT)',
      );
    },
    version: 1,
  );
  final db = await database;
  List<Map> maps = await db.query (
    'scores',
    columns: ['wordId'],
    orderBy: 'time DESC',
    limit: 10,
  );
  return List.generate(maps.length, (i) {
    return maps[i]['wordId'];
  });
}

Future showNotificationWord() async {
  var box = await Hive.openBox('data');
  final Controller c = Get.put(Controller());
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  List<String> listWord = <String>[];
  List<String> listScoreScore = await getScoreScore();
  for (var i=0;i< listScoreScore.length;i++){
    if (!listWord.contains(listScoreScore[i])){
      listWord.add(listScoreScore[i]);
    }
  }
  List<String> listScoreTime = await getScoreTime();
  for (var i=0;i< listScoreTime.length;i++){
    if (!listWord.contains(listScoreTime[i])){
      listWord.add(listScoreTime[i]);
    }
  }

  String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  for (var i=1;i<18;i++){
    var dataRaw = box.get(listWord[Random().nextInt(listWord.length)]);
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
      // schedule: NotificationInterval(interval: i*5, timeZone: localTimeZone),
      schedule: NotificationCalendar(
        second: 0, millisecond: 0,
        minute: 0,
        hour: 5 + i,
        timeZone: localTimeZone, repeats: true,
        allowWhileIdle: true,
      )
    );
  }
}

Future showWord(String wordShow) async {
  if (wordShow != 'Daily'){
    var box = await Hive.openBox('setting');

    final Controller c = Get.put(Controller());

    c.category = RxString('category');
    await box.put('category',0);

    c.type = RxString('type');
    await box.put('type',0);

    c.categoryIndex = 0.obs;
    c.typeIndex = 0.obs;
    c.levelIndex = 0.obs;

    c.level = RxString('all words');
    await box.put('level',0);
    await box.close();

    final String response = await rootBundle.loadString('assets/allWords.json');
    final data = await json.decode(response);
    c.wordArray = data.cast<String>();

    c.word = RxString(wordShow);

    await c.layWord(c.word.string);
  }
  Get.to(()=>Home());
}