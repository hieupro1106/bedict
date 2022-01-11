// import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:ui';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:io' show Platform;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
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
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soundpool/soundpool.dart';

List<String> listCategoryVN = ["tất cả chủ đề","khả năng","trừu tượng","thành tích","hành động","tuổi tác","nông nghiệp",
"trợ giúp","số lượng","giải phẫu","động vật","vẻ ngoài","khảo cổ học","kiến trúc","khu vực",
"nghệ thuật","khía cạnh","tài sản","chiêm tinh học","thiên văn học","thái độ","thực thể",
"rung chuông","cá cược","hoá sinh học","sinh học","chim","cơ thể","nhà cửa","việc làm ăn",
"tính cách","hoá học","màu sắc","thương mại","liên lạc","hỗn hợp","máy tính","điều kiện",
"châu lục","văn hoá","chửi thề","nhảy","mức độ","nhu cầu","thiết bị","hướng","thảm hoạ",
"bệnh tật","học thuyết","uống","sinh thái học","kinh tế","giáo dục","điện","điện tử",
"nguyên tố","cảm xúc","năng lượng","giải trí","môi trường","sự kiện","câu cảm thán",
"gia đình","lễ hội","hình khối","tài chính","cá","đồ ăn","tần suất","hoa quả","nhiên liệu",
"chức năng","future","trò chơi","khoảng trống","địa lý","địa chất","nhà nước","ngữ pháp",
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
"trang phục","thời tiết","từ","công việc","thế giới","viết lách","không chủ đề"];
List<String> listCategoryEN = ["all category","ability","abstract","achievement",
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
"vegetable","vehicle","virus","war","way","weapon","wear","weather","word","work","world","writing","no category"];

List<String> listLevelVN = ['tất cả từ', '8.000 từ','5.000 từ','3.000 từ'];
List<String> listLevelEN = ['all words', '8.000 words','5.000 words','3.000 words'];

List<String> listTypeVN = ["tất cả từ loại","danh từ","động từ","tính từ","trạng từ","đại từ","từ viết tắt", "từ cảm thán",
  "giới từ","liên từ", "từ hạn định sở hữu","đại từ sở hữu","cụm từ","từ rút gọn",
  "động từ khiếm khuyết","từ hạn định","số đếm","số thứ tự",
  "tiểu từ nguyên mẫu", "từ chỉ định","trợ động từ","trạng từ nghi vấn",
  "đại từ nghi vấn","đại từ quan hệ","trạng từ quan hệ"];
List<String> listTypeEN = ["all type","noun","verb","adjective","adverb","pronoun","abbreviation","exclamation",
  "preposition","conjunction", "possessive determiner","possessive pronoun","phrase","contraction",
  "modal verb","determiner","cardinal number","ordinal number",
  "infinitive particle","predeterminer","auxiliary verb","interrogative adverb",
  "interrogative pronoun","relative pronoun","relative adverb"];

