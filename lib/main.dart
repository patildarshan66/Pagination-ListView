import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pagination_list_view/favoritePhotos/view/favorite_photos.dart';
import 'package:pagination_list_view/favoritePhotos/vm/vm_favorite_photos.dart';
import 'package:pagination_list_view/pagination/view/pagination_view.dart';
import 'package:pagination_list_view/pagination/vm/vm_pagination.dart';
import 'package:pagination_list_view/splash_screen.dart';
import 'package:provider/provider.dart';
import 'additionalFiles/routes.dart';
import 'authentication/view/authentication.dart';
import 'authentication/vm/vm_authentication.dart';
import 'connectivity/view/network_aware_widget.dart';
import 'connectivity/vm/network_status_checker.dart';
import 'connectivity/view/offline_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VmAuthentication()),
        ChangeNotifierProvider(create: (context) => VmFavoritePhotos()),
        ChangeNotifierProvider(create: (context) => VmPagination()),
        ChangeNotifierProvider(create: (context) => VmNetworkStatus()),
      ],
      child: MaterialApp(
        title: 'Pagination Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: Routes.generateRoute,
        home:  StreamProvider<bool>(
        initialData: true,
        create: (context) =>
        VmNetworkStatus().networkStatusController.stream,
        child: NetworkAwareWidget(
          onlineChild: Consumer<VmAuthentication>(builder: (ctx, auth, _) {
            return auth.isAuth
                ? const MainPage()
                : FutureBuilder(
              future: auth.tryAutologin(),
              builder: (ctx, authResultSnapShot) =>
              authResultSnapShot.connectionState ==
                  ConnectionState.waiting
                  ? const SplashScreen()
                  : const Authentication(),
            );
          }),
          offlineChild: const OfflineScreen(),
        ),
      ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final StreamController<bool> _stateController = StreamController.broadcast();

  @override
  void dispose() {
    _stateController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == null) {
      _selectedIndex = ModalRoute.of(context).settings.arguments;
      _selectedIndex ??= 0;
    }
    return StreamBuilder(
      stream: _stateController.stream,
      builder: (ctx, snapshot) => Scaffold(
        bottomNavigationBar: _getBottomNavigationBar(),
        appBar: _getAppBar(),
        body: _getMainBody(),
      ),
    );
  }

  Widget _getMainBody() {
    switch (_selectedIndex) {
      case 0:
        return const PaginationView();
        break;
      case 1:
        return const FavoritePhotos();
        break;
      default:
        return const PaginationView();
        break;
    }
  }

  BottomNavigationBar _getBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: _selectedIndex,
      onTap: (value) {
        if (_selectedIndex != value) {
          _selectedIndex = value;
          _stateController.add(true);
        }
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Photos',
          icon: Icon(Icons.collections),
        ),
        BottomNavigationBarItem(
          label: 'Favorites',
          icon: Icon(Icons.favorite),
        ),
      ],
    );
  }

  AppBar _getAppBar() {
    var userData = Provider.of<VmAuthentication>(context, listen: false);
    return AppBar(
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 5, bottom: 5),
        child: userData != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  userData.profilePicUrl,
                ),
                backgroundColor: Colors.transparent,
              )
            : const Icon(Icons.person),
      ),
      title: Text(userData?.username?? 'No Name'),
    );
  }
}