// const textColor = Color.fromRGBO(3, 64, 24, 1);
const textColor = Colors.black;
const backgroundColor = Color.fromRGBO(147, 219, 172, 1);
const themeColor = Color.fromRGBO(230, 255, 240, 1);
final Shader linearGradient = const LinearGradient(
  colors: <Color>[Color.fromRGBO(150,173,10,1), Color.fromRGBO(53,61,1,1)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Soundpool pool = Soundpool.fromOptions();
late int soundId;
late int soundIdRight;
late int soundIdWrong;

int initLanguageIndex = 0;
late SpeechToText stt;
late FlutterTts flutterTts;
late AnimationController controller;
FocusNode searchFocusNode = FocusNode();
late var box;
late var boxSetting;
late var boxScore;
late var boxHistory;

final searchField = TextEditingController();

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
  var initLanguage = await boxSetting.get('language') ?? 'VN';
  if (initLanguage == 'VN'){
    initLanguageIndex = 0;
  }else{
    initLanguageIndex = 1;
  }

  String vipToken = await boxSetting.get('vipToken') ?? '';
  if (vipToken != ''){
    c.isVip = RxBool(await checkExpire(vipToken));
  }

  c.notifyDaily = RxBool(await boxSetting.get('notifyDaily') ?? false);
  c.selectedTime = RxString(await boxSetting.get('timeDaily') ?? '20:00');
  c.notifyWord = RxBool(await boxSetting.get('notifyWord') ?? false);
  c.enableSound = RxBool(await boxSetting.get('enableSound') ?? true);
  c.initSpeak = RxBool(await boxSetting.get('initSpeak') ?? true);
  c.category = RxString(listCategoryEN[await boxSetting.get('category') ?? 0]);
  c.type = RxString(listTypeEN[await boxSetting.get('type') ?? 0]);
  c.level = RxString(listLevelEN[await boxSetting.get('level') ?? 0]);
  c.word = RxString(await boxSetting.get('word') ?? 'hello');
  c.speakSpeed = RxDouble(await boxSetting.get('speakSpeed') ?? 0.3);
  c.target = RxInt(await boxSetting.get('target') ?? 10);
  c.notificationInterval = RxInt(await boxSetting.get('notificationInterval') ?? 60);
  c.language = RxString(await boxSetting.get('language') ?? c.language.string);
  c.categoryIndex = RxInt(await boxSetting.get('category') ?? 0);
  c.typeIndex = RxInt(await boxSetting.get('type') ?? 0);
  c.levelIndex = RxInt(await boxSetting.get('level') ?? 0);
  if (c.language.string == 'VN'){
    c.listCategory = listCategoryVN;
    c.listType = listTypeVN;
    c.listLevel = listLevelVN;
  }else{
    c.listCategory = listCategoryEN;
    c.listType = listTypeEN;
    c.listLevel = listLevelEN;
  }
  bool isIntroduce = await boxSetting.get('isIntroduce') ?? true;

  if (c.notifyWord.value){
    await AwesomeNotifications().dismissNotificationsByChannelKey('word');
    await AwesomeNotifications().cancelSchedulesByChannelKey('word');
    showNotificationWord();
  }

  runApp(
    GetMaterialApp(
      title: "BeDict",
      home: isIntroduce? const WelcomePage(): Home(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class Controller extends GetxController{

  late StreamSubscription subscription;
  var available = false.obs;
  List<ProductDetails> products = <ProductDetails>[].obs;

  @override
  void onInit() async {
    stt = SpeechToText();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
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
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      subscription.cancel();
    }, onError: (error) {
      Get.snackbar('fail',error.toString());
    });
    initStore();
    super.onInit();
  }

  @override
  void onClose() {
    pool.dispose();
    box.close();
    boxScore.close();
    boxHistory.close();
    boxSetting.close();
    subscription.cancel();
    flutterTts.stop();
    stt.cancel();
    super.onClose();
  }

  Future<void> initStore() async {
    final bool _available = await InAppPurchase.instance.isAvailable();
    available = RxBool(_available);
    if (!available.value) {
      return;
    }
    const Set<String> _kIds = <String>{'year'};
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      Get.snackbar('fail','not found product');
      return;
    }
    products = response.productDetails;
  }

  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          Get.snackbar('error',PurchaseStatus.error.toString());
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails.verificationData.serverVerificationData);
          if (valid) {
            await boxSetting.put('vipToken',purchaseDetails.verificationData.serverVerificationData);
            isVip = RxBool(valid);
            update();
          } else {
            Get.snackbar('fail','can not register');
            return;
          }
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
            Get.snackbar('congratulation','success');
          }
        }
      }
    });
  }

  var lastHistoryIndex = 0.obs;
  var learnRight = false.obs;
  var right = false.obs;
  var isSearch = false.obs;
  var isSearching = false.obs;
  var playing = true.obs;
  var nowMean = 0.obs;
  var expire = 0.obs;
  List<String> listRandom = <String>[].obs;
  List<String> listArrange = <String>[].obs;
  List<String> listRandomPronun = <String>[].obs;
  List<String> listArrangePronun = <String>[].obs;
  List<bool> isSelectedBundle = [true,false,false,false].obs;
  List<bool> isSelectedSort = [true,false].obs;
  List<bool> isSelectedSortScore = [true,false].obs;
  List<bool> isSortScore = [true,false].obs;
  var typeIndexScore = 0.obs;
  var categoryIndexScore = 0.obs;
  var levelIndexScore = 0.obs;
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
  var isSortScoreOpen = false.obs;
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
  var nowIndex = 0.obs;
  List mean = [].obs;
  List meanVN = [].obs;
  List meanEN = [].obs;
  List imageURL = [].obs;
  List<List> listImage = <List>[].obs;
  List<int> listIndex = <int>[].obs;
  var word = ''.obs;
  var wordPrevious = ''.obs;
  var wordNext = ''.obs;
  var typeState = 0.obs;
  var pronun = ''.obs;

  var category = 'all category'.obs;
  var categoryIndex = 0.obs;
  List<String> listCategory = listCategoryVN.obs;

  var type = 'all type'.obs;
  var typeIndex = 0.obs;
  List<String> listType = listTypeVN.obs;

  var level = 'tất cả từ'.obs;
  var levelIndex = 0.obs;
  List<String> listLevel = listLevelVN.obs;

  var focusedIndex = 0.obs;
  List<String> wordArray = <String>[].obs;
  var currentTab = 0.obs;

  var wordScore = 0.obs;
  var pronunScore = 0.obs;
  var speakScore = 0.obs;
  var meanScore = 0.obs;

  var duration = 86400000;
  List<History> listHistory = <History> [].obs;
  List<Score> listLearned = <Score> [].obs;
  List<Score> listLearnedToday = <Score> [].obs;

  var notifyDaily = false.obs;
  var notifyWord = false.obs;
  var selectedTime = '20:00'.obs;
  var target = 10.obs;

  var speakSpeed = 0.3.obs;

  var isAdShowing = false.obs;

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
  var learnWrongTitle = 'Rất tiếc!'.obs;
  var learnMeanGuide = 'gõ vào ảnh tương ứng với nghĩa'.obs;
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
  var newRandomWordTitle = 'từ mới'.obs;
  var adTitle = 'QUẢNG CÁO'.obs;
  var adBody = 'Quảng cáo giúp ứng dụng miễn phí'.obs;
  var loadingBody = 'Đang tải từ điển, vui lòng đợi trong giây lát'.obs;
  var loadingFailTitle = 'Tải lỗi'.obs;
  var loadingFailBody = 'Đảm bảo có kết nối Internet, vui lòng tải lại sau'.obs;
  var welcomeBody = 'Chào mừng bạn đến với BeDict - từ điển thú vị chờ bạn khám phá'.obs;
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
    language = RxString(newLanguage);
    if (language.string == 'VN'){
      initLanguageIndex = 0;
      await boxSetting.put('language','VN');
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
      learnWrongTitle = 'Rất tiếc!'.obs;
      learnMeanGuide = 'gõ vào ảnh tương ứng với nghĩa'.obs;
      learnedWordsTodayTitle = 'mục tiêu:'.obs;
      newRandomWordTitle = 'từ mới'.obs;
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
      welcomeBody = 'Chào mừng bạn đến với BeDict - từ điển thú vị chờ bạn khám phá'.obs;
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
      await boxSetting.put('language','EN');
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
      learnWrongTitle = 'Sorry!'.obs;
      learnMeanGuide = 'tap the image fit following mean'.obs;
      learnedWordsTodayTitle = 'target:'.obs;
      newRandomWordTitle = 'other word'.obs;
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
      welcomeBody = 'Welcome you to BeDict - interesting dictionary is waiting for you to discover'.obs;
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
    update();
  }
  changeLevel(int index) async{
    List<String> listWord = await getListWords(listLevel[index],category.string,type.string);
    if (listWord.isEmpty){
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      Get.snackbar(learnWrongTitle.string,notFound.string);
    }else{
      wordArray = RxList(listWord);
      levelIndex = RxInt(index);
      level = RxString(listLevel[index]);
      await boxSetting.put('level',index);
      word = RxString(listWord[0]);
      await layWord(word.string);
    }
  }
  changeCategory(int index) async {
    typeIndex = 0.obs;
    type = 'all type'.obs;
    await boxSetting.put('type',0);
    List<String> listWord = await getListWords(level.string,listCategoryEN[index],type.string);
    if (listWord.isEmpty){
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      Get.snackbar(learnWrongTitle.string,notFound.string);
      update();
    }else{
      wordArray = RxList(listWord);
      categoryIndex = RxInt(index);
      category = RxString(listCategoryEN[index]);
      await boxSetting.put('category',index);
      word = RxString(listWord[0]);
      await layWord(word.string);
    }
  }
  changeType(int index) async {
    categoryIndex = 0.obs;
    category = 'all category'.obs;
    await boxSetting.put('category',0);
    List<String> listWord = await getListWords(level.string,category.string,listTypeEN[index]);
    if (listWord.isEmpty){
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      Get.snackbar(learnWrongTitle.string,notFound.string);
      update();
    }else{
      wordArray = RxList(listWord);
      typeIndex = RxInt(index);
      type = RxString(listTypeEN[index]);
      await boxSetting.put('type',index);
      word = RxString(listWord[0]);
      await layWord(word.string);
    }
  }
  Future layWord(String newWord) async {
    focusedIndex = 0.obs;
    isSearching = true.obs;
    int h = wordArray.indexOf(newWord);
    word = RxString(wordArray[h]);
    await boxSetting.put('word',word.string);
    searchField.text = word.string;
    Score currentScore = await getScore(word.string);
    wordScore = RxInt(currentScore.word);
    pronunScore = RxInt(currentScore.pronun);
    speakScore = RxInt(currentScore.speak);
    meanScore = RxInt(currentScore.mean);
    await insertHistory(word.string);
    if (h>0){
      wordPrevious = RxString(wordArray[h-1]);
    }else{
      wordPrevious = RxString(wordArray[wordArray.length-1]);
    }
    if (h<(wordArray.length-1)){
      wordNext = RxString(wordArray[h+1]);
    }else{
      wordNext = RxString(wordArray[0]);
    }
    var dataRaw = await box.get(word.string);
    word = RxString(dataRaw['word']);
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
        listImage.add([]);
        if (i>=jsonDecode(dataRaw['imageURL']).length){
          imageURL.add('bedict.png');
        }else{
          imageURL.add(jsonDecode(dataRaw['imageURL'])[i]);
        }
      }
    }
    nowMean = 0.obs;
    arrangeLearnMean();
    await changeLanguage(language.string);
    if (initSpeak.value) await _speak(word.string);
  }

}

class Introduce extends StatelessWidget {
  Introduce({Key? key}) : super(key: key);
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    Get.to(()=>const LoadingPage());
  }

  Widget _buildImage(String assetName, [double width = 300]) {
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

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: c.introduce0Title.string,
          body: c.introduce0Body.string,
          image: _buildImage(c.language.string == 'VN'?'img0.jpg':'img0EN.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: c.introduce1Title.string,
          body: c.introduce1Body.string,
          image: _buildImage(c.language.string == 'VN'?'img1.jpg':'img1EN.jpg'),
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
          image: _buildImage(c.language.string == 'VN'?'img3.jpg':'img3EN.jpg'),
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
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(context) {
    final Controller c = Get.put(Controller());
    List<String> suggestArray = [];

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

    Future.delayed(Duration.zero, () async {
      if (c.initState.value){
        soundId = await rootBundle.load("assets/tap.mp3").then((ByteData soundData) {
          return pool.load(soundData);
        });
        soundIdRight = await rootBundle.load("assets/right.mp3").then((ByteData soundData) {
          return pool.load(soundData);
        });
        soundIdWrong = await rootBundle.load("assets/wrong.mp3").then((ByteData soundData) {
          return pool.load(soundData);
        });
        c.initState = false.obs;
        List<String> listWord = await getListWords(c.level.string,c.category.string,c.type.string);
        if (listWord.isEmpty){
          if (Get.isSnackbarOpen) Get.closeAllSnackbars();
          Get.snackbar(c.learnWrongTitle.string,c.notFound.string);
        }else{
          c.wordArray = RxList(listWord);
          await c.layWord(c.word.string);
        }
        await updateToday();
      }
    });

    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width*0.7,
        child: Drawer(
          backgroundColor: Colors.white.withOpacity(0.8),
            child: Column(
                children: [
                  DrawerHeader(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.4),
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
                  const SizedBox(height: 15),
                  Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            child: GetBuilder<Controller>(
                              builder: (_) => ToggleButtons(
                                fillColor: backgroundColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30)
                                ),
                                disabledColor: themeColor,
                                children: <Widget>[
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width*0.7-25)*3/9,
                                    child: Text(
                                      c.language.string == 'VN'? 'tất cả từ': 'all words',
                                      style: const TextStyle(
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width*0.7-25)*2/9,
                                    child: const Text(
                                      '8.000',
                                      style: TextStyle(
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width*0.7-25)*2/9,
                                    child: const Text(
                                      '5.000',
                                      style: TextStyle(
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width*0.7-25)*2/9,
                                    child: const Text(
                                      '3.000',
                                      style: TextStyle(
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                                onPressed: (int index) {
                                  for (var i=0;i<4;i++){
                                    i!=index? c.isSelectedBundle[i] = false
                                        : c.isSelectedBundle[i] = true;
                                  }
                                  c.changeLevel(index);
                                  Navigator.pop(context);
                                },
                                isSelected: c.isSelectedBundle,
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                  const SizedBox(height: 10),
                  Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            child: GetBuilder<Controller>(
                              builder: (_) => ToggleButtons(
                                fillColor: backgroundColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30)
                                ),
                                disabledColor: themeColor,
                                children: <Widget>[
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width*0.7-23)/2,
                                    child: Text(
                                      c.language.string == 'VN'? 'chủ đề':'category',
                                      style: const TextStyle(
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width*0.7-23)/2,
                                    child: Text(
                                      c.language.string == 'VN'? 'từ loại':'type',
                                      style: const TextStyle(
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                                onPressed: (int index) {
                                  for (var i=0;i<2;i++){
                                    i!=index? c.isSelectedSort[i] = false
                                        : c.isSelectedSort[i] = true;
                                  }
                                  c.update();
                                },
                                isSelected: c.isSelectedSort,
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GetBuilder<Controller>(
                      builder: (_) => ListView.builder(
                        // Important: Remove any padding from the ListView.
                          padding: EdgeInsets.zero,
                          itemCount: c.isSelectedSort[0]?c.listCategory.length:c.listType.length,
                          addAutomaticKeepAlives: false,
                          itemBuilder: (BuildContext context, int i) {
                            return Column(
                                children:[
                                  ListTile(
                                    title: GetBuilder<Controller>(
                                      builder: (_) => Text(
                                        c.isSelectedSort[0]?c.listCategory[i]:c.listType[i],
                                        style: const TextStyle(
                                          color: textColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    onTap: () {
                                      c.isSelectedSort[0]?c.changeCategory(i):c.changeType(i);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const Divider(height:1),
                                ]
                            );
                          }
                      ),
                    ),
                  ),
                ]
            )
        ),
      ),
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width*0.7,
        child: Drawer(
          backgroundColor: Colors.white.withOpacity(0.8),
          child: Column(
              children: [
                DrawerHeader(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.4),
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
                Expanded(
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        title: GetBuilder<Controller>(
                          builder: (_) => Text(
                            c.isVip.value? 'VIP' : c.drawerUpgrade.string,
                            style: const TextStyle(
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),),
                        onTap: () {
                          Navigator.pop(context);
                          Get.to(()=>const MyUpgradePage());
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
                          Navigator.pop(context);
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
                          Navigator.pop(context);
                          Get.to(()=> const ScorePage());
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
                                        await boxSetting.put('target',value.toInt());
                                        c.update();
                                      },
                                    ),
                                  ),
                                ]
                            )
                        ),
                      ),
                      const Divider(height:1),
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
                                        fontWeight: FontWeight.w600,
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
                          Navigator.pop(context);
                          Get.to(()=>const PolicyPage());
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
                          Navigator.pop(context);
                          Get.to(()=>const ContactPage());
                        },
                      ),
                      const Divider(height:1),
                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
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
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(0.0),
                          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20,),
                          tooltip: 'Open Sort',
                          onPressed: () {
                            _key.currentState!.openDrawer();
                          },
                        ),
                        GetBuilder<Controller>(
                          builder: (_) => Expanded(
                            child: !c.isSearch.value?
                            Row(
                                children:[
                                  Expanded(
                                    child: Text(
                                      c.categoryIndex.value!=0? c.listCategory[c.categoryIndex.value]
                                          : c.typeIndex.value!=0? c.listType[c.typeIndex.value]:'',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    icon: const Icon(Icons.search_rounded, size: 20,),
                                    tooltip: 'search',
                                    onPressed: () {
                                      c.isSearch = true.obs;
                                      searchFocusNode.requestFocus();
                                      c.update();
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      c.levelIndex.value!=0?c.listLevel[c.levelIndex.value]:'',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ]
                            ):
                            Row(
                                children:[
                                  Expanded(
                                    child: TypeAheadField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: searchField,
                                        autofocus: false,
                                        autocorrect: false,
                                        focusNode: searchFocusNode,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color: textColor,
                                        ),
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black, width:1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)
                                            ),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)
                                            ),
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)
                                            ),
                                          ),
                                          // prefixIcon: Icon(Icons.search_outlined,size:15),
                                          hintText: c.hint.string,
                                          isDense: true,
                                          contentPadding: const EdgeInsets.all(5),
                                          prefixIcon: const Icon(Icons.search),
                                          // icon: Icon(Icons.search),
                                          // isCollapsed: true,
                                        ),
                                        onSubmitted: (value) async {
                                          if (suggestArray.isEmpty){
                                            searchField.text = c.word.string;
                                            if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                                            Get.snackbar(c.learnWrongTitle.string, c.notFound.string);
                                          }else{
                                            c.isSearch = false.obs;
                                            await getWord(suggestArray[0]);
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
                                        c.isSearch = false.obs;
                                        await getWord(suggestion.toString());
                                      },
                                      animationDuration: Duration.zero,
                                      debounceDuration: Duration.zero,
                                    ),
                                  )
                                ]
                            ),
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
                    const SizedBox(height:5),
                    Expanded(
                        child: GestureDetector(
                          onVerticalDragEnd: (details) async {
                            if (details.primaryVelocity! > 0) {
                              await getWord(c.wordPrevious.string);
                            }
                            if (details.primaryVelocity! < -0) {
                              await getWord(c.wordNext.string);
                            }
                          },
                          onHorizontalDragEnd: (details) async {
                            if (details.primaryVelocity! > 0) {
                              if (c.nowMean.value>0){
                                c.nowMean = RxInt(c.nowMean.value-1);
                                c.update();
                              }else{
                                c.nowMean = RxInt(c.imageURL.length-1);
                                c.update();
                              }
                            }
                            if (details.primaryVelocity! < -0) {
                              if (c.nowMean.value<(c.mean.length-1)){
                                c.nowMean = RxInt(c.nowMean.value+1);
                                c.update();
                              }else{
                                c.nowMean = 0.obs;
                                c.update();
                              }
                            }
                          },
                          onDoubleTap: () async {
                            await getNewWord();
                          },
                          onTap:(){
                            if (controller.isAnimating){
                              controller.stop();
                            }else{
                              controller.forward();
                            }
                            if (searchFocusNode.hasFocus){
                              searchFocusNode.unfocus();
                              c.isSearch = false.obs;
                              c.update();
                            }
                          },
                          child: Column(
                              children:[
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
                                            style: TextStyle(
                                              fontSize: 50,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w600,
                                              foreground: Paint()..shader = linearGradient,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 15,
                                                  color: Colors.black.withOpacity(0.5),
                                                  offset: const Offset(3, 3),
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
                                                    future: Future.delayed(Duration(milliseconds: (subMean.key+1)*1000)), // a previously-obtained Future<String> or null
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
                                            :const SizedBox(),
                                        const SizedBox(width:10),
                                      ]
                                  ),
                                ),
                              ]
                          ),
                        )
                    ),
                    GetBuilder<Controller>(
                      builder: (_) => Visibility(
                        visible: c.notifyDaily.value,
                        child: Container(
                          // color: Colors.yellow,
                          // height: 20,
                          child: Opacity(
                            opacity: 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(width: 5),
                                // Expanded(child:Container(height:25,color:Colors.transparent)),
                                PopupMenuButton<Score>(
                                  onSelected: (Score score) async {
                                    await setDefault();
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
                                  child: Row(
                                    children:[
                                      Text(
                                        c.learnedWordsTodayTitle.string
                                            + ' ' + c.listLearnedToday.length.toString()
                                            + '/' + c.target.value.toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: textColor,
                                        ),
                                      ),
                                      // const Icon(
                                      //   Icons.keyboard_arrow_down,
                                      //   size: 25,
                                      // ),
                                    ]
                                  ),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                ),
                                const SizedBox(width:5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
                      ProcessWidget(meanLength: c.mean[c.nowMean.value].length)
                          :const SizedBox(),
                    ),
                    const SizedBox(height:5),
                    Opacity(
                      opacity: 0.6,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width:5),
                          TextButton(
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
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.volume_up_outlined,
                                  size: 25,
                                  color: textColor,
                                ),
                                GetBuilder<Controller>(
                                  builder: (_) => Text(
                                    c.pronun.string,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            onPressed: () {
                              _speak(c.word.string);
                            },
                          ),
                          const Expanded(child:SizedBox()),
                          TextButton(
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
                          const SizedBox(width:5),
                          TextButton(
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
                            onPressed: () async {
                              if (c.word.string != ''){
                                arrangeLearnMean();
                                if (controller.isAnimating){
                                  controller.stop();
                                }
                                Get.to(()=>const LearnWord());
                              }else{
                                if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                                Get.snackbar(c.snackbarFindTitle.string,c.snackbarFindBody.string);
                              }
                            },
                            child: GetBuilder<Controller>(
                              builder: (_) => Text(
                                c.language.string == 'VN'? 'chơi game':'play game',
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(width:5),
                        ],
                      ),
                    ),
                    const SizedBox(height:5),
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
                                onPressed: () async {
                                  await getWord(c.wordNext.string);
                                },
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(0.0),
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  size: 25,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                tooltip: 'next',
                                onPressed: () async {
                                  await getNewWord();
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
                                onPressed: () async {
                                  await getWord(c.wordPrevious.string);
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

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4+widget.meanLength),
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
    if (Get.currentRoute == '/Home' || Get.currentRoute == '/'){
      controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 4+widget.meanLength),
      )..addListener(() async {
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
      controller.forward();
    }
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

    return GestureDetector(
      onDoubleTap: () {
        reset();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
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
                                        for (int i=0; i<c.listArrange.length; i++)
                                          GestureDetector(
                                            onTap: () async {
                                              if (c.listArrange[i] != ''){
                                                c.listRandom[c.listRandom.indexOf('')] = c.listArrange[i];
                                                c.listArrange[i] = '';
                                                c.update();
                                                if (c.enableSound.value){
                                                  await pool.play(soundId);
                                                }
                                              }
                                            },
                                            onDoubleTap: (){},
                                            child: Neumorphic(
                                              style: c.listArrange[i] == ''?
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
                                                  c.listArrange[i],
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
                                        for (int i=0; i<c.listRandom.length; i++)
                                          GestureDetector(
                                            onTap: () async {
                                              if (c.listRandom[i] != ''){
                                                if (c.enableSound.value){
                                                  await pool.play(soundId);
                                                }
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
                                                    }
                                                    await setRight();
                                                    c.currentTab = 1.obs;
                                                    c.update();
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
                                            onDoubleTap: (){},
                                            child: Neumorphic(
                                              style: c.listRandom[i] == ''?
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
                                                  c.listRandom[i],
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
          ],
        ),
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

    return GestureDetector(
      onDoubleTap: () {
        reset();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
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
                                        for (int i=0; i<c.listArrangePronun.length; i++)
                                          GestureDetector(
                                            onTap: () async {
                                              if (c.listArrangePronun[i] != ''){
                                                c.listRandomPronun[c.listRandomPronun.indexOf('')] = c.listArrangePronun[i];
                                                c.listArrangePronun[i] = '';
                                                c.update();
                                                if (c.enableSound.value){
                                                  await pool.play(soundId);
                                                }
                                              }
                                            },
                                            onDoubleTap: (){},
                                            child: Neumorphic(
                                              style: c.listArrangePronun[i] == ''?
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
                                                  c.listArrangePronun[i],
                                                  style: const TextStyle(
                                                    fontSize: 27,
                                                    color: textColor,
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
                                        for (int i=0; i<c.listRandomPronun.length; i++)
                                          GestureDetector(
                                            onTap: () async {
                                              if (c.listRandomPronun[i] != ''){
                                                if (c.enableSound.value){
                                                  await pool.play(soundId);
                                                }
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
                                                    }
                                                    await setRight();
                                                    c.currentTab = 2.obs;
                                                    c.update();
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
                                            onDoubleTap: (){},
                                            child: Neumorphic(
                                              style: c.listRandomPronun[i] == ''?
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
                                                  c.listRandomPronun[i],
                                                  style: const TextStyle(
                                                    fontSize: 27,
                                                    color: textColor,
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
          ],
        ),
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
          }
          await setRight();
          c.currentTab = 3.obs;
          c.update();
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
        onPressed: () async {
          await _speak(c.word.string);
        },
      );
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      c.listenString = ''.obs;
      c.update();
    });

    return GestureDetector(
      child: Container(
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
      )
    );
  }
}

class MeanWidget extends StatelessWidget {
  const MeanWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    List<bool> ktMean = <bool>[for (int i=0; i<c.mean.length; i++)false];

    Future.delayed(Duration.zero, () async {
      c.nowIndex = 0.obs;
      ktMean.clear();
      for (var i=0;i<c.mean.length;i++){
        ktMean.add(false);
      }
      c.update();
    });

    return GestureDetector(
      onHorizontalDragEnd: (details) async {
        if (details.primaryVelocity! > 0) {
          if (c.nowIndex.value > 0){
            c.nowIndex = RxInt(c.nowIndex.value - 1);
          }else{
            c.nowIndex = RxInt(c.imageURL.length-1);
          }
          c.update();
        }
        if (details.primaryVelocity! < 0) {
          if (c.nowIndex.value < c.mean.length - 1){
            c.nowIndex = RxInt(c.nowIndex.value + 1);
          }else{
            c.nowIndex = RxInt(0);
          }
          c.update();
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
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
                      Flexible(
                        child: Text(
                          c.word.string,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 50,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                            foreground: Paint()..shader = linearGradient,
                            shadows: [
                              Shadow(
                                blurRadius: 15,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  )
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
                              child: GetBuilder<Controller>(
                                builder: (_) => Wrap(
                                  spacing: 0,
                                  runSpacing: 0,
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    for (int index=0; index<(c.mean.length<4?c.mean.length:4); index++)
                                      GestureDetector(
                                        onTap: () async {
                                          if (c.enableSound.value){
                                            await pool.play(soundId);
                                          }
                                          if (c.listImage[c.nowIndex.value][index] == c.imageURL[c.listIndex[c.nowIndex.value]]){
                                            ktMean[c.nowIndex.value] = true;
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
                                              for (var i=0;i<c.mean.length;i++){
                                                ktMean.add(false);
                                              }
                                              c.currentTab = 0.obs;
                                            }else{
                                              if (c.nowIndex.value < c.mean.length - 1){
                                                c.nowIndex = RxInt(c.nowIndex.value + 1);
                                              }else{
                                                c.nowIndex = 0.obs;
                                              }
                                            }
                                            c.update();
                                          }else{
                                            ktMean[c.nowIndex.value] = false;
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
                                                          image: NetworkImage('https://bedict.com/' + c.listImage[c.nowIndex.value][index].replaceAll('\\','')),
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
                                                      image: NetworkImage('https://bedict.com/' + c.listImage[c.nowIndex.value][index].replaceAll('\\','')),
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
                                ),
                              ),
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
                  dotsCount: c.mean.length,
                  position: c.nowIndex.value.toDouble(),
                  decorator: DotsDecorator(
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeColor: Colors.black.withOpacity(0.5),
                    color: Colors.black.withOpacity(0.1),
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

    WidgetsBinding.instance?.addPostFrameCallback((_) {

    });

    return Scaffold(
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
                  if (c.currentTab.value>0){
                    getTab(c.currentTab.value-1);
                  }else{
                    getTab(3);
                  }
                }
                if (details.primaryVelocity! < -0) {
                  if (c.currentTab.value<3){
                    getTab(c.currentTab.value+1);
                  }else{
                    getTab(0);
                  }
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
                              tooltip: 'Open Sort',
                              onPressed: () {
                                Get.to(()=> Home());
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
                    color: backgroundColor,
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    const int pageCount = 200;

    Future findHistory() async {
      c.listHistory = await getHistory(c.startDayHistory.value,c.endDayHistory.value);
      c.indexHistoryPage = 0.obs;
      c.update();
    }

    Future.delayed(Duration.zero, () async {
      await findHistory();
    });

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<Controller>(
          builder: (_) => Text(
            c.drawerHistory.string.toUpperCase(),
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
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
              const SizedBox(height: 10),
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
                                onTap: () async {
                                  await setDefault();
                                  await getWord(c.listHistory[c.indexHistoryPage.value*pageCount+index].word);
                                  Get.to(()=>Home());
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
    );
  }
}

class ScorePage extends StatelessWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    const int pageCount = 200;

    Future setHome() async {
      if (c.isSortScore[0]){
        c.level = RxString(listLevelEN[c.levelIndexScore.value]);
        c.levelIndex = c.levelIndexScore;
        c.type = RxString(listTypeEN[c.typeIndexScore.value]);
        c.typeIndex = c.typeIndexScore;
        c.category = RxString(listCategoryEN[c.categoryIndexScore.value]);
        c.categoryIndex = c.categoryIndexScore;
        c.wordArray = c.listWordScore;
        await boxSetting.put('category',c.categoryIndexScore.value);
        await boxSetting.put('type',c.typeIndexScore.value);
        await boxSetting.put('level',c.levelIndexScore.value);
      }else{
        await setDefault();
      }
    }

    Future findScore() async {
      if (c.isSortScore[0]){
        List<String> listWord = [];
        listWord = await getListWords(
          listLevelEN[c.levelIndexScore.value],
          listCategoryEN[c.categoryIndexScore.value],
          listTypeEN[c.typeIndexScore.value],
        );
        if (listWord.isNotEmpty){
          c.listWordScore = RxList(listWord);
        }
        c.listLearned = await getListScore();
      }else{
        c.listLearned = await getListScoreTime(c.startDay.value,c.endDay.value);
      }
      c.indexScorePage = 0.obs;
      c.update();
    }

    Future.delayed(Duration.zero, () async {
      await findScore();
    });

    return Scaffold(
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
                builder: (_) => Container(
                  alignment: Alignment.center,
                  height: 45,
                  child: ToggleButtons(
                    fillColor: backgroundColor,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(10)
                    ),
                    children: <Widget>[
                      SizedBox(
                        width: (MediaQuery.of(context).size.width-23)/2,
                        child: Text(
                          c.language.string == 'VN'? 'Theo phân loại'
                              : 'By distinguishing',
                          style: const TextStyle(
                            fontSize: 14,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width-23)/2,
                        child: Text(
                          c.language.string == 'VN'? 'Theo thời gian'
                              : 'By time',
                          style: const TextStyle(
                            fontSize: 14,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    onPressed: (int index) async {
                      for (var i=0;i<2;i++){
                        i!=index? c.isSortScore[i] = false
                            : c.isSortScore[i] = true;
                      }
                      await findScore();
                    },
                    isSelected: c.isSortScore,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GetBuilder<Controller>(
                builder: (_) => Visibility(
                    visible: c.isSortScore[0],
                    child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                child: ToggleButtons(
                                  fillColor: backgroundColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)
                                  ),
                                  children: <Widget>[
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        c.language.string == 'VN'? 'chủ đề':'category',
                                        style: const TextStyle(
                                          color: textColor,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        c.language.string == 'VN'? 'từ loại':'type',
                                        style: const TextStyle(
                                          color: textColor,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                  onPressed: (int index) {
                                    for (var i=0;i<2;i++){
                                      i!=index? c.isSelectedSortScore[i] = false
                                          : c.isSelectedSortScore[i] = true;
                                    }
                                    c.update();
                                  },
                                  isSelected: c.isSelectedSortScore,
                                ),
                              ),
                              const SizedBox(width: 10),
                              PopupMenuButton<String>(
                                onSelected: (String word) async {
                                  if (c.isSelectedSortScore[0]){
                                    c.categoryIndexScore = RxInt(c.listCategory.indexOf(word));
                                    c.typeIndexScore = 0.obs;
                                  }else{
                                    c.typeIndexScore = RxInt(c.listType.indexOf(word));
                                    c.categoryIndexScore = 0.obs;
                                  }
                                  await findScore();
                                },
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  for (int i=0; i<(c.isSelectedSortScore[0]? c.listCategory.length:c.listType.length); i++)
                                    PopupMenuItem<String>(
                                        value: c.isSelectedSortScore[0]? c.listCategory[i]:c.listType[i],
                                        padding: const EdgeInsets.fromLTRB(6,0,6,0),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                c.isSelectedSortScore[0]? c.listCategory[i]:c.listType[i],
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
                                        c.isSelectedSortScore[0]? c.listCategory[c.categoryIndexScore.value]:c.listType[c.typeIndexScore.value],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: textColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 25,
                                      ),
                                    ]
                                ),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                                ),
                              ),
                              Expanded(
                                child: PopupMenuButton<String>(
                                  onSelected: (String word) async {
                                    c.levelIndexScore = RxInt(c.listLevel.indexOf(word));
                                    await findScore();
                                  },
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    for (int i=0; i<c.listLevel.length; i++)
                                      PopupMenuItem<String>(
                                          value: c.listLevel[i],
                                          padding: const EdgeInsets.fromLTRB(6,0,6,0),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  c.listLevel[i],
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          c.listLevel[c.levelIndexScore.value],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 25,
                                        ),
                                      ]
                                  ),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children:[
                                const SizedBox(width: 13),
                                Expanded(
                                  child: GetBuilder<Controller>(
                                    builder: (_) => Text(
                                      (c.language.string == 'VN'? 'đã học (' : 'learned (')
                                          + c.listLearned.length.toString() + ')',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GetBuilder<Controller>(
                                    builder: (_) => Text(
                                      (c.language.string == 'VN'? 'chưa học (' : 'not yet (')
                                          + (c.listWordScore.length - c.listLearned.length).toString() + ')',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 13),
                              ]
                          ),
                          const SizedBox(height: 3),
                          Row(
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GetBuilder<Controller>(
                                    builder: (_) => LinearPercentIndicator(
                                      alignment: MainAxisAlignment.center,
                                      // width: MediaQuery.of(context).size.width-20,
                                      lineHeight: 18,
                                      percent: c.listLearned.length/c.listWordScore.length,
                                      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
                                      progressColor: backgroundColor,
                                      // padding: const EdgeInsets.all(5),
                                      animation: true,
                                      center: Text(
                                          c.listWordScore.length.toString() +
                                              (c.language.string == 'VN'? ' từ' : ' words'),
                                          style: const TextStyle(
                                            fontSize: 10,
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ]
                          ),
                        ]
                    )
                ),
              ),
              GetBuilder<Controller>(
                builder: (_) => Visibility(
                    visible: c.isSortScore[1],
                    child: Column(
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
                    )
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
                child: SingleChildScrollView(
                  child: Column(
                    children:[
                      GetBuilder<Controller>(
                        builder: (_) => Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            runAlignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            children: [
                              for (var i=pageCount*c.indexScorePage.value;
                              i<(c.listLearned.length~/pageCount>c.indexScorePage.value?
                              pageCount*c.indexScorePage.value+pageCount:
                              pageCount*c.indexScorePage.value+c.listLearned.length%pageCount); i++)
                                GestureDetector(
                                  onTap: () async{
                                    await setHome();
                                    await getWord(c.listLearned[i].wordId);
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
                                    ),
                                    child: Column(
                                        children: [
                                          const SizedBox(height:5),
                                          Text(
                                            c.listLearned[i].wordId,
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
                                                  percent: c.listLearned[i].word/25,
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
                                                  percent: c.listLearned[i].pronun/25,
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
                                                  percent: c.listLearned[i].speak/25,
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
                                                  percent: c.listLearned[i].mean/25,
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
                                              percent: c.listLearned[i].total/100,
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
                                )
                            ]
                        ),
                      ),
                      const SizedBox(height: 10),
                    ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: backgroundColor,
        child: GetBuilder<Controller>(
          builder: (_) => Text(
            c.newRandomWordTitle.string,
            style: const TextStyle(
              color: textColor,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () async {
          if (c.listWordScore.isNotEmpty){
            await setHome();
            await getNewWord();
            Get.to(()=>Home());
          }else{
            Get.to(()=>Home());
          }
        }
      ),
    );
  }
}

class MyUpgradePage extends StatelessWidget {
  const MyUpgradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Controller c = Get.put(Controller());

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<Controller>(
          builder: (_) => Text(
            c.drawerUpgrade.string.toUpperCase(),
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),),
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
                          onPressed: () {
                            if (!c.isVip.value){
                              final ProductDetails productDetails = c.products[0];
                              final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
                              InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
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
                  Flexible(
                    child: GetBuilder<Controller>(
                      builder: (_) => Text(
                        c.language.value == 'VN'?
                        'đăng kí 1 năm sử dụng ứng dụng không bị làm phiền bởi quảng cáo,'
                            ' giúp chúng tôi duy trì ứng dụng này tới mọi người,'
                            ' hết thời gian ứng dụng sẽ được gia hạn tự động':
                        'register 1 year using this app without advertisement,'
                            ' helping us distribute this app to people, this app auto renews',
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
          ],
        ),
      ),
    );
  }
}

Future<bool> _verifyPurchase(String token) async {
  // IMPORTANT!! Always verify a purchase before delivering the product.
  // For the purpose of an example, we directly return true.
  final Controller c = Get.put(Controller());
  String url = Platform.isAndroid? 'https://bedict.com/checkPay.php':'https://bedict.com/checkPayIos.php';
  final response = await http.post(
    Uri.parse(url),
    body: <String, String>{
      'token': token,
    },
  );
  if (response.statusCode == 200) {
    if (response.body != 'error'){
      c.expire = RxInt(int.parse(response.body));
      return true;
    }else{
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> checkExpire(String token) async {
  // IMPORTANT!! Always verify a purchase before delivering the product.
  // For the purpose of an example, we directly return true.
  final Controller c = Get.put(Controller());
  String url = Platform.isAndroid? 'https://bedict.com/checkExpire.php':'https://bedict.com/checkExpireIos.php';
  final response = await http.post(
    Uri.parse(url),
    body: <String, String>{
      'token': token,
    },
  );
  if (response.statusCode == 200) {
    if (response.body != 'error'){
      c.expire = RxInt(int.parse(response.body));
      return true;
    }else{
      return false;
    }
  } else {
    return false;
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

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
                    'Trần Trung Hiếu built the BeDict app as a Free app. This SERVICE is provided by'
                        ' Trần Trung Hiếu at no cost and is intended for use as is.',
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
                      ' as in our Terms and Conditions, which is accessible at'
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
                        ' used by the app\nGoogle Play Services: https://www.google.com/policies/privacy/'
                        '\nAdMob https://support.google.com/admob/answer/6128543?hl=en'
                        '\nI want to inform you that whenever'
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
                    'These Services do not address anyone under the age of 13.'
                      ' I do not knowingly collect personally'
                      ' identifiable information from children under 13. In the case'
                      ' I discover that a child under 13 has provided'
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
            Navigator.pop(context);
          },
          onCancel: () async {
            Navigator.pop(context);
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

Future<List<String>> getListWords(String levelString, String category, String type) async {
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
  for (var i=0;i<box.length;i++){
    var nowWord = await box.getAt(i);
    if (category != 'all category'){
      if (category == 'no category'){
        if (nowWord['category'] == ',' && int.parse(nowWord['level']) <= level){
          findList.add(nowWord['word']);
        }
      }else{
        if (nowWord['category'].contains(','+ category) && int.parse(nowWord['level']) <= level){
          findList.add(nowWord['word']);
        }
      }
    }else{
      if (type != 'all type'){
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

Future showFullScreenAd(String word) async {
  final Controller c = Get.put(Controller());
  InterstitialAd.load(
    adUnitId: Platform.isAndroid ? 'ca-app-pub-9467993129762242/1735030175':'ca-app-pub-9467993129762242/5200342904',
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        // Keep a reference to the ad so you can show it later.
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (InterstitialAd ad) {},
          onAdDismissedFullScreenContent: (InterstitialAd ad) async {
            ad.dispose();
            await c.layWord(word);
            c.isAdShowing = false.obs;
          },
          onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) async {
            ad.dispose();
            await c.layWord(word);
            c.isAdShowing = false.obs;
          },
          onAdImpression: (InterstitialAd ad) {},
        );
        ad.show();
      },
      onAdFailedToLoad: (LoadAdError error) async {
        c.isAdShowing = false.obs;
        await c.layWord(word);
      },
    )
  );
}

Future showAdLearn(int tab) async {
  final Controller c = Get.put(Controller());
  InterstitialAd.load(
    adUnitId: Platform.isAndroid ? 'ca-app-pub-9467993129762242/1735030175':'ca-app-pub-9467993129762242/5200342904',
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        // Keep a reference to the ad so you can show it later.
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (InterstitialAd ad) {},
          onAdDismissedFullScreenContent: (InterstitialAd ad) async {
            ad.dispose();
            c.isAdShowing = false.obs;
            c.currentTab = RxInt(tab);
            c.update();
          },
          onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) async {
            ad.dispose();
            c.isAdShowing = false.obs;
            c.currentTab = RxInt(tab);
            c.update();
          },
          onAdImpression: (InterstitialAd ad) {},
        );
        ad.show();
      },
      onAdFailedToLoad: (LoadAdError error) {
        c.isAdShowing = false.obs;
        c.currentTab = RxInt(tab);
        c.update();
      },
    )
  );
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
    if (c.mean.length<4){
      subListImage = List<String>.from(c.imageURL.toList());
    }else{
      subListImage.add(c.imageURL[c.listIndex[i]]);
      for (var j=0;j<3;j++){
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

Future getNewWord() async {
  final Controller c = Get.put(Controller());
  if (!c.isAdShowing.value){
    String newRandomWord = '';
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
      Get.snackbar(c.language.string == 'VN'?'Chúc mừng':'Congratulation',c.all.string);
    }else{
      if (c.isVip.value){
        await c.layWord(newRandomWord);
      }else{
        int isShowAd = Random().nextInt(9);
        if (isShowAd == 0){
          c.isAdShowing = true.obs;
          await showFullScreenAd(newRandomWord);
        }else{
          await c.layWord(newRandomWord);
        }
      }
    }
  }
}

Future getWord(String word) async {
  final Controller c = Get.put(Controller());
  if (!c.isAdShowing.value){
    if (c.isVip.value){
      await c.layWord(word);
    }else{
      int isShowAd = Random().nextInt(9);
      if (isShowAd == 0){
        c.isAdShowing = true.obs;
        await showFullScreenAd(word);
      }else{
        await c.layWord(word);
      }
    }
  }
}

void getTab(int tab) {
  final Controller c = Get.put(Controller());
  if (!c.isAdShowing.value){
    if (c.isVip.value){
      c.currentTab = RxInt(tab);
      c.update();
    }else{
      int isShowAd = Random().nextInt(9);
      if (isShowAd == 0){
        c.isAdShowing = true.obs;
        showAdLearn(tab);
      }else{
        c.currentTab = RxInt(tab);
        c.update();
      }
    }
  }
}

Future _speak(String string) async{
  final Controller c = Get.put(Controller());
  await flutterTts.setLanguage("en-US");
  await flutterTts.setSpeechRate(c.speakSpeed.value);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.0);
  await flutterTts.awaitSpeakCompletion(true);
  await flutterTts.speak(string);
}

Future speakMean(String string) async{
  final Controller c = Get.put(Controller());
  if (c.language.string == 'VN'){
    await flutterTts.setLanguage("vi-VN");
  }else{
    await flutterTts.setLanguage("en-US");
  }
  await flutterTts.setSpeechRate(c.speakSpeed.value);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.0);
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
  await updateToday();
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
  await updateToday();
}

Future updateToday() async{
  final Controller c = Get.put(Controller());
  var yesterday = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
  );
  c.listLearnedToday.clear();
  c.listLearnedToday = RxList(await getListScoreTime(yesterday.millisecondsSinceEpoch,DateTime.now().millisecondsSinceEpoch));
  c.update();
}

Future setDefault() async {
  final Controller c = Get.put(Controller());
  await boxSetting.put('category',0);
  await boxSetting.put('type',0);
  await boxSetting.put('level',0);
  c.category = RxString('all category');
  c.type = RxString('all type');
  c.level = RxString('all words');
  c.categoryIndex = 0.obs;
  c.typeIndex = 0.obs;
  c.levelIndex = 0.obs;
  c.wordArray.clear();
  List<String> listWord = [];
  listWord = await getListWords(
    listLevelEN[0],
    listCategoryEN[0],
    listTypeEN[0],
  );
  c.wordArray = RxList(listWord);
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

Future<List<Score>> getListScore() async {
  final Controller c = Get.put(Controller());
  List<Score> findList = <Score>[];
  for (var i=0;i<c.listWordScore.length;i++){
    var nowWord = await boxScore.get(c.listWordScore[i]);
    if (nowWord[5]>0){
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

Future<bool> checkScore(String wordScore) async {
  List score = await boxScore.get(wordScore) ?? [];
  if (score[5]>0) {
    return true;
  }else{
    return false;
  }
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
  if (wordShow != 'Daily'){

    final Controller c = Get.put(Controller());

    c.category = RxString('category');
    await boxSetting.put('category',0);

    c.type = RxString('type');
    await boxSetting.put('type',0);

    c.categoryIndex = 0.obs;
    c.typeIndex = 0.obs;
    c.levelIndex = 0.obs;

    c.level = RxString('all words');
    await boxSetting.put('level',0);

    final String response = await rootBundle.loadString('assets/allWords.json');
    final data = await json.decode(response);
    c.wordArray = data.cast<String>();

    c.word = RxString(wordShow);

    await c.layWord(c.word.string);
  }
  Get.to(()=>Home());
}